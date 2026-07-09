local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AppStartup = require(CorePackages.Workspace.Packages.AppStartup)
local AppStartupSequence = AppStartup.AppStartupSequence
local PostAppInteractiveContainer = AppStartup.PostAppInteractiveContainer
local createLazyComponent = require(CorePackages.Workspace.Packages.RoactUtils).Components.createLazyComponent
local v8 = createLazyComponent(function() -- line: 12
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.QueryRefetch).QueryRefetchManager
end)
local v9 = createLazyComponent(function() -- line: 16
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.ContactImporter.ContactImporterManagerWrapper)
end)
local v10 = createLazyComponent(function() -- line: 20
	-- upvalues: Modules (copy)
	return require(Modules.AvatarExperience.Common.Components.AvatarExperienceMountedAtStartup)
end)
local v11 = createLazyComponent(function() -- line: 24
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.UpdateRequiredPrompt)
end)

local function PostAppInteractiveLoader(_: {[any]: any}) -- line: 28
	-- upvalues: React (copy), PostAppInteractiveContainer (copy), AppStartupSequence (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy)
	return React.createElement(PostAppInteractiveContainer, {
		appStartupSequence = AppStartupSequence.default
	}, {
		QueryRefetchManager = React.createElement(v8),
		ContactImporterManager = React.createElement(v9),
		AvatarExperienceMountedAtStartup = React.createElement(v10),
		UpdateRequiredPrompt = React.createElement(v11)
	})
end

return PostAppInteractiveLoader
