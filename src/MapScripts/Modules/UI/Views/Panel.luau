--!nocheck

local Lighting = game:GetService("Lighting")
local StarterPack = game:GetService("StarterPack")

local Components = require(script.Parent.Parent.Vanilla)
local Fusion = require(script.Parent.Parent.Parent.Fusion)

local ButtonOption = require(script.Parent.Parent.Components.ButtonOption)
local TypeOption = require(script.Parent.Parent.Components.TypeOption)
local ToggleOption = require(script.Parent.Parent.Components.ToggleOption)

local Children, Computed, Value, Observer, peek = Fusion.Children, Fusion.Computed, Fusion.Value, Fusion.Observer, Fusion.peek

local fromScale, fromOffset = UDim2.fromScale, UDim2.fromOffset
local udNew = UDim.new
local sFind, match = string.find, string.match
local wait = task.wait
local instanceNew = Instance.new
local v3New = Vector3.new

local function Panel(self: table) : Frame

    self.list = Value()
    self.panelOpen = Value(false)
    self.absSize, self.absContentSize = Value(0), Value(0)

    self.inputs = {
        Speed = Value("20"),
        Jump = Value("50"),
        Noclip = Value("20"),
        Buttons = Value("1"),

        Waters = Value(true),
        Lights = Value(false),
        Shadows = Value(true),
        Shaders = Value(true),
        SkipBtns = Value(false),
        InfAir = Value(false),

        SetCheck = Value(self.plr.Character.PrimaryPart.CFrame)
    }

    --// Connections
    local inputs = self.inputs
    local speedObserver = Observer(inputs.Speed)
    local jumpObserver = Observer(inputs.Jump)
    local noclipObserver = Observer(inputs.Noclip)
    local watersObserver = Observer(inputs.Waters)
    local lightsObserver = Observer(inputs.Lights)
    local shadowsObserver = Observer(inputs.Shadows)
    local shadersObserver = Observer(inputs.Shaders)
    local skipBtnsObserver = Observer(inputs.SkipBtns)
    local infAirObserver = Observer(inputs.InfAir)

    speedObserver:onChange(function()
        local speed = peek(inputs.Speed)
        local humanoid = self.plr.Character.Humanoid :: Humanoid

        if speed == "" then return end
        humanoid.WalkSpeed = tonumber(speed)
    end)
    jumpObserver:onChange(function()
        local jump = peek(inputs.Jump)
        local humanoid = self.plr.Character.Humanoid :: Humanoid

        if jump == "" then return end
        humanoid.JumpPower = tonumber(jump)
    end)
    noclipObserver:onChange(function()
        local speed = peek(inputs.Noclip)

        if speed == "" then return end
        local finalSpeed = tonumber(speed) * 3

        self.plr.Backpack.Noclip:SetAttribute("Speed", finalSpeed)
        StarterPack.Noclip:SetAttribute("Speed", finalSpeed)
    end)

    local waterConnection: RBXScriptConnection = nil
    local function _detectWater(water: BasePart)
        if sFind(water.Name, "_Liquid") or sFind(water.Name, "_Gas") then water:Destroy() end
    end
    watersObserver:onChange(function()
        if peek(inputs.Waters) == false then
            for _, water in workspace:GetDescendants() do
                _detectWater(water)
            end

            waterConnection = workspace.DescendantAdded:Connect(function(added: Instance)
                wait()
                _detectWater(added)
            end)

        else
            if waterConnection then waterConnection:Disconnect() end
        end
    end)
    lightsObserver:onChange(function()
        local char = self.plr.Character :: Model

        if peek(inputs.Lights) then
            if char.PrimaryPart:FindFirstChild("SelfLight") then char.PrimaryPart.SelfLight:Destroy() end

            local light = instanceNew("PointLight")
            light.Range = 25
            light.Name = "SelfLight"
            light.Parent = char.PrimaryPart

        else
            if char.PrimaryPart:FindFirstChild("SelfLight") then char.PrimaryPart.SelfLight:Destroy() end
        end
    end)

    local oriEnd, oriStart = Value(2000), Value(0)
    Fusion.Hydrate(Lighting)({
        [Fusion.OnChange("FogStart")] = function(newStart)
            if newStart ~= 0 then oriStart:set(newStart) end
        end,
        [Fusion.OnChange("FogEnd")] = function(newEnd)
            if newEnd ~= 1599 * 40 then oriEnd:set(newEnd) end
        end
    })
    shadowsObserver:onChange(function()
        local state = peek(inputs.Shadows)

        Lighting.GlobalShadows = state

        if not state then
            Lighting.FogEnd = 1599 * 40
            Lighting.FogStart = 0
        else
            Lighting.FogEnd = peek(oriEnd)
            Lighting.FogStart = peek(oriStart)
        end
    end)

    local shaderConnection: RBXScriptConnection = nil
    local function _detectShader(shader: ColorCorrectionEffect, state: boolean)
        if shader:IsA("ColorCorrectionEffect") then shader.Enabled = state end
    end
    shadersObserver:onChange(function()
        if peek(inputs.Shaders) then
            for _, shader in Lighting:GetDescendants() do
                _detectShader(shader, false)
            end

            shaderConnection = Lighting.DescendantAdded:Connect(function(added)
                wait()
                _detectShader(added, false)
            end)
        else
            if shaderConnection then shaderConnection:Disconnect() end

            for _, shader in Lighting:GetDescendants() do
                _detectShader(shader, true)
            end
        end
    end)

    local btnConnection: RBXScriptConnection = nil
    local function _detectButton(btn: Model)
        local maxBtns = peek(inputs.Buttons)

        if maxBtns == "" then return end
        if sFind(btn.Name, "_Button") and btn:IsA("Model") then
            local index = match(btn.Name, "%d+")
            if tonumber(index) > tonumber(maxBtns) then return end

            for _, child in btn:GetDescendants() do
                if child:IsA("BasePart") then
                    child.Transparency = 1
                    child.CanCollide = false
                end
            end

            btn.Hitbox.Size = v3New(15.99, 15.99, 15.99)
            btn.Hitbox.CFrame = self.plr.Character.PrimaryPart.CFrame
        end
    end
    skipBtnsObserver:onChange(function()
        if peek(inputs.SkipBtns) then
            for _, btn in workspace:GetDescendants() do
                _detectButton(btn)
            end

            btnConnection = workspace.DescendantAdded:Connect(function(added: Instance)
                wait(0.7)
                _detectButton(added)
            end)

        else
            if btnConnection then btnConnection:Disconnect() end
        end
    end)

    local infAirConnection: RBXScriptConnection = nil
    local function _detectWaterState(water: BasePart)
        if sFind(water.Name, "_Liquid") or sFind(water.Name, "_Gas") then
            water:SetAttribute("Type", "water")
        end
    end
    infAirObserver:onChange(function()
        if peek(inputs.InfAir) then
            for _, water in workspace:GetDescendants() do
                _detectWaterState(water)
            end

            infAirConnection = workspace.DescendantAdded:Connect(function(added: Instance)
                wait()
                _detectWaterState(added)
            end)

        else
            if infAirConnection then infAirConnection:Disconnect() end
        end
    end)
    self.plr.CharacterAdded:Connect(function(char: Model)
        local humanoid = char:WaitForChild("Humanoid")

        local speed = peek(inputs.Speed)
        local jump = peek(inputs.Jump)

        if speed ~= "" then humanoid.WalkSpeed = tonumber(speed) end
        if jump ~= "" then humanoid.Jump = tonumber(jump) end
        if peek(inputs.Lights) then
            local light = instanceNew("PointLight")
            light.Range = 16
            light.Name = "SelfLight"
            light.Parent = char.PrimaryPart
        end
    end)

    return Components.Frame({
        Name = "PanelBG",
        Position = fromScale(0.915, -2.8),
        BackgroundTransparency = 0.2,
        Size = fromScale(0.15, 5),
        Visible = Computed(function(use)
            return use(self.panelOpen)
        end),

        [Children] = {
            Fusion.New("UICorner")({ CornerRadius = udNew(0.02, 0) }),
            Components.ScrollingFrame({
                Name = "Panel",
                ClipsDescendants = true,
                Size = fromScale(0.9, 0.9),
                ScrollingDirection = Enum.ScrollingDirection.Y,

                ScrollingEnabled = Computed(function(use)
                    return if use(self.absContentSize) > use(self.absSize) then true else false
                end),
                CanvasSize = Computed(function(use)
                    if use(self.absContentSize) > use(self.absSize) then
                        return fromOffset(0, use(self.absContentSize))
                    else
                        return fromOffset(0, 0)
                    end
                end),

                [Fusion.OnChange("AbsoluteSize")] = function(size)
                    self.absSize:set(size.Y)
                end,
                [Fusion.Ref] = self.list,

                [Children] = {
                    Fusion.New("UIListLayout")({
                        Padding = udNew(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,

                        [Fusion.OnChange("AbsoluteContentSize")] = function(size)
                            self.absContentSize:set(size.Y)
                        end
                    }),

                    TypeOption("Speed", self),
                    TypeOption("Jump", self),
                    TypeOption("Noclip", self),

                    ToggleOption("Waters", self),
                    ToggleOption("Lights", self),
                    ToggleOption("Shadows", self),
                    ToggleOption("Shaders", self),

                    TypeOption("Buttons", self),
                    ToggleOption("SkipBtns", self),

                    ButtonOption("SetCheck", self),
                    ButtonOption("ReturnCheck", self),

                    ToggleOption("InfAir", self)
                }
            })
        }
    })
end

return Panel
