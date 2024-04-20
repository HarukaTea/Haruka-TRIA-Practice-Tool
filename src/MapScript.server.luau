--!nocheck
--!optimize 2
--!native

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map.MapScripts :: Folder

local players = MapLib:GetPlayers() :: { Player }

local RepS = game:GetService("ReplicatedStorage")
local StarterPack = game:GetService("StarterPack")
local StarterCharacterScripts = game:GetService("StarterPlayer").StarterCharacterScripts

local instanceNew = Instance.new

--// Setup packages
if RepS:FindFirstChild("HarukaModules") then RepS.HarukaModules:Destroy() end
local modules = map.Modules :: Folder
modules.Name = "HarukaModules"
modules.Parent = RepS

RepS:SetAttribute("HarukaModulesLoaded", true)

--// Give noclip
local noclip = instanceNew("HopperBin")
noclip.Name = "Noclip"
noclip:SetAttribute("Speed", 60)
map.Projectiles.HarukaNoclipControl:Clone().Parent = noclip

for _, plr: Player in players do
	if not plr then continue end

	if plr.Backpack:FindFirstChild("Noclip") then plr.Backpack.Noclip:Destroy() end

	noclip:Clone().Parent = plr.Backpack
end
if StarterPack:FindFirstChild("Noclip") then StarterPack.Noclip:Destroy() end
noclip:Clone().Parent = StarterPack

--// Place package
for _, plr: Player in players do
	if not plr then continue end
	if not plr.Character then continue end

	if plr.Character:FindFirstChild("HarukaPostStroke") then plr.Character.HarukaPostStroke:Destroy() end
	map.Projectiles.HarukaPostStroke:Clone().Parent = plr.Character
end
if StarterCharacterScripts:FindFirstChild("HarukaPostStroke") then StarterCharacterScripts.HarukaPostStroke:Destroy() end
map.Projectiles.HarukaPostStroke:Clone().Parent = StarterCharacterScripts

--// Load UI
for _, plr: Player in players do
	if not plr then continue end
	if not plr.Character then continue end

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

	map.Projectiles.HarukaPanel:Clone().Parent = screenGui
	map.Projectiles.HarukaPanelLoader:Clone().Parent = screenGui
end

MapLib:Alert("Fallen Practice Tools Loaded, Good Luck!", "white", 5.99)

--// Clear
local function roundEnded()
	RepS:SetAttribute("HarukaModulesLoaded", nil)
end
MapLib.RoundEnding:Once(roundEnded)
