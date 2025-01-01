require(game:GetService("ServerScriptService").Runtime):Init()


local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map.MapScripts :: Folder

local players = MapLib:GetPlayers() :: { Player }

local RepS = game:GetService("ReplicatedStorage")


--// Setup packages
if RepS:FindFirstChild("HarukaShared") then RepS.HarukaShared:Destroy() end

local folder = Instance.new("Folder")
folder.Name = "HarukaShared"
folder.Parent = RepS
map.Shared.Parent = folder

RepS:SetAttribute("HarukaSharedLoaded", true)



--// Load UI
for _, plr: Player in players do
	if not plr then continue end
	if not plr.Character then continue end

	local plrGui = plr.PlayerGui

	if plrGui:FindFirstChild("HarukaPanel") then plrGui.HarukaPanel:Destroy() end
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "HarukaPanel"
	screenGui.AutoLocalize = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ClipToDeviceSafeArea = false
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ScreenInsets = Enum.ScreenInsets.None
	screenGui.DisplayOrder = 999
	screenGui.Parent = plr.PlayerGui

	map.Projectiles.HarukaPanel:Clone().Parent = screenGui
	map.Projectiles.HarukaPanelLoader:Clone().Parent = screenGui
	map.Projectiles.HarukaPostStroke:Clone().Parent = screenGui
end

MapLib:Alert("Fallen Practice Tools V1.1 Loaded!", "green", 5.99)
task.delay(1.599, function()
	MapLib:Alert("Good Luck on Your Practice Journey!", "green", 5.99)
end)
task.delay(1.599 * 2, function()
	MapLib:Alert("Practice Tools may not work properly in Mobile, Sorry about that!", "yellow", 5.99)
end)


--// Clear
local function roundEnded()
	RepS:SetAttribute("HarukaSharedLoaded", nil)
end
MapLib.RoundEnding:Once(roundEnded)
