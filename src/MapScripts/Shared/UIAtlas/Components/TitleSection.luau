--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Components = require(RepS.HarukaShared.UIAtlas.HarukaComponents)
local Fusion = require(RepS.HarukaShared.Shared.Fusion)

local Children = Fusion.Children


local fromScale = UDim2.fromScale
local udNew = UDim.new
local fromRGB = Color3.fromRGB

local TITLES = {
    Controls = "Controls",
    Map = "Map",
    Checkpoints = "Checkpoints",
}


return function (scope: Fusion.Scope, props: {
    TitleId: string,
    Order: number,

}, self: table) : Frame

    return Components.Frame(scope, {
        Name = "TitleSection_"..props.TitleId,
        Size = fromScale(0.9, 0.11),
        LayoutOrder = props.Order,
        ClipsDescendants = true,

        [Children] = {
            Components.UIAspectRatioConstraint(scope, 6.29),

            Components.UIListLayout(scope, {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),

            Components.TextLabel(scope, {
                Name = "Title",
                Size = fromScale(0, 1),
                AutomaticSize = Enum.AutomaticSize.X,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = TITLES[props.TitleId],
                TextColor3 = fromRGB(170, 255, 255),
                LayoutOrder = 1,

                [Children] = {
                    Components.UIPadding(scope, {
                        PaddingTop = udNew(0.1, 0),
                        PaddingBottom = udNew(0.1, 0),
                        PaddingLeft = udNew(0.03, 0),
                        PaddingRight = udNew(0.03, 0)
                    })
                }
            }),
            Components.Frame(scope, {
                Name = "Line",
                Size = fromScale(1, 0.1),
                LayoutOrder = 2,
                BackgroundColor3 = fromRGB(170, 255, 255),
                BackgroundTransparency = 0,
            }),
        }
    })
end
