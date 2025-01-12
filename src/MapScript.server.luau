--!nocheck

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map.MapScripts :: Folder

local players = MapLib:GetPlayers() :: { Player }

local RepS = game:GetService("ReplicatedStorage")

local wait = task.wait


--// Init packages
do
	if RepS:FindFirstChild("HarukaShared") then RepS.HarukaShared:Destroy() end

	local folder = Instance.new("Folder")
	folder.Name = "HarukaShared"
	folder:AddTag("_HARUKA_SHARED")
	folder.Parent = RepS
	map.Shared:Clone().Parent = folder
	map.Shared.UIAtlas:Clone().Parent = folder
	folder.Shared.UIAtlas:Destroy()


	RepS:SetAttribute("HarukaSharedLoaded", true)
end



--// Load UI
do
	local function _safeCheck(plr: Player) : boolean
		if not plr then return false end
		if not plr.Character then return false end
		if not plr.Character.PrimaryPart then return false end

		return true
	end
	for _, plr: Player in players do
		if not _safeCheck(plr) then continue end

		local plrGui = plr:FindFirstChildOfClass("PlayerGui")

		if plrGui:FindFirstChild("HarukaPanel") then plrGui.HarukaPanel:Destroy() end

		wait()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "HarukaPanel"
		screenGui:AddTag("_HARUKA_PANEL")
		screenGui.AutoLocalize = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.ClipToDeviceSafeArea = false
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.ScreenInsets = Enum.ScreenInsets.None
		screenGui.DisplayOrder = 999

		map.Projectiles.HarukaPanel:Clone().Parent = screenGui
		map.Projectiles.HarukaPanelLoader:Clone().Parent = screenGui
		map.Projectiles.HarukaPostStroke:Clone().Parent = screenGui

		screenGui.Parent = plrGui
	end

	MapLib:Alert("Fallen Practice Tools V1.2 Loaded!", "green", 5.99)
	task.delay(1.599, function()
		MapLib:Alert("Good Luck on Your Practice Journey!", "green", 5.99)
	end)
end



--// Clear
local function roundEnded()
	RepS:SetAttribute("HarukaSharedLoaded", nil)
end
MapLib.RoundEnding:Once(roundEnded)
