--!nocheck

local RepS = game:GetService("ReplicatedStorage")

local Components = require(RepS.HarukaShared.UIAtlas.HarukaComponents)
local Fusion = require(RepS.HarukaShared.Shared.Fusion)

local MapLib = game.GetMapLib:Invoke()()

local New, OnEvent = Fusion.New, Fusion.OnEvent

local fromScale = UDim2.fromScale
local udNew = UDim.new
local fromRGB = Color3.fromRGB

local Texts = {
    AddCheck = "Add Checkpoint (X)",
    ClearCheck = "Clear All Checks",
    ActivateAllBtns = "Activate Buttons",
    TimeStopMap = "Time Stop Map"
}

return function (scope: Fusion.Scope, props: {
    ButtonId: string,
    CheckPoint: CFrame?,
    Index: number?,
    Order: number,

}, self: table) : TextButton

    props = props or {}

    local isSelecting = Fusion.Value(scope, false)
    local index = props.Order
    if props.Index then
        index = math.ceil(props.Index + 1 + (15.99 * 5))
    end

    return Components.TextButton(scope, {
        Name = "ButtonOption_"..props.ButtonId,
        Size = fromScale(0.9, 0.11),
        Text = if props.ButtonId == "CheckTP" then "Check #"..props.Index else Texts[props.ButtonId],
        AutoButtonColor = false,
        LayoutOrder = index,

        BackgroundColor3 = Fusion.Computed(scope, function(use: Fusion.Use)
            return if use(isSelecting) then fromRGB(255, 255, 255) else fromRGB(28, 28, 37)
        end),
        TextColor3 = Fusion.Computed(scope, function(use: Fusion.Use)
            return if use(isSelecting) then fromRGB() else fromRGB(255, 255, 255)
        end),

        [OnEvent("MouseButton1Click")] = function()
            if props.ButtonId == "AddCheck" then
                local checkPoint = Instance.new("CFrameValue")
                checkPoint.Value = self.plr.Character.PrimaryPart.CFrame
                checkPoint.Name = "_Checkpoint"
                checkPoint.Parent = self.checkPointsContainer

                MapLib:Alert(`[Fallen Panel] Checkpoint Added!`, "green", 3)

            elseif props.ButtonId == "ClearCheck" then
                self.checkPointsContainer:ClearAllChildren()

                MapLib:Alert("[Fallen Panel] All Checkpoints Cleared!", "red", 3)

            elseif props.ButtonId == "CheckTP" then
                self.plr.Character.PrimaryPart.CFrame = props.CheckPoint

            elseif props.ButtonId == "ActivateAllBtns" then
                for _, btn: Instance in workspace:GetDescendants() do
                    self:_detectButton(btn)
                end

                MapLib:Alert("[Fallen Panel] Buttons Activated!", "green", 3)

            elseif props.ButtonId == "TimeStopMap" then
                if MapLib.map:GetAttribute("_Haruka_IsTimeStop") then
                    MapLib:Alert("[Fallen Panel] You already performed time stop in this map!", "red", 3)
                    return
                end


                game:FindFirstChild("_Haruka_TimeStop", true):FireServer()

                MapLib:Alert("[Fallen Panel] All scripts are disabled!", "green", 3)
                MapLib:Alert("[Fallen Panel] If you want to continue, please reset and play again!", "yellow", 5)
            end
        end,
        [OnEvent("MouseEnter")] = function()
            isSelecting:set(true)
        end,
        [OnEvent("MouseLeave")] = function()
            isSelecting:set(false)
        end,

        [Fusion.Children] = {
            Components.UIAspectRatioConstraint(scope, 6.29),
            Components.UIPadding(scope, {}),

            New(scope, "UICorner")({ CornerRadius = udNew(0.25, 0) }),
        }
    })
end

