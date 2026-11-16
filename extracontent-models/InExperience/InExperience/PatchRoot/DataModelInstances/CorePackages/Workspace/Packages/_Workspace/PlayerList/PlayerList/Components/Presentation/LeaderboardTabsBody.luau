local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)

local PlayerListVisibilityStore = require(parent.Common.PlayerListVisibilityStore)
local LeaderboardTabs = require(parent.Components.Presentation.LeaderboardTabs)
local PlatformLeaderboardView = require(parent.Components.Presentation.PlatformLeaderboardView)

local function LeaderboardTabsBody(props)
	local getEffectiveVisible = props.getEffectiveVisible or PlayerListVisibilityStore.getEffectiveVisible

	local v = SignalsReact.useSignalState(getEffectiveVisible)
	local leaderboardBody

	if props.activeTabId == "server" or not v then
		leaderboardBody = props.serverBody
	else
		local tab = props.activeTabId == "friends" and "Friends" or "Global"
		leaderboardBody = React.createElement(PlatformLeaderboardView, {
			tab = tab,
			layoutOrder = props.bodyLayoutOrder or 4
		})
	end

	return React.createElement(React.Fragment, nil, {
		LeaderboardTabs = React.createElement(LeaderboardTabs, {
			activeTabId = props.activeTabId,
			onActivated = props.onActivated,
			onPlatformTabsUnavailable = props.onPlatformTabsUnavailable,
			layoutOrder = props.tabsLayoutOrder or 3
		}),
		LeaderboardBody = leaderboardBody
	})
end

return React.memo(LeaderboardTabsBody)
