local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent.Parent

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore

local PlayerEntryView = require(parent.Components.PresentationCommon.PlayerEntryView)
local ClosePlayerDropDown = require(parent.Actions.ClosePlayerDropDown)
local OpenPlayerDropDown = require(parent.Actions.OpenPlayerDropDown)
local FFlagReplacePlayerIconRoduxWithSignal = SharedFlags.FFlagReplacePlayerIconRoduxWithSignal
local playerIconInfoStore

if FFlagReplacePlayerIconRoduxWithSignal then
	playerIconInfoStore = PlayerIconInfoStore.PlayerIconInfoStore
else
	playerIconInfoStore = nil
end

local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook

local function PlayerEntryContainer(props)
	local v = useLeaderboardStore()
	local playerIconInfo

	if FFlagReplacePlayerIconRoduxWithSignal then
		local playerIconInfoReactive = playerIconInfoStore.getPlayerIconInfoReactive(props.player.UserId)
		playerIconInfo = SignalsReact.useSignalState(playerIconInfoReactive)
	else
		playerIconInfo = props.playerIconInfo
	end

	local gameStatsList = v.getGameStatsList()
	local playerEntry = v.getPlayerEntry(props.player, false)
	local gameStatsCount

	if not FFlagPlayerListFixLeaderstatsStacking then
		gameStatsCount = SignalsReact.useSignalState(gameStatsList.getCount)
	end

	if not playerEntry then
		return nil
	end

	local createElement = React.createElement

	if FFlagPlayerListFixLeaderstatsStacking then
		gameStatsCount = nil
	end

	local v2 = {
		playerData = playerEntry,
		gameStats = gameStatsList,
		gameStatsCount = gameStatsCount,
		size = props.size,
		entrySizeX = props.entrySizeX,
		layoutOrder = props.layoutOrder,
		player = props.player,
		titlePlayerEntry = props.titlePlayerEntry,
		playerIconInfo = playerIconInfo,
		playerRelationship = props.playerRelationship,
		dropdownOpen = props.dropdownOpen,
		selectedPlayer = props.selectedPlayer,
		firstPlayerRef = props.firstPlayerRef,
		openDropdown = props.openDropdown,
		closeDropdown = props.closeDropdown,
		setDropDownPlayerDimensionY = props.setDropDownPlayerDimensionY,
		prevFocusedEntry = props.prevFocusedEntry,
		destroyedFocusedPlayerId = props.destroyedFocusedPlayerId,
		registerPlayerInstance = 0,
		unregisterPlayerInstance = 0,
		setSelectedPlayerId = 0,
		isSmallTouchDevice = 0,
		isDirectionalPreferred = 0
	}
	local registerPlayerInstance

	if FFlagPlayerListUseFocusNavHook then
		registerPlayerInstance = props.registerPlayerInstance
	end

	v2.registerPlayerInstance = registerPlayerInstance
	local unregisterPlayerInstance

	if FFlagPlayerListUseFocusNavHook then
		unregisterPlayerInstance = props.unregisterPlayerInstance
	end

	v2.unregisterPlayerInstance = unregisterPlayerInstance
	local setSelectedPlayerId

	if FFlagPlayerListUseFocusNavHook then
		setSelectedPlayerId = props.setSelectedPlayerId
	end

	v2.setSelectedPlayerId = setSelectedPlayerId
	v2.isSmallTouchDevice = props.isSmallTouchDevice
	v2.isDirectionalPreferred = props.isDirectionalPreferred
	return (createElement(PlayerEntryView, v2))
end

local function mapStateToProps(p)
	return {
		selectedPlayer = p.playerDropDown.selectedPlayer,
		dropdownOpen = p.playerDropDown.isVisible,
		isSmallTouchDevice = p.displayOptions.isSmallTouchDevice,
		isDirectionalPreferred = p.displayOptions.isTenFootInterface
	}
end

local function mapDispatchToProps(callback)
	return {
		closeDropdown = function()
			return callback(ClosePlayerDropDown())
		end,
		openDropdown = function(p)
			return callback(OpenPlayerDropDown(p))
		end
	}
end

return React.memo(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PlayerEntryContainer))
