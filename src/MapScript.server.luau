require(game:GetService("ServerScriptService").Runtime):Init()


local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map.MapScripts :: Folder

local players = MapLib:GetPlayers() :: { Player }

local RepS = game:GetService("ReplicatedStorage")


--// Setup packages
if RepS:FindFirstChild("HarukaModules") then RepS.HarukaModules:Destroy() end

local folder = Instance.new("Folder")
folder.Name = "HarukaModules"
folder.Parent = RepS
map.Shared.Parent = folder

RepS:SetAttribute("HarukaModulesLoaded", true)



--// Load UI
for _, plr: Player in players do
	if not plr then continue end
	if not plr.Character then continue end

	local plrGui = plr.PlayerGui

	if plrGui:FindFirstChild("HarukaPanel") then plrGui.HarukaPanel:Destroy() end
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "HarukaPanel"
	screenGui.ClipToDeviceSafeArea = false
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ScreenInsets = Enum.ScreenInsets.None
	screenGui.DisplayOrder = 100
	screenGui.Parent = plr.PlayerGui

	map.Projectiles.HarukaPanel:Clone().Parent = screenGui
	map.Projectiles.HarukaPanelLoader:Clone().Parent = screenGui
	map.Projectiles.HarukaPostStroke:Clone().Parent = screenGui
end

MapLib:Alert("Fallen Practice Tools Loaded, Good Luck!", "white", 5.99)


--// Clear
local function roundEnded()
	RepS:SetAttribute("HarukaModulesLoaded", nil)
end
MapLib.RoundEnding:Once(roundEnded)
