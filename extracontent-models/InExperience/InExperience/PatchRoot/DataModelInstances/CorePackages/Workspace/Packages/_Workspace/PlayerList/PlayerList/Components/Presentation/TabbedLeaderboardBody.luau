local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local View = require(ParentParentParent.Foundation).View
local PlayerListVisibilityStore = require(ParentParent.Common.PlayerListVisibilityStore)
local LeaderboardTabs = require(ParentParent.Components.Presentation.LeaderboardTabs)
local PlatformLeaderboardView = require(ParentParent.Components.Presentation.PlatformLeaderboardView)

local function TabbedLeaderboardBody(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), SignalsReact (copy), PlayerListVisibilityStore (copy), PlatformLeaderboardView (copy), View (copy), LeaderboardTabs (copy)
	local v11, v12 = React.useState("server")
	local v13 = React.useCallback(function() -- line: 35
		-- upvalues: v12 (copy)
		v12("server")
	end, {})
	local v14 = SignalsReact.useSignalState(PlayerListVisibilityStore.getEffectiveVisible)
	local serverBody

	if v11 == "server" or not v14 then
		serverBody = t1.serverBody
	else
		local v16 = v11 ~= "friends" and "Global" or "Friends"

		serverBody = React.createElement(PlatformLeaderboardView, {
			layoutOrder = 4,
			tab = v16
		})
	end

	return React.createElement(View, t1.panelProps, {
		Header = t1.panelHeader,
		HeaderDivider = t1.panelDivider,
		LeaderboardTabs = React.createElement(LeaderboardTabs, {
			layoutOrder = 3,
			activeTabId = v11,
			onActivated = v12,
			onPlatformTabsUnavailable = v13
		}),
		LeaderboardBody = serverBody
	})
end

return React.memo(TabbedLeaderboardBody)
