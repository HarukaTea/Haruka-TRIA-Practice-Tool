require(game:GetService("ServerScriptService").Runtime):Init()

local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local SG = game:GetService("StarterGui")

local plr = Players.LocalPlayer

repeat task.wait() until RepS:GetAttribute("HarukaSharedLoaded")

local HarukaLib = require(RepS.HarukaShared.Shared.HarukaLib)

--// Panel, Start!
require(script.Parent.HarukaPanel)(plr)



local function placeNoclip()
    local check = false
    for _, tool: Tool in plr.Backpack:GetChildren() do
        if tool:IsA("HopperBin") and tool:HasTag("HarukaProjectile") then
            check = true
            break
        end
    end
    if check then return end


    local noclip = Instance.new("HopperBin")
    noclip.Name = "Noclip"
    noclip:AddTag("HarukaProjectile")
    noclip:SetAttribute("Speed", RepS:GetAttribute("HARUKA_GlobalNoclipSpeed") or 60)

    local tool = noclip
    local selected = false
    local lastUpdate = 0

    local wait = task.wait
    local v3New, xAxis, yAxis, zAxis = Vector3.new, Vector3.xAxis, Vector3.yAxis, Vector3.zAxis
    local cfNew = CFrame.new

    local function _getNextMovement(deltaTime)
        local nextMove = v3New()

        if UIS:IsKeyDown("A") or UIS:IsKeyDown("Left") then
            nextMove = -xAxis
        elseif UIS:IsKeyDown("D") or UIS:IsKeyDown("Right") then
            nextMove = xAxis
        end

        if UIS:IsKeyDown("W") or UIS:IsKeyDown("Up") then
            nextMove -= zAxis
        elseif UIS:IsKeyDown("S") or UIS:IsKeyDown("Down") then
            nextMove += zAxis
        end

        if UIS:IsKeyDown("Space") then
            nextMove += yAxis
        elseif UIS:IsKeyDown("LeftControl") then
            nextMove -= yAxis
        end

        local speed = noclip:GetAttribute("Speed")
        return cfNew( nextMove * (speed * deltaTime) )
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
            humanoid.PlatformStand = true

            HRP.CanTouch = false
            head.CanTouch = false

            lastUpdate = tick()

            while selected do
                wait()
                local delta = tick() - lastUpdate
                local look = (camera.Focus.Position - camera.CFrame.Position).Unit :: Vector3
                local move = _getNextMovement(delta)
                local pos = HRP.Position

                HRP.CFrame = cfNew(pos, pos + look) * move
                lastUpdate = tick()
            end

            HRP.Anchored = false
            HRP.Velocity = v3New()
            humanoid.PlatformStand = false

            HRP.CanTouch = true
            head.CanTouch = true
        end
    end

    local function onDeselected()
        selected = false
    end

    tool.Selected:Connect(onSelected)
    tool.Deselected:Connect(onDeselected)

    noclip.Parent = plr.Backpack
end
placeNoclip()


HarukaLib.Clock(0.5, function()
    SG:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

	placeNoclip()
end)
