local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/cyM")
local appStartupSequence = module.AppStartupSequence
local postAppInteractiveContainer = module.PostAppInteractiveContainer
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent

local fFlagDeferInExperienceRbxmDownload = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDeferInExperienceRbxmDownload

local lazyComponent = createLazyComponent(function()
	return require("@luauforge/deferred/igr").QueryRefetchManager
end)

local lazyComponent2 = createLazyComponent(function()
	return require("@luauforge/deferred/igD")
end)

local lazyComponent3 = createLazyComponent(function()
	return require("@luauforge/bundled/igE")
end)

local lazyComponent4 = createLazyComponent(function()
	return require("@luauforge/deferred/hMh")
end)

local lazyComponent5 = createLazyComponent(function()
	return require("@luauforge/bundled/hTa").PreGameLoadingScreen
end)

local function PostAppInteractiveLoader(p2)
	local createElement = React.createElement
	local v6 = { appStartupSequence = appStartupSequence.default }
	local v7 = {
		QueryRefetchManager = React.createElement(lazyComponent),
		ContactImporterManager = React.createElement(lazyComponent2),
		AvatarExperienceMountedAtStartup = React.createElement(lazyComponent3),
		UpdateRequiredPrompt = React.createElement(lazyComponent4),
		PreGameLoadingScreen = 0
	}

	local v8 = if fFlagDeferInExperienceRbxmDownload then React.createElement(lazyComponent5) else nil
	v7.PreGameLoadingScreen = v8
	return createElement(postAppInteractiveContainer, v6, v7)
end

return PostAppInteractiveLoader
