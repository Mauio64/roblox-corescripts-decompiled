local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent.Parent

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local LeaderboardStore = require(CorePackages.Workspace.Packages.LeaderboardStore)
require(CorePackages.Workspace.Packages.PlayerIconInfoStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore

local TeamListView = require(parent.Components.PresentationCommon.TeamListView)

local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook

local function TeamListContainer(props)
	local getCount = useLeaderboardStore().getTeamList().getCount

	local v = SignalsReact.useSignalState(getCount)
	local teamPlayersCount = SignalsReact.useSignalState(props.teamData.players.getCount)

	local layoutOrder = SignalsReact.useSignalBinding(props.teamData.order)

	local showTeamEntry = React.useMemo(function(): boolean
		if props.teamData.name(false) ~= LeaderboardStore.SpecialNeutralTeamName then
			return true
		end

		return v ~= 1 and teamPlayersCount ~= 0
	end, { v, teamPlayersCount, props.teamData.name })
	local registerPlayerInstance, unregisterPlayerInstance

	if FFlagPlayerListUseFocusNavHook then
		registerPlayerInstance, unregisterPlayerInstance = React.useMemo(function()
			if props.registerTeamInstance and props.teamId then
				local teamInstance = props.registerTeamInstance(props.teamId, props.teamData.order)
				return teamInstance.registerPlayerInstance, teamInstance.unregisterPlayerInstance
			end

			return nil, nil
		end, { props.registerTeamInstance, props.teamId, props.teamData })
	end

	if FFlagPlayerListUseFocusNavHook then
		React.useEffect(function()
			return function()
				if props.unregisterTeamInstance and props.teamId then
					props.unregisterTeamInstance(props.teamId)
				end
			end
		end, { props.unregisterTeamInstance, props.teamId })
	end

	local createElement = React.createElement
	local v2 = {
		layoutOrder = layoutOrder,
		showTeamEntry = showTeamEntry,
		teamPlayersCount = teamPlayersCount,
		entrySizeX = props.entrySizeX,
		teamData = props.teamData,
		playerIconInfos = props.playerIconInfos,
		playerRelationships = props.playerRelationships,
		firstPlayerRef = props.firstPlayerRef,
		setDropDownPlayerDimensionY = props.setDropDownPlayerDimensionY,
		prevFocusedEntry = props.prevFocusedEntry,
		destroyedFocusedPlayerId = props.destroyedFocusedPlayerId,
		registerPlayerInstance = 0,
		unregisterPlayerInstance = 0,
		setSelectedPlayerId = 0,
		isSmallTouchDevice = 0,
		isDirectionalPreferred = 0
	}

	if not FFlagPlayerListUseFocusNavHook then
		registerPlayerInstance = nil
	end

	v2.registerPlayerInstance = registerPlayerInstance

	if not FFlagPlayerListUseFocusNavHook then
		unregisterPlayerInstance = nil
	end

	v2.unregisterPlayerInstance = unregisterPlayerInstance
	local setSelectedPlayerId

	if FFlagPlayerListUseFocusNavHook then
		setSelectedPlayerId = props.setSelectedPlayerId
	end

	v2.setSelectedPlayerId = setSelectedPlayerId
	v2.isSmallTouchDevice = props.isSmallTouchDevice
	v2.isDirectionalPreferred = props.isDirectionalPreferred
	return createElement(TeamListView, v2)
end

local function mapStateToProps(data)
	return {
		isSmallTouchDevice = data.displayOptions.isSmallTouchDevice,
		isDirectionalPreferred = data.displayOptions.isTenFootInterface,
		playerIconInfo = data.playerIconInfo,
		playerRelationship = data.playerRelationship
	}
end

return React.memo(RoactRodux.connect(mapStateToProps)(TeamListContainer))
