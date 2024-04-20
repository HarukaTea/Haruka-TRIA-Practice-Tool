--!nocheck
--!optimize 2
--!native

local Components = require(script.Parent.Parent.Vanilla)
local Fusion = require(script.Parent.Parent.Parent.Fusion)

local Children, Tween, Computed, OnEvent, Value, peek =
    Fusion.Children, Fusion.Tween, Fusion.Computed, Fusion.OnEvent, Fusion.Value, Fusion.peek

local fromScale = UDim2.fromScale
local udNew = UDim.new
local fromRGB = Color3.fromRGB
local newTweenInfo = TweenInfo.new

local Texts = {
    Speed = "Speed",
    Jump = "Jump",
    Noclip = "Noclip",
    Buttons = "Buttons"
}
local Priority = {
    Speed = 5,
    Jump = 10,
    Noclip = 10,
    Buttons = 1
}

local function TypeOption(id: string, self: table) : Frame
    local bgColor = Value(fromRGB(30, 30, 30))
    local bgTextColor = Value(fromRGB(255, 255, 255))
    local bgColor2 = Value(fromRGB(30, 30, 30))
    local bgTextColor2 = Value(fromRGB(255, 255, 255))

    return Components.Frame({
        Name = "TypeOption",
        Size = fromScale(1, 0.12),

        [Children] = {
            Fusion.New("UIAspectRatioConstraint")({ AspectRatio = 6.449 }),
            Components.TextLabel({
                Name = "Title",
                Size = fromScale(0.7, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = Texts[id],

                [Children] = {
                    Fusion.New("UIPadding")({
                        PaddingBottom = udNew(0.1, 0),
                        PaddingTop = udNew(0.1, 0),
                        PaddingLeft = udNew(0.03, 0)
                    })
                }
            }),
            Components.TextBox({
                Name = "Input",
                BackgroundTransparency = 0.5,
                Position = fromScale(0.625, 0),
                Size = fromScale(0.2, 1),
                Text = Computed(function(use)
                    return use(self.inputs[id])
                end),
                TextColor3 = fromRGB(178, 178, 178),

                [Fusion.Out("Text")] = self.inputs[id],

                [Children] = { Components.RoundUICorner() }
            }),
            Components.TextButton({
                Name = "Decrease",
                BackgroundTransparency = 0.2,
                Position = fromScale(0.455, 0),
                Size = fromScale(0.15, 1),
                Text = "<",

                BackgroundColor3 = Tween(Computed(function(use)
                    return use(bgColor)
                end), newTweenInfo(0.3)),
                TextColor3 = Tween(Computed(function(use)
                    return use(bgTextColor)
                end), newTweenInfo(0.3)),

                [OnEvent("MouseButton1Click")] = function()
                    local currentVal = peek(self.inputs[id])

                    if currentVal ~= "" and tonumber(currentVal) then
                        self.inputs[id]:set(tonumber(currentVal) - Priority[id])

                        if tonumber(currentVal) - Priority[id] < 0 then
                            self.inputs[id]:set(0)
                        end
                    end
                end,
                [OnEvent("MouseEnter")] = function()
                    bgColor:set(fromRGB(255, 255, 255))
                    bgTextColor:set(fromRGB())
                end,
                [OnEvent("MouseLeave")] = function()
                    bgColor:set(fromRGB(30, 30, 30))
                    bgTextColor:set(fromRGB(255, 255, 255))
                end,

                [Children] = { Components.RoundUICorner() }
            }),
            Components.TextButton({
                Name = "Increase",
                BackgroundTransparency = 0.2,
                Position = fromScale(0.845, 0),
                Size = fromScale(0.15, 1),
                Text = ">",

                BackgroundColor3 = Tween(Computed(function(use)
                    return use(bgColor2)
                end), newTweenInfo(0.3)),
                TextColor3 = Tween(Computed(function(use)
                    return use(bgTextColor2)
                end), newTweenInfo(0.3)),

                [OnEvent("MouseButton1Click")] = function()
                    local currentVal = peek(self.inputs[id])

                    if currentVal ~= "" and tonumber(currentVal) then
                        self.inputs[id]:set(tonumber(currentVal) + Priority[id])
                    end
                end,
                [OnEvent("MouseEnter")] = function()
                    bgColor2:set(fromRGB(255, 255, 255))
                    bgTextColor2:set(fromRGB())
                end,
                [OnEvent("MouseLeave")] = function()
                    bgColor2:set(fromRGB(30, 30, 30))
                    bgTextColor2:set(fromRGB(255, 255, 255))
                end,

                [Children] = { Components.RoundUICorner() }
            })
        }
    })
end

return TypeOption