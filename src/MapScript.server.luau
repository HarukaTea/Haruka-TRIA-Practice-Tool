--!nocheck

--[[
	For help on how to map maps see https://tria-studio.github.io/Tria-Escape-MapLib/api/MapLib/
]]

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map.MapScripts

local players = MapLib:GetPlayers() :: table

local RepS = game:GetService("ReplicatedStorage")
local StarterPack = game:GetService("StarterPack")

local instanceNew = Instance.new
local wait = task.wait

--// Setups modules
if RepS:FindFirstChild("HarukaModules") then RepS.HarukaModules:Destroy() end
local modules = map.Modules :: Folder
modules.Name = "HarukaModules"
modules.Parent = RepS

RepS:SetAttribute("HarukaModulesLoaded", true)

--// Give noclip
local noclip = instanceNew("HopperBin")
noclip.Name = "Noclip"
noclip:SetAttribute("Speed", 60)
map.Projectiles.NoclipControl:Clone().Parent = noclip

for _, plr: Player in players do
	if plr.Backpack:FindFirstChild("Noclip") then plr.Backpack.Noclip:Destroy() end

	noclip:Clone().Parent = plr.Backpack
end
if StarterPack:FindFirstChild("Noclip") then StarterPack.Noclip:Destroy() end
noclip:Clone().Parent = StarterPack

--// Load UI
for _, plr: Player in players do
	local plrGui = plr.PlayerGui

	if plrGui:FindFirstChild("HarukaPanel") then plrGui.HarukaPanel:Destroy() end
	local screenGui = instanceNew("ScreenGui")
	screenGui.Name = "HarukaPanel"
	screenGui.ClipToDeviceSafeArea = false
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ScreenInsets = Enum.ScreenInsets.None
	screenGui.DisplayOrder = 100
	screenGui.Parent = plr.PlayerGui

	map.Projectiles.HarukaPanelStarter:Clone().Parent = screenGui
end

MapLib:Alert("Haruka Practice Tools Loaded!", "white", 5)

--// Clear
MapLib.RoundEnding:Connect(function()
	RepS:SetAttribute("HarukaModulesLoaded", nil)
end)

--// Finish
wait(2)
players = MapLib:GetPlayers() :: table

for _, plr: Player in players do
	if plr then MapLib:Survive(plr) end
end
