--!nocheck

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map.MapScripts :: Folder

local players = MapLib:GetPlayers() :: { Player }

local CollectionService = game:GetService("CollectionService")
local RepS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local wait = task.wait


--// Init packages
do
	for _, folder in CollectionService:GetTagged("_HARUKA_SHARED") do
		folder:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = "HarukaShared"
	folder:AddTag("_HARUKA_SHARED")

	map.Shared:Clone().Parent = folder
	folder.Shared.UIAtlas.Parent = folder

	folder.Parent = RepS

	RepS:SetAttribute("_HarukaSharedLoaded", true)
end


--// Clear
do
	MapLib.RoundEnding:Once(function()
		RepS:SetAttribute("_HarukaSharedLoaded", nil)
	end)
end



--// Load UI
do
	local function _safeCheck(plr: Player) : boolean
		if not plr then return false end
		if not plr.Character then return false end
		if not plr.Character.PrimaryPart then return false end

		return true
	end
	for _, gui: ScreenGui in CollectionService:GetTagged("_HARUKA_PANEL") do
		gui:Destroy()
	end

	RunService.Stepped:Wait()
	for _, plr: Player in players do
		if not _safeCheck(plr) then continue end

		local plrGui = plr:FindFirstChildOfClass("PlayerGui")

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "HarukaPanel"
		screenGui:AddTag("_HARUKA_PANEL")
		screenGui.AutoLocalize = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.ClipToDeviceSafeArea = false
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.ScreenInsets = Enum.ScreenInsets.None
		screenGui.DisplayOrder = 15.99

		local panel = map.Projectiles.HarukaPanel:Clone()
		local loader = map.Projectiles.HarukaPanelLoader:Clone()
		local postStroke = map.Projectiles.HarukaPostStroke:Clone()

		panel.Parent = screenGui
		loader.Parent = screenGui
		postStroke.Parent = screenGui

		loader.Disabled = false
		postStroke.Disabled = false

		screenGui.Parent = plrGui
	end


	MapLib:Alert("Fallen Practice Tools Loaded!", "green", 5.99)
	MapLib:Alert("Latest Version: 1.3, Released on 2025-02-04", "yellow", 5.99)
	MapLib:Alert("1.3 Updates: Patches for Mobile", "yellow", 5.99)
end
