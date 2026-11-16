local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent.Parent

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore

local TitleBarView = require(parent.Components.PresentationCommon.TitleBarView)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking

local function TitleBarContainer(props)
	local gameStatsList = useLeaderboardStore().getGameStatsList()
	local gameStatsCount

	if not FFlagPlayerListFixLeaderstatsStacking then
		gameStatsCount = SignalsReact.useSignalState(gameStatsList.getCount)
	end

	local createElement = React.createElement

	if FFlagPlayerListFixLeaderstatsStacking then
		gameStatsCount = nil
	end

	return createElement(TitleBarView, {
		gameStats = gameStatsList,
		gameStatsCount = gameStatsCount,
		size = props.size,
		entrySizeX = props.entrySizeX,
		layoutOrder = props.layoutOrder,
		contentsVisible = props.contentsVisible,
		isSmallTouchDevice = props.isSmallTouchDevice,
		showDivider = props.showDivider,
		showBackground = props.showBackground,
		backgroundTransparency = props.backgroundTransparency,
		useCustomTextColor = props.useCustomTextColor,
		customTextColor = props.customTextColor,
		headerPaddingLeft = props.headerPaddingLeft
	})
end

return React.memo(TitleBarContainer)
