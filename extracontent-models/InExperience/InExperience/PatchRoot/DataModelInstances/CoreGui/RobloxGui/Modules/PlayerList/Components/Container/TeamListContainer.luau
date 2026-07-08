local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent.Parent
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local LeaderboardStore = require(CorePackages.Workspace.Packages.LeaderboardStore)

require(CorePackages.Workspace.Packages.PlayerIconInfoStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore
local TeamListView = require(ParentParent.Components.PresentationCommon.TeamListView)
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook

local function TeamListContainer(t1: {[any]: any}) -- line: 60
	-- upvalues: useLeaderboardStore (copy), SignalsReact (copy), React (copy), LeaderboardStore (copy), FFlagPlayerListUseFocusNavHook (copy), TeamListView (copy)
	local getCount = useLeaderboardStore().getTeamList().getCount
	local v15 = SignalsReact.useSignalState(getCount)
	local v16 = SignalsReact.useSignalState(t1.teamData.players.getCount)
	local v17 = SignalsReact.useSignalBinding(t1.teamData.order)
	local v18 = React.useMemo(function() -- line: 70
		-- upvalues: t1 (copy), LeaderboardStore (copy), v15 (copy), v16 (copy)
		if t1.teamData.name(false) == LeaderboardStore.SpecialNeutralTeamName then
			if v15 == 1 then
				return false
			end

			if v16 == 0 then
				return false
			end
		end

		return true
	end, {
		v15,
		v16,
		t1.teamData.name
	})
	local v19 = nil
	local v20 = nil

	if FFlagPlayerListUseFocusNavHook then
		v19, v20 = React.useMemo(function() -- line: 86
			-- upvalues: t1 (copy)
			if t1.registerTeamInstance and t1.teamId then
				local v22 = t1.registerTeamInstance(t1.teamId, t1.teamData.order)

				return v22.registerPlayerInstance, v22.unregisterPlayerInstance
			end

			return nil, nil
		end, {
			t1.registerTeamInstance,
			t1.teamId,
			t1.teamData
		})
	end

	if FFlagPlayerListUseFocusNavHook then
		React.useEffect(function() -- line: 97
			-- upvalues: t1 (copy)
			return function() -- line: 98
				-- upvalues: t1 (copy)
				if t1.unregisterTeamInstance and t1.teamId then
					t1.unregisterTeamInstance(t1.teamId)
				end
			end
		end, {
			t1.unregisterTeamInstance,
			t1.teamId
		})
	end

	return React.createElement(TeamListView, {
		layoutOrder = v17,
		showTeamEntry = v18,
		teamPlayersCount = v16,
		entrySizeX = t1.entrySizeX,
		teamData = t1.teamData,
		playerIconInfos = t1.playerIconInfos,
		playerRelationships = t1.playerRelationships,
		firstPlayerRef = t1.firstPlayerRef,
		setDropDownPlayerDimensionY = t1.setDropDownPlayerDimensionY,
		prevFocusedEntry = t1.prevFocusedEntry,
		destroyedFocusedPlayerId = t1.destroyedFocusedPlayerId,
		registerPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else v19,
		unregisterPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else v20,
		setSelectedPlayerId = if not FFlagPlayerListUseFocusNavHook then nil else t1.setSelectedPlayerId,
		isSmallTouchDevice = t1.isSmallTouchDevice,
		isDirectionalPreferred = t1.isDirectionalPreferred
	})
end
local function mapStateToProps(p1) -- line: 127
	return {
		isSmallTouchDevice = p1.displayOptions.isSmallTouchDevice,
		isDirectionalPreferred = p1.displayOptions.isTenFootInterface,
		playerIconInfo = p1.playerIconInfo,
		playerRelationship = p1.playerRelationship
	}
end

return React.memo(RoactRodux.connect(mapStateToProps)(TeamListContainer))
