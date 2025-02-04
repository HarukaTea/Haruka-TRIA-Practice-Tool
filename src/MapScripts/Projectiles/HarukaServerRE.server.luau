--!nocheck

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local MapLib = game.GetMapLib:Invoke()()

MapLib:Alert("Extra Addon Loaded", "green", 3)

script:AddTag("_HARUKA_PANEL")

--// Init
do
    local timeStopRE = Instance.new("RemoteEvent")
    timeStopRE.Name = "_Haruka_TimeStop"
    timeStopRE.Parent = script


    timeStopRE.OnServerEvent:Connect(function()
        local map = MapLib.map :: Model

        map:SetAttribute("_Haruka_IsTimeStop", true)

        for _, obj: Instance in map:GetDescendants() do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                obj:Destroy()
            end
        end

        RunService.Heartbeat:Wait()

        local mapScript = game:FindFirstChild("MapScript", true)
        if mapScript then mapScript:Destroy() end


        for _ = 1, #Players:GetPlayers() do
            local localMapScript = game:FindFirstChild("LocalMapScript", true)
            local effectScript = game:FindFirstChild("EffectScript", true)

            if localMapScript then localMapScript:Destroy() end
            if effectScript then effectScript:Destroy() end
        end
    end)
end