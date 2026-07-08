local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent.Parent
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore
local PlayerListDisplayView = require(ParentParent.Components.PresentationCommon.PlayerListDisplayView)
local SetPlayerListVisibility = require(ParentParent.Actions.SetPlayerListVisibility)
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav

local function PlayerListDisplayContainer(t1: {[any]: any}) -- line: 46
	-- upvalues: useLeaderboardStore (copy), SignalsReact (copy), React (copy), PlayerListDisplayView (copy)
	local v16 = useLeaderboardStore()
	local v17 = v16.getGameStatsList()
	local v18 = v16.getTeamList()
	local v19 = SignalsReact.useSignalState(v17.getCount)
	local v20 = SignalsReact.useSignalState(v18.getCount)

	if v16 then
		return (React.createElement(React.Fragment, nil, React.createElement(PlayerListDisplayView, {
			teamList = v18,
			teamListCount = v20,
			gameStatsCount = v19,
			entrySizeX = t1.entrySize,
			screenSizeY = t1.screenSizeY,
			playerIconInfo = t1.playerIconInfo,
			playerRelationship = t1.playerRelationship,
			dropDownPlayer = t1.dropDownPlayer,
			dropDownVisible = t1.dropDownVisible,
			dismissPlayerList = t1.dismissPlayerList,
			isVisible = t1.isVisible,
			isMinimized = t1.isMinimized,
			isSmallTouchDevice = t1.isSmallTouchDevice,
			isDirectionalPreferred = t1.isDirectionalPreferred,
			isUsingGamepad = t1.isUsingGamepad
		})))
	end

	return nil
end
local function PlayerListDisplayContainerWithLeaderboardStore(t2: {[any]: any}) -- line: 77
	-- upvalues: useLeaderboardStore (copy), PlayerListDisplayContainer (copy)
	if useLeaderboardStore() then
		return (PlayerListDisplayContainer(t2))
	end

	return nil
end
local function mapDispatchToProps(p1) -- line: 85
	-- upvalues: SetPlayerListVisibility (copy)
	return {
		dismissPlayerList = function() -- line: 87
			-- upvalues: p1 (copy), SetPlayerListVisibility (copy)
			return p1(SetPlayerListVisibility(false))
		end
	}
end
local function mapStateToProps(p2) -- line: 93
	-- upvalues: FFlagAddNewPlayerListFocusNav (copy)
	local isMinimized = p2.displayOptions.isMinimized

	return {
		isVisible = if not FFlagAddNewPlayerListFocusNav then p2.displayOptions.isVisible else nil,
		isMinimized = isMinimized,
		isDirectionalPreferred = p2.displayOptions.isTenFootInterface,
		isUsingGamepad = p2.displayOptions.isUsingGamepad,
		isSmallTouchDevice = p2.displayOptions.isSmallTouchDevice,
		playerIconInfo = p2.playerIconInfo,
		playerRelationship = p2.playerRelationship,
		dropDownPlayer = p2.playerDropDown.selectedPlayer,
		dropDownVisible = p2.playerDropDown.isVisible
	}
end

return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerListDisplayContainerWithLeaderboardStore))
