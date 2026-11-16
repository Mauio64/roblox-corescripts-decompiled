local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local PopLatencyOverlay = require(CorePackages.Workspace.Packages.PopLatencyOverlay)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local gameplayPopOverlay = Instance.new("Folder")
gameplayPopOverlay.Name = "GameplayPopOverlay"
gameplayPopOverlay.Parent = CoreGui

local root = ReactRoblox.createRoot(gameplayPopOverlay)
local v

if SharedFlags.FFlagEnableGameplayPopLatencyOverlay then
	v = PopLatencyOverlay.gameplay
else
	v = PopLatencyOverlay.gameplayAdminOnly
end

root:render(React.createElement(v, {
	experienceService = game:GetService("ExperienceService")
}))
