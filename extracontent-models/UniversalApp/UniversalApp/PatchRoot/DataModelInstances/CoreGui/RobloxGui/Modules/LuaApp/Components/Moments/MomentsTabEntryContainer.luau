local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local MomentsTabEntry = require(CorePackages.Workspace.Packages.Moments).MomentsTabEntry
local ProfilePlatform = require(CorePackages.Workspace.Packages.ProfilePlatform)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local SetTabBarVisibleFromMoments = require(CorePackages.Workspace.Packages.AppTabBarRodux).Thunks.SetTabBarVisibleFromMoments
local MomentsFeed = ProfilePlatform.Sources.MomentsFeed
local FFlagMomentsWatchSessionalization = SharedFlags.FFlagMomentsWatchSessionalization

local function MomentsTabEntryContainer(t1: {[any]: any}) -- line: 23
	-- upvalues: useDispatch (copy), useSelector (copy), React (copy), OpenProfilePeekView (copy), MomentsFeed (copy), SetTabBarVisibleFromMoments (copy), MomentsTabEntry (copy)
	local v17 = useDispatch()
	local v18 = useSelector(function(p1) -- line: 25
		return p1.LocalUserId
	end)
	local v19 = React.useCallback(function(n1: number) -- line: 29
		-- upvalues: v17 (copy), OpenProfilePeekView (copy), MomentsFeed (copy)
		v17(OpenProfilePeekView(tostring(n1), {
			source = MomentsFeed
		}))
	end, { v17 })
	local v20 = React.useCallback(function() -- line: 35
		-- upvalues: v18 (copy), v17 (copy), OpenProfilePeekView (copy), MomentsFeed (copy)
		if v18 == nil then
			return
		end

		v17(OpenProfilePeekView(tostring(v18), {
			source = MomentsFeed
		}))
	end, {
		v17,
		v18
	})
	local v21 = React.useCallback(function() -- line: 47
		-- upvalues: v17 (copy), SetTabBarVisibleFromMoments (copy)
		v17(SetTabBarVisibleFromMoments(true))
	end, { v17 })

	return React.createElement(MomentsTabEntry, {
		navigation = t1.navigation,
		openProfile = v19,
		openOwnMoments = if v18 == nil then nil else v20,
		onTabFocused = v21
	})
end

local v15 = React.Component:extend("MomentsTabEntryContainerScreen")

function v15.render(p2) -- line: 65
	-- upvalues: React (copy), MomentsTabEntryContainer (copy)
	return React.createElement(MomentsTabEntryContainer, p2.props)
end

if FFlagMomentsWatchSessionalization then
	v15.router = MomentsTabEntry.router
end

if FFlagMomentsWatchSessionalization then
	return v15
end

return MomentsTabEntryContainer
