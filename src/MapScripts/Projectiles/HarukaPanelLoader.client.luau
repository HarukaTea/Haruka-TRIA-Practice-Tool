--!nocheck

if script:IsDescendantOf(workspace) then return end

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer

local wait = task.wait

repeat wait() until RepS:GetAttribute("_HarukaSharedLoaded")

--// Pre-define functions

local function placeNoclip()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

    local tools = #CollectionService:GetTagged("_HARUKA_TOOL")
    if tools >= 1 then return end


    local PlayerScripts = plr:FindFirstChildOfClass("PlayerScripts")
	local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule", 999))
	local ControlModule = PlayerModule:GetControls()


    local noclip = Instance.new("Tool")
    noclip.Name = "Noclip"
    noclip:AddTag("_HARUKA_TOOL")

    noclip.ToolTip = "Gain access to noclip mode."
    noclip.RequiresHandle = false
    noclip.CanBeDropped = false
    task.defer(function()
        while noclip and noclip.Parent do
            noclip.Enabled = true
            wait(0.15)
        end
    end)


    local function _getNextMovement(deltaTime) : Vector3
        local nextMove = ControlModule:GetMoveVector() or Vector3.zero

        if UIS:IsKeyDown("Space") then
            nextMove = Vector3.new(nextMove.X, 1, nextMove.Z)

        elseif UIS:IsKeyDown("LeftControl") then
            nextMove = Vector3.new(nextMove.X, nextMove.Y - 1, nextMove.Z)
        end

        nextMove = nextMove.Magnitude > 1 and nextMove.Unit or nextMove
        nextMove = nextMove * deltaTime * (RepS:GetAttribute("_HARUKA_GlobalNoclipSpeed") or 60)

        return nextMove
    end

    local conn: RBXScriptConnection = nil
    local function onSelected()
        local char = Players.LocalPlayer.Character

        if char then
            local humanoid = char:WaitForChild("Humanoid")
            local HRP = humanoid.RootPart
            local head = char:WaitForChild("Head") :: BasePart
            local camera = workspace.CurrentCamera

            HRP.Anchored = true
            HRP.Velocity = Vector3.zero
            HRP.CanTouch = false

            humanoid.PlatformStand = true
            head.CanTouch = false

            conn = RunService.Heartbeat:Connect(function(dt)
                local movement = _getNextMovement(dt)

                HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + camera.CFrame.LookVector) * CFrame.new(movement)
            end)
        end
    end
    local function onDeselected()
        local char = Players.LocalPlayer.Character

        if conn then conn:Disconnect() end
        if char then
            local humanoid = char:WaitForChild("Humanoid")
            local HRP = humanoid.RootPart
            local head = char:WaitForChild("Head")

            HRP.Anchored = false
            HRP.Velocity = Vector3.zero
            humanoid.PlatformStand = false

            HRP.CanTouch = true
            head.CanTouch = true

            --// avoid fling
            HRP.CFrame = CFrame.fromOrientation(
                -math.pi / 4,
                (select(2, HRP.CFrame:ToOrientation())),
                0
            ) + HRP.Position
        end
    end
    noclip.Equipped:Connect(onSelected)
    noclip.Unequipped:Connect(onDeselected)


    noclip.Parent = plr:FindFirstChildOfClass("Backpack")
end


--// Init panel

do
    task.defer(function()
        require(script.Parent:WaitForChild("HarukaPanel"))(plr)
    end)
end



--// Init noclip

do
    task.defer(function()
        for _, tool: HopperBin in CollectionService:GetTagged("_HARUKA_TOOL") do
            tool:Destroy()
        end
        placeNoclip()
    end)
end
do
    task.defer(function()
        while wait(0.5) do placeNoclip() end
    end)
end
