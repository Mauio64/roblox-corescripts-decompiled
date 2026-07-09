local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local UnableToJoinExperienceModal = require(CorePackages.Workspace.Packages.SocialExperienceJoin).UnableToJoinExperienceModal
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function() -- line: 12
	-- upvalues: useDispatch (copy), React (copy), OpenGameDetails (copy), UnableToJoinExperienceModal (copy)
	local v8 = useDispatch()
	local v9 = React.useCallback(function(s1: string, p1) -- line: 15
		-- upvalues: v8 (copy), OpenGameDetails (copy)
		v8(OpenGameDetails(s1, p1))
	end, {})

	return React.createElement(UnableToJoinExperienceModal, {
		openGameDetailsPeekView = v9
	})
end
