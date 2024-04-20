--!nocheck
--!optimize 2
--!native

local RS = game:GetService("RunService")
local RepS = game:GetService("ReplicatedStorage")

repeat RS.Heartbeat:Wait() until RepS:GetAttribute("HarukaModulesLoaded")

local Components = require(RepS.HarukaModules.UI.Vanilla)
local Fusion = require(RepS.HarukaModules.Fusion)

local OpenButton = require(RepS.HarukaModules.UI.Components.OpenButton)
local Panel = require(RepS.HarukaModules.UI.Views.Panel)

local v2New = Vector2.new
local fromScale = UDim2.fromScale

local HarukaPanel = {}
HarukaPanel.__index = HarukaPanel

--// UI Setup
return function (plr: Player)
    local self = setmetatable({}, HarukaPanel)

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

    local list = Fusion.peek(self.list) :: ScrollingFrame
    self.absSize:set(list.AbsoluteSize.Y)
    self.absContentSize:set(list.UIListLayout.AbsoluteContentSize.Y)
end
