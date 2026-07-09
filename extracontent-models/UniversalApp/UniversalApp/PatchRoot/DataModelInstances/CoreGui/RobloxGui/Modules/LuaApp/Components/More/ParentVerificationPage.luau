local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GenericWebPageWrapper = require(Modules.LuaApp.Components.GenericWebPageWrapper)
local CorePackages = game:GetService("CorePackages")
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local ResetModeration = require(Modules.LuaApp.Thunks.Moderation.ResetModeration)

local function ParentVerificationPage(t1: {[any]: any}) -- line: 11
	-- upvalues: useDispatch (copy), React (copy), ResetModeration (copy), GenericWebPageWrapper (copy)
	local v9 = useDispatch()

	React.useEffect(function() -- line: 13
		-- upvalues: v9 (copy), ResetModeration (copy)
		return function() -- line: 14
			-- upvalues: v9 (copy), ResetModeration (copy)
			v9(ResetModeration())
		end
	end, {})

	return React.createElement(GenericWebPageWrapper, {
		isVisible = true,
		url = t1.url
	})
end

return ParentVerificationPage
