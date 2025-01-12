--!nocheck

local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer

local wait = task.wait

repeat wait() until RepS:GetAttribute("HarukaSharedLoaded")

--// Pre-define functions

local function placeNoclip()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

    local check = false
    for _, tool: Tool in plr.Backpack:GetChildren() do
        if tool:IsA("HopperBin") and tool:HasTag("_HARUKA_TOOL") then
            check = true
            break
        end
    end
    if check then return end


    local PlayerScripts = plr:FindFirstChildOfClass("PlayerScripts")
	local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule", 999))
	local ControlModule = PlayerModule:GetControls()


    local noclip = Instance.new("HopperBin")
    noclip.Name = "Noclip"
    noclip:AddTag("_HARUKA_TOOL")
    noclip:SetAttribute("Speed", RepS:GetAttribute("HARUKA_GlobalNoclipSpeed") or 60)

    local tool = noclip
    local selected = false
    local lastUpdate = 0


    local function _getNextMovement(deltaTime) : Vector3
        local nextMove = ControlModule:GetMoveVector() or Vector3.zero

        if UIS:IsKeyDown("Space") then
            nextMove = Vector3.new(nextMove.X, 1, nextMove.Z)

        elseif UIS:IsKeyDown("LeftControl") then
            nextMove = Vector3.new(nextMove.X, nextMove.Y - 1, nextMove.Z)
        end

        nextMove = nextMove.Magnitude > 1 and nextMove.Unit or nextMove
        nextMove = nextMove * deltaTime * noclip:GetAttribute("Speed")

        return nextMove
    end

    local function onSelected()
        local char = Players.LocalPlayer.Character

        if char then
            local humanoid = char:WaitForChild("Humanoid")
            local HRP = humanoid.RootPart
            local head = char:WaitForChild("Head")
            local camera = workspace.CurrentCamera

            selected = true

            HRP.Anchored = true
            HRP.Velocity = Vector3.zero
            HRP.CanTouch = false

            humanoid.PlatformStand = true
            head.CanTouch = false

            lastUpdate = tick()
            while selected do
                wait()
                local delta = tick() - lastUpdate
                local movement = _getNextMovement(delta)

                HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + camera.CFrame.LookVector) * CFrame.new(movement)

                lastUpdate = tick()
            end
        end
    end
    local function onDeselected()
        local char = Players.LocalPlayer.Character

        selected = false

        if char then
            local humanoid = char:WaitForChild("Humanoid")
            local HRP = humanoid.RootPart
            local head = char:WaitForChild("Head")

            HRP.Anchored = false
            HRP.Velocity = Vector3.zero
            humanoid.PlatformStand = false

            HRP.CanTouch = true
            head.CanTouch = true
        end
    end
    tool.Selected:Connect(onSelected)
    tool.Deselected:Connect(onDeselected)


    noclip.Parent = plr.Backpack
end


--// Init panel

require(script.Parent.HarukaPanel)(plr)


--// Init noclip

for _, tool: Tool in plr.Backpack:GetChildren() do
    if tool:IsA("HopperBin") and tool:HasTag("_HARUKA_TOOL") then
        tool:Destroy()
    end
end
wait()
placeNoclip()


--// Final tracker

task.defer(function()
    while wait(0.5) do placeNoclip() end
end)
