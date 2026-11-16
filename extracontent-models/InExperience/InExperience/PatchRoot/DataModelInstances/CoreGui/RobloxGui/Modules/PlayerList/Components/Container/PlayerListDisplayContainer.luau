local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent.Parent

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore

local PlayerListDisplayView = require(parent.Components.PresentationCommon.PlayerListDisplayView)
local SetPlayerListVisibility = require(parent.Actions.SetPlayerListVisibility)

local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav

local function PlayerListDisplayContainer(props)
	local v = useLeaderboardStore()

	local gameStatsList = v.getGameStatsList()
	local teamList = v.getTeamList()

	local gameStatsCount = SignalsReact.useSignalState(gameStatsList.getCount)
	local teamListCount = SignalsReact.useSignalState(teamList.getCount)

	if v then
		return (React.createElement(React.Fragment, nil, React.createElement(PlayerListDisplayView, {
			teamList = teamList,
			teamListCount = teamListCount,
			gameStatsCount = gameStatsCount,
			entrySizeX = props.entrySize,
			screenSizeY = props.screenSizeY,
			playerIconInfo = props.playerIconInfo,
			playerRelationship = props.playerRelationship,
			dropDownPlayer = props.dropDownPlayer,
			dropDownVisible = props.dropDownVisible,
			dismissPlayerList = props.dismissPlayerList,
			isVisible = props.isVisible,
			isMinimized = props.isMinimized,
			isSmallTouchDevice = props.isSmallTouchDevice,
			isDirectionalPreferred = props.isDirectionalPreferred,
			isUsingGamepad = props.isUsingGamepad
		})))
	end

	return nil
end

local function PlayerListDisplayContainerWithLeaderboardStore(p)
	if useLeaderboardStore() then
		return PlayerListDisplayContainer(p)
	end

	return nil
end

local function mapDispatchToProps(callback)
	return {
		dismissPlayerList = function()
			return callback(SetPlayerListVisibility(false))
		end
	}
end

local function mapStateToProps(data)
	local isMinimized = data.displayOptions.isMinimized
	local isVisible

	if not FFlagAddNewPlayerListFocusNav then
		isVisible = data.displayOptions.isVisible
	end

	return {
		isVisible = isVisible,
		isMinimized = isMinimized,
		isDirectionalPreferred = data.displayOptions.isTenFootInterface,
		isUsingGamepad = data.displayOptions.isUsingGamepad,
		isSmallTouchDevice = data.displayOptions.isSmallTouchDevice,
		playerIconInfo = data.playerIconInfo,
		playerRelationship = data.playerRelationship,
		dropDownPlayer = data.playerDropDown.selectedPlayer,
		dropDownVisible = data.playerDropDown.isVisible
	}
end

return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerListDisplayContainerWithLeaderboardStore))
