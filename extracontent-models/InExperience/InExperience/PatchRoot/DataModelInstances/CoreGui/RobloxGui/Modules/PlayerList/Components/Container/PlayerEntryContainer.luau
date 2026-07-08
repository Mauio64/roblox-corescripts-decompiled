local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent.Parent
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore)
local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore
local PlayerEntryView = require(ParentParent.Components.PresentationCommon.PlayerEntryView)
local ClosePlayerDropDown = require(ParentParent.Actions.ClosePlayerDropDown)
local OpenPlayerDropDown = require(ParentParent.Actions.OpenPlayerDropDown)
local FFlagReplacePlayerIconRoduxWithSignal = SharedFlags.FFlagReplacePlayerIconRoduxWithSignal
local v14 = if not FFlagReplacePlayerIconRoduxWithSignal then nil else PlayerIconInfoStore.PlayerIconInfoStore
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook

local function PlayerEntryContainer(t1: {[any]: any}) -- line: 71
	-- upvalues: useLeaderboardStore (copy), FFlagReplacePlayerIconRoduxWithSignal (copy), v14 (copy), SignalsReact (copy), FFlagPlayerListFixLeaderstatsStacking (copy), React (copy), PlayerEntryView (copy), FFlagPlayerListUseFocusNavHook (copy)
	local v21 = useLeaderboardStore()
	local v23

	if FFlagReplacePlayerIconRoduxWithSignal then
		local v22 = v14.getPlayerIconInfoReactive(t1.player.UserId)

		v23 = SignalsReact.useSignalState(v22)
	else
		v23 = t1.playerIconInfo
	end

	local v24 = v21.getGameStatsList()
	local v25 = v21.getPlayerEntry(t1.player, false)
	local v26 = if not FFlagPlayerListFixLeaderstatsStacking then SignalsReact.useSignalState(v24.getCount) else nil

	if v25 then
		return (React.createElement(PlayerEntryView, {
			playerData = v25,
			gameStats = v24,
			gameStatsCount = if not FFlagPlayerListFixLeaderstatsStacking then v26 else nil,
			size = t1.size,
			entrySizeX = t1.entrySizeX,
			layoutOrder = t1.layoutOrder,
			player = t1.player,
			titlePlayerEntry = t1.titlePlayerEntry,
			playerIconInfo = v23,
			playerRelationship = t1.playerRelationship,
			dropdownOpen = t1.dropdownOpen,
			selectedPlayer = t1.selectedPlayer,
			firstPlayerRef = t1.firstPlayerRef,
			openDropdown = t1.openDropdown,
			closeDropdown = t1.closeDropdown,
			setDropDownPlayerDimensionY = t1.setDropDownPlayerDimensionY,
			prevFocusedEntry = t1.prevFocusedEntry,
			destroyedFocusedPlayerId = t1.destroyedFocusedPlayerId,
			registerPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else t1.registerPlayerInstance,
			unregisterPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else t1.unregisterPlayerInstance,
			setSelectedPlayerId = if not FFlagPlayerListUseFocusNavHook then nil else t1.setSelectedPlayerId,
			isSmallTouchDevice = t1.isSmallTouchDevice,
			isDirectionalPreferred = t1.isDirectionalPreferred
		}))
	end

	return nil
end
local function mapStateToProps(p1) -- line: 116
	return {
		selectedPlayer = p1.playerDropDown.selectedPlayer,
		dropdownOpen = p1.playerDropDown.isVisible,
		isSmallTouchDevice = p1.displayOptions.isSmallTouchDevice,
		isDirectionalPreferred = p1.displayOptions.isTenFootInterface
	}
end
local function mapDispatchToProps(p2) -- line: 126
	-- upvalues: ClosePlayerDropDown (copy), OpenPlayerDropDown (copy)
	return {
		closeDropdown = function() -- line: 128
			-- upvalues: p2 (copy), ClosePlayerDropDown (copy)
			return p2(ClosePlayerDropDown())
		end,
		openDropdown = function(p3) -- line: 131
			-- upvalues: p2 (copy), OpenPlayerDropDown (copy)
			return p2(OpenPlayerDropDown(p3))
		end
	}
end

return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerEntryContainer))
