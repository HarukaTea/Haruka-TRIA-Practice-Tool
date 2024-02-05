--!nocheck

local Players = game:GetService("Players")
local CS = game:GetService("CollectionService")
local RS = game:GetService("RunService")
local RepS = game:GetService("ReplicatedStorage")

repeat RS.Heartbeat:Wait() until RepS:GetAttribute("HarukaModulesLoaded")

local Components = require(RepS.HarukaModules.UI.Vanilla)
local Fusion = require(RepS.HarukaModules.Fusion)

local OpenButton = require(RepS.HarukaModules.UI.Components.OpenButton)
local Panel = require(RepS.HarukaModules.UI.Views.Panel)

local plr = Players.LocalPlayer

local v2New = Vector2.new
local fromScale = UDim2.fromScale
local clock = os.clock

local HarukaPanelStarter = {}
HarukaPanelStarter.__index = HarukaPanelStarter
local self = setmetatable({}, HarukaPanelStarter)
self.plr = plr

Components.Frame({
    Name = "BG",
    AnchorPoint = v2New(0.5, 1),
    Position = fromScale(0.5, 1),
    Size = fromScale(1, 0.1),
    Parent = script.Parent,

    [Fusion.Children] = {
        Fusion.New("UIAspectRatioConstraint")({ AspectRatio = 25.798 }),

        OpenButton(self),
        Panel(self)
    }
})

--// Tag UI
for _, element in plr.PlayerGui:GetDescendants() do
    if element:IsA("UIStroke") then CS:AddTag(element, "ScreenStroke") end
end

--// UI Setup
local list = Fusion.peek(self.list) :: ScrollingFrame

self.absSize:set(list.AbsoluteSize.Y)
self.absContentSize:set(list.UIListLayout.AbsoluteContentSize.Y)

--// UI Stroke
local DESIGN_VP_SIZE = v2New(1208, 470)
local strokes = {}

local function _calScreenRatio() : number
    local function average(vector2: Vector2) : number
        return (vector2.X + vector2.Y) / 2
    end

    return average(workspace.CurrentCamera.ViewportSize) / average(DESIGN_VP_SIZE)
end
local function updateStroke()
    local fpsLimit, lastTick = 0.5, 0

    RS.Heartbeat:Connect(function()
        if clock() - lastTick >= fpsLimit then
            lastTick = clock()

            for i, thickness in strokes do
                if not i.Parent then
                    strokes[i] = nil
                else
                    i.Thickness = thickness * _calScreenRatio()
                end
            end
        end
    end)
end
updateStroke()

CS:GetInstanceAddedSignal("ScreenStroke"):Connect(function(added: UIStroke)
    strokes[added] = added.Thickness

    added.Thickness *= _calScreenRatio()
end)