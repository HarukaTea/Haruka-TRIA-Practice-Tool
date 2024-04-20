--!nocheck
--!optimize 2
--!native

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local RepS = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer

repeat RS.Heartbeat:Wait() until RepS:GetAttribute("HarukaModulesLoaded")

--// Panel, Start!
require(script.Parent.HarukaPanel)(plr)
