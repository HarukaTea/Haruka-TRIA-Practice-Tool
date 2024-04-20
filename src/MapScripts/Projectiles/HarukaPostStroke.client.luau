--!nocheck
--!optimize 2
--!native

local CS = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")

local plr = Players.LocalPlayer

local strokes = {}

local v2New = Vector2.new
local clock = os.clock

local DESIGN_VP_SIZE = v2New(1184, 466)

--// Tag UI
local function _calScreenRatio() : number
    local function average(vector2: Vector2) : number
        return (vector2.X + vector2.Y) / 2
    end

    return average(workspace.CurrentCamera.ViewportSize) / average(DESIGN_VP_SIZE)
end

-- Connections
local function strokeAdded(added: UIStroke)
    strokes[added] = added.Thickness

    added.Thickness *= _calScreenRatio()
end
CS:GetInstanceAddedSignal("ScreenStroke"):Connect(strokeAdded)

-- Setups
local function updateStroke()
    local fpsLimit, lastTick = 0.5, 0

    RS.Heartbeat:Connect(function()
        if clock() - lastTick >= fpsLimit then
            lastTick = clock()

            for i, thickness in strokes do
                if not i.Parent then
                    strokes[i] = nil
                else
                    i.Thickness = thickness * _calScreenRatio()
                end
            end
        end
    end)

    for _, element in plr.PlayerGui:WaitForChild("HarukaPanel"):GetDescendants() do
        if element:IsA("UIStroke") then CS:AddTag(element, "ScreenStroke") end
    end
    plr.PlayerGui:WaitForChild("HarukaPanel").DescendantAdded:Connect(function(descendant)
        if descendant:IsA("UIStroke") then CS:AddTag(descendant, "ScreenStroke") end
    end)
end
updateStroke()
