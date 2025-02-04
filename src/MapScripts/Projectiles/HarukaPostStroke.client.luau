--!nocheck

if script:IsDescendantOf(workspace) then return end

local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local plrGui = plr:FindFirstChildOfClass("PlayerGui")

local camera = workspace.CurrentCamera
local normalUIStrokes = {}
local billboardUIStrokes = {}

local DESIGN_VP_SIZE = Vector2.new(1172, 466.4)


--// Helper functions

local function __getBox(vector: Vector2) : number
	return math.min(vector.X, vector.Y)
end
local function _calScreenRatio() : number
	return __getBox(camera.ViewportSize) / __getBox(DESIGN_VP_SIZE)
end
local function _getInstancePosition(instance: Instance): Vector3
	if instance:IsA("BasePart") then
		instance = instance :: BasePart

		return instance.Position

	elseif instance:IsA("Model") then
		instance = instance :: Model

		local cf, _ = instance:GetBoundingBox()
		return cf.Position
	end

	return Vector3.zero
end

--// Private functions

local function _strokeAdded(added: Instance)
	if added:IsA("UIStroke") and not added:GetAttribute("AlreadyTransformed") then
		if not added:IsDescendantOf(script.Parent) then return end

		if added:FindFirstAncestorOfClass("BillboardGui") then
			billboardUIStrokes[added] = added.Thickness
		else
			normalUIStrokes[added] = added.Thickness
		end

		added:SetAttribute("AlreadyTransformed", true)
	end
end

--// Init

for _, child: Instance in plrGui:GetDescendants() do
	_strokeAdded(child)
end
plrGui.DescendantAdded:Connect(_strokeAdded)


local function _updateStroke(stroke: UIStroke, belongTo: "Billboard" | "Normal", thickness: number)
    local finalThickness = 0

    if belongTo == "Billboard" then
        local billboardGui = stroke:FindFirstAncestorOfClass("BillboardGui")
        local adornee = billboardGui.Adornee
        local origin = _getInstancePosition(adornee)
        local magnitude = (camera.CFrame.Position - origin).Magnitude
        local distanceRatio = ((billboardGui:GetAttribute("Distance") or 15.99) / magnitude)

        finalThickness = thickness * distanceRatio * _calScreenRatio()
        finalThickness = math.clamp(finalThickness, 0, 4)

    elseif belongTo == "Normal" then
        finalThickness = thickness * _calScreenRatio()
        finalThickness = math.clamp(finalThickness, 0, 4)
    end

    stroke.Thickness = finalThickness
end
local function _updateSize()
	for stroke: UIStroke, thickness: number in normalUIStrokes do
		if not stroke.Parent then
			normalUIStrokes[stroke] = nil
		else
			_updateStroke(stroke, "Normal", thickness)
		end
	end
	for stroke: UIStroke, thickness: number in billboardUIStrokes do
		if not stroke.Parent then
			billboardUIStrokes[stroke] = nil
		else
			_updateStroke(stroke, "Billboard", thickness)
		end
	end
end
task.defer(function()
	while task.wait(0.5) do _updateSize() end
end)
