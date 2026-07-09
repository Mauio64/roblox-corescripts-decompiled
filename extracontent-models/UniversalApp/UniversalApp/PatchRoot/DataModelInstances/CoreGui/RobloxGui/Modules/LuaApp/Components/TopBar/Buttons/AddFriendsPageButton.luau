local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRouteName = require(CorePackages.Workspace.Packages.Navigation).useRouteName
local RoactAnalyticsTopBar = require(Modules.LuaApp.Services.RoactAnalyticsTopBar)
local NavigateDownToAddFriendsPage = require(Modules.LuaApp.Thunks.NavigateDownToAddFriendsPage)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local v12 = Images["icons/actions/friends/friendAdd"]

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useDispatch (copy), useRouteName (copy), useRoactService (copy), RoactAnalyticsTopBar (copy), NavigateDownToAddFriendsPage (copy), React (copy), UtilityActionIcon (copy), v12 (copy)
	local v14 = useDispatch()
	local v15 = useRouteName()
	local v16 = useRoactService(RoactAnalyticsTopBar)

	React.useEffect(function() -- line: 44
		-- upvalues: t1 (copy)
		local isSearching = t1.isSearching

		t1.setVisible(not isSearching)
	end, {
		t1.isSearching,
		t1.setVisible
	})

	return React.createElement(UtilityActionIcon, {
		icon = v12,
		onActivated = function() -- line: 34
			-- upvalues: t1 (copy), v14 (copy), NavigateDownToAddFriendsPage (copy), v16 (copy), v15 (copy)
			if t1.isSearching then
				return
			end

			v14(NavigateDownToAddFriendsPage())
			v16.reportAddFriendsButtonClick(v15)
		end,
		ref = t1.buttonRef
	})
end
