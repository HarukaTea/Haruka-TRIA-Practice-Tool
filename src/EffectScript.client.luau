--!nocheck
--!optimize 2
--!native

local RepS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map

local wait, spawn = task.wait, task.spawn
local random, rad = math.random, math.rad
local v3New = Vector3.new
local cfAngles = CFrame.Angles
local tweenInfoNew = TweenInfo.new

repeat wait() until RepS:GetAttribute("HarukaModulesLoaded")

for _, tower in map.Geometry.Decorations.Towers:GetChildren() do
	for _, dec in tower:GetChildren() do
		if dec.Name == "DecT2" then
			spawn(function()
				while wait(0.01) do
					dec:PivotTo(dec.PrimaryPart.CFrame * cfAngles(0, rad(-1), 0))
				end
			end)
		end
	end
end

for _, ball in map.Geometry.Decorations.Balls:GetChildren() do
	if ball:IsA("BasePart") then
		spawn(function()
			while wait(1.5) do
				TS:Create(ball, tweenInfoNew(2), { Position = ball.Position + v3New(random(-10, 10), 0, random(-10, 10)) }):Play()
			end
		end)
	end
end
