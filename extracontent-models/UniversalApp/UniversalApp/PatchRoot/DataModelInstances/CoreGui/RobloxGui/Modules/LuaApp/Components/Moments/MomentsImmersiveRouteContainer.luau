local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local MomentsImmersivePresentation = require(CorePackages.Workspace.Packages.Moments).MomentsImmersivePresentation
local ProfilePlatform = require(CorePackages.Workspace.Packages.ProfilePlatform)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local MomentsFeed = ProfilePlatform.Sources.MomentsFeed

local function MomentsImmersiveRouteContainer(t1: {[any]: any}) -- line: 28
	-- upvalues: useDispatch (copy), useSelector (copy), React (copy), OpenProfilePeekView (copy), MomentsFeed (copy), MomentsImmersivePresentation (copy)
	local v13 = useDispatch()
	local v14 = useSelector(function(p1) -- line: 30
		return p1.LocalUserId
	end)
	local navigation = t1.navigation
	local v16 = React.useCallback(function(n1: number) -- line: 35
		-- upvalues: v13 (copy), OpenProfilePeekView (copy), MomentsFeed (copy)
		v13(OpenProfilePeekView(tostring(n1), {
			source = MomentsFeed
		}))
	end, { v13 })
	local v17 = React.useCallback(function() -- line: 41
		-- upvalues: v14 (copy), v13 (copy), OpenProfilePeekView (copy), MomentsFeed (copy)
		if v14 == nil then
			return
		end

		v13(OpenProfilePeekView(tostring(v14), {
			source = MomentsFeed
		}))
	end, {
		v13,
		v14
	})
	local v18 = React.useCallback(function() -- line: 52
		-- upvalues: navigation (copy)
		if navigation ~= nil and navigation.goBack ~= nil then
			navigation.goBack()
		end
	end, { navigation })
	local s1 = "flyout_menu"

	if navigation ~= nil and navigation.getParam ~= nil then
		local v20 = navigation.getParam("source")

		if type(v20) == "string" then
			s1 = v20
		end
	end

	return React.createElement(MomentsImmersivePresentation, {
		feedKind = "trending",
		onBack = v18,
		sessionSource = s1,
		openProfile = v16,
		openOwnMoments = v17
	})
end

return MomentsImmersiveRouteContainer
