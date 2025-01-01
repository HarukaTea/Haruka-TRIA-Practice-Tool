--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Components = require(RepS.HarukaShared.Shared.UIAtlas.HarukaComponents)
local Fusion = require(RepS.HarukaShared.Shared.Fusion)

local Pinia = require(RepS.HarukaShared.Shared.UIAtlas.Pinia.HarukaPanelPinia)

local ButtonOption = require(RepS.HarukaShared.Shared.UIAtlas.Components.ButtonOption)
local TypeOption = require(RepS.HarukaShared.Shared.UIAtlas.Components.TypeOption)
local ToggleOption = require(RepS.HarukaShared.Shared.UIAtlas.Components.ToggleOption)

local Children, Computed, OnEvent = Fusion.Children, Fusion.Computed, Fusion.OnEvent

local v2New = Vector2.new
local fromScale = UDim2.fromScale

return function (plr: Player)
    local self = {}

    self.plr = plr

    Pinia(self)

    local scope = self.scope :: Fusion.Scope
    local isSelecting = Fusion.Value(scope, false)

    Components.HarukaScreenGui(scope, {
        Name = "HarukaPanel",
        DisplayOrder = 999,
        AutoLocalize = false,
        Parent = plr:FindFirstChildOfClass("PlayerGui").HarukaPanel,

    }, {
        BottomProps = {
            [Children] = {
                Components.TextButton(scope, {
                    Name = "OpenBtn",
                    AnchorPoint = v2New(1, 0),
                    Position = fromScale(0.99, -0.7),
                    Size = fromScale(0.15, 0.5),
                    Text = "Fallen Panel (C)",
                    BackgroundTransparency = 0.2,
                    AutoLocalize = false,

                    [Children] = {
                        Components.UIPadding(scope, {
                            PaddingTop = UDim.new(0.05, 0),
                            PaddingBottom = UDim.new(0.05, 0),
                        }),
                        Fusion.New(scope, "UICorner")({ CornerRadius = UDim.new(0.25, 0) }),

                        Components.UIStroke(scope, {
                            Thickness = 2,

                            Transparency = Fusion.Computed(scope, function(use: Fusion.Use)
                                return if use(isSelecting) then 0 else 1
                            end)
                        })
                    },
                    [OnEvent("MouseButton1Click")] = function()
                        self.panelOpen:set(not Fusion.peek(self.panelOpen))
                    end,
                    [OnEvent("MouseEnter")] = function()
                        isSelecting:set(true)
                    end,
                    [OnEvent("MouseLeave")] = function()
                        isSelecting:set(false)
                    end
                }),

                Components.Frame(scope, {
                    Name = "PanelBG",
                    AnchorPoint = v2New(1, 0),
                    Position = fromScale(0.99, -6),
                    BackgroundTransparency = 0.2,
                    Size = fromScale(0.15, 5),
                    AutoLocalize = false,

                    Visible = Computed(scope, function(use)
                        return use(self.panelOpen)
                    end),

                    [Children] = {
                        Fusion.New(scope, "UICorner")({ CornerRadius = UDim.new(0.04, 0) }),

                        Components.ScrollingFrame(scope, {
                            Name = "Panel",
                            AnchorPoint = v2New(0.5, 0.5),
                            Position = fromScale(0.5, 0.5),
                            ScrollingDirection = Enum.ScrollingDirection.Y,

                            [Children] = {
                                Components.PaddingFrame(scope, "AAA"),


                                TypeOption(scope, { TypeId = "Speed" }, self),
                                ToggleOption(scope, { ToggleId = "ForceSpeed" }, self),

                                TypeOption(scope, { TypeId = "Jump" }, self),
                                ToggleOption(scope, { ToggleId = "ForceJump" }, self),

                                TypeOption(scope, { TypeId = "Noclip" }, self),

                                ToggleOption(scope, { ToggleId = "Waters" }, self),
                                ToggleOption(scope, { ToggleId = "Lights" }, self),
                                ToggleOption(scope, { ToggleId = "Shadows" }, self),
                                ToggleOption(scope, { ToggleId = "Shaders" }, self),
                                ToggleOption(scope, { ToggleId = "DisableKillbrick" }, self),
                                ToggleOption(scope, { ToggleId = "ShowMedals" }, self),

                                TypeOption(scope, { TypeId = "Buttons" }, self),
                                ToggleOption(scope, { ToggleId = "SkipBtns" }, self),
                                ButtonOption(scope, { ButtonId = "ActivateAllBtns" }, self),

                                ToggleOption(scope, { ToggleId = "InfAir" }, self),

                                ButtonOption(scope, { ButtonId = "AddCheck" }, self),
                                ButtonOption(scope, { ButtonId = "ClearCheck" }, self),

                                Fusion.ForPairs(scope, self.checkPoints, function(_, localScope: table, index: number, checkPoint: CFrameValue)
                                    return index, ButtonOption(localScope, {
                                        ButtonId = "CheckTP", CheckPoint = checkPoint.Value, Index = index,
                                    }, self)
                                end),


                                Components.PaddingFrame(scope, "ZZZ"),
                            }
                        }, {
                            Padding = UDim.new(0, 8),
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        })
                    }
                })
            }
        }
    })
end
