local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Cryo")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UIBlox")
local openTypeSupport = UIBlox.Utility.OpenTypeSupport
local playerTile = UIBlox.App.Tile.PlayerTile
local useStyle = UIBlox.Core.Style.useStyle
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue

local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/ExperimentLayers").AppUserLayers
local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RoactAppExperiment").useUserExperiment

local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/FocusNavigationUtils").useLastInputMode
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UserLib").Utils.getRbxthumbWithTypeSizeAndOptions
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UserLib").Utils.Constants

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RoactUtils").Hooks.RoactRodux.useSelector
local useContextualInfo = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchTile/useContextualInfo")
local useSearchTileButtons = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchTile/useSearchTileButtons")
local useProfileNames = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchTile/useProfileNames")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Responsive")

local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SignalsReact")
local profileInsightsStore = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/DataHydration/ProfileInsights").ProfileInsightsStore

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/EventNames")
require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/LocalTypes")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/RoundCTAButton")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/Constants")

require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/GraphQLServer")

local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/FriendsCommon").Hooks.useGetPresenceByUserId

local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport

local fFlagBlendedSerpUserPresenceInLineEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagBlendedSerpUserPresenceInLineEnabled
local fFlagUserSearchAddFocusActionsSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchAddFocusActionsSupport

local fFlagLuaAppSearchPeopleUnifiedSchemaFields = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagLuaAppSearchPeopleUnifiedSchemaFields
local FFlagUserSearchPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchPresenceStoreMigration")
local FFlagUserSearchUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchUseProfileFrameThumbnail")

local fFlagUserSearchCancelTileActivationOnHoldIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchCancelTileActivationOnHoldIntent
local fFlagSduiUserSearchTile = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagSduiUserSearchTile

local fFlagPlayerSearchEnableOnlineFrequentsForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagPlayerSearchEnableOnlineFrequentsForAll
local fFlagUserSearchUsePreviousUsernameMatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchUsePreviousUsernameMatch
local fFlagUserSearchClassmatesInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchClassmatesInsight

local RODUX_KEY = Constants.RODUX_KEY
local PresenceHelpers = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Utils/PresenceHelpers")

local userTileEventHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UserTile").UserTileEventHandlers

return function(props)
	local ref = if fFlagUserSearchAddFocusActionsSupport then React.useRef(nil) else nil
	local v5, v6

	if fFlagUserSearchCancelTileActivationOnHoldIntent then
		local ref2 = React.useRef(false)

		v5 = React.useCallback(function(current)
			ref2.current = current
		end, {})
		v6 = ref2
	else
		v6 = nil
	end

	local user = props.user
	local v7 = useStyle()
	local v8

	if fFlagSduiUserSearchTile then
		local v9 = React.useMemo(function()
			local v10 = fFlagPlayerSearchEnableOnlineFrequentsForAll and "profile_info_boost" or nil
			return profileInsightsStore.get().GetProfileInsight(user.id, {
				rankingStrategy = v10,
				count = fFlagUserSearchClassmatesInsight and v10 and 3 or nil
			})
		end, { user.id })
		v8 = SignalsReact.useSignalState(v9.data)
	else
		v8 = props.profileInsight
	end

	local v9 = props.enablePresenceIndicator and not props.shouldUseCompactTiles
	local size_250 = v7.Tokens.Size.Size_250

	local v10 = useUserExperiment(
		{ appUserLayers.OmniSearchResultsPageUXExposureLayer },
		function(p2): boolean
			return (p2[appUserLayers.OmniSearchResultsPageUXExposureLayer] or {}).userPresenceIndicator == "showPresenceInLine"
		end,
		false
	)

	local v11 = useLastInputMode()
	local v12

	if FFlagUserSearchPresenceStoreMigration then
		v12 = useGetPresenceByUserId((tostring(user.id)))
	else
		v12 = useSelector(function(p2)
			return getDeepValue(p2, string.format("%s.Presence.byUserId.%s", RODUX_KEY, user.id)) or {}
		end)
	end

	local v14 = {
		userId = user.id,
		previousUsernames = 0,
		isPreviousUsernameMatch = 0,
		searchKeyword = 0,
		profileInsight = 0,
		shouldUseCompactTiles = 0,
		userPresence = 0
	}
	local v15 = if not fFlagUserSearchUsePreviousUsernameMatch then user.previousUsernames else nil
	v14.previousUsernames = v15
	local v16 = if fFlagUserSearchUsePreviousUsernameMatch then user.isPreviousUsernameMatch else nil
	v14.isPreviousUsernameMatch = v16
	v14.searchKeyword = props.searchParameters.searchKeyword
	v14.profileInsight = v8
	v14.shouldUseCompactTiles = props.shouldUseCompactTiles
	v14.userPresence = v12
	local v17, v18 = useContextualInfo(v14)
	local v19

	if fFlagUserSearchAddFocusActionsSupport then
		v19 = Responsive.usePreferredInput() == Responsive.Input.Directional
	end

	local function fn(playerTileClick, options)
		if props.fireAnalyticsEvent then
			local fireAnalyticsEvent = props.fireAnalyticsEvent

			local join = Cryo.Dictionary.join
			local v20 = {
				playerId = user.id,
				tilePos = props.index,
				contextualInfoType = v18,
				hasEmphasis = props.hasEmphasis,
				rowInSort = props.rowInSort,
				positionInRow = 0,
				feedRowNumber = 0,
				interactionUuid = 0
			}
			local v21 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then props.positionInRow else nil
			v20.positionInRow = v21
			local v22 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then props.feedRowNumber else nil
			v20.feedRowNumber = v22

			local v23 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then HttpService:GenerateGUID(false) else nil
			v20.interactionUuid = v23
			fireAnalyticsEvent(playerTileClick, join(v20, options or {}))
		end
	end

	local function onTileActivated()
		if fFlagUserSearchCancelTileActivationOnHoldIntent and v6.current then
			v6.current = false
			return
		end

		props.luaAppNavigation.navigateToUserInfo({
			userId = user.id,
			index = props.index,
			hasEmphasis = props.hasEmphasis,
			contextualInfoType = v18,
			contextualInfoDisplay = v17
		})

		fn(EventNames.PlayerTileClick)
	end

	local v23 = useSearchTileButtons({
		userId = user.id,
		index = props.index,
		contextualInfoType = v18,
		shouldUseCompactTiles = props.shouldUseCompactTiles,
		userPresence = v12,
		subpage = props.subpage,
		shouldAddFocusEventName = if fFlagUserSearchAddFocusActionsSupport then v19 else nil
	}, fn)
	local v24

	if v17 then
		local v25 = {
			text = v17.text,
			fontStyle = v7.Font.CaptionBody,
			icon = 0,
			horizontalAlignment = 0,
			textXAlignment = 0
		}
		local v26 = if not props.shouldUseCompactTiles then v17.icon else nil
		v25.icon = v26
		local v27 = if props.shouldUseCompactTiles then Enum.HorizontalAlignment.Center else nil
		v25.horizontalAlignment = v27
		local v28 = if props.shouldUseCompactTiles then Enum.TextXAlignment.Center else nil
		v25.textXAlignment = v28
		v24 = v25 or nil
	end

	local v25 = useProfileNames({ userId = user.id })

	local function fn2(p2, p3)
		if not (p3 and p3.combinedName) then
			return ""
		end

		if p2 and PresenceHelpers.isUserOnline(p2.userPresenceType) then
			local color = v7.Theme.OnlineStatus.Color

			return `<font color="rgb({math.round(color.R * 255)},{math.round(color.G * 255)},{math.round(color.B * 255)})">● </font>` .. p3.combinedName
		end

		return p3.combinedName
	end

	local createElement = React.createElement

	local v28 = if fFlagSduiUserSearchTile then UDim2.fromScale(1, 1) else UDim2.fromScale(1, 0)

	local createElement2 = React.createElement

	local v32 = if fFlagSduiUserSearchTile then UDim2.fromScale(1, 1) else UDim2.fromScale(1, 0)

	local createElement3 = React.createElement
	local v35 = {
		buttonRef = if fFlagUserSearchAddFocusActionsSupport then ref else nil,
		tileSize = props.size,
		title = 0,
		subtitle = 0,
		thumbnail = 0,
		onActivated = 0,
		buttons = 0,
		relevancyInfo = 0,
		Selectable = true,
		horizontalAlignment = 0,
		isCircular = 0,
		thumbnailFrameSize = 0,
		openTypeFeatures = 0
	}

	local v37 = if v9 or v10 or fFlagBlendedSerpUserPresenceInLineEnabled then fn2(v12, v25) else v25 and v25.combinedName
	v35.title = v37

	v35.subtitle = v25 and v25.username
	local id = user.id
	local v38 = if props.shouldUseCompactTiles then getStandardSizeAvatarHeadShotRbxthumb(
		tostring(id),
		FFlagUserSearchUseProfileFrameThumbnail
	) else getRbxthumbWithTypeSizeAndOptions(tostring(id), constants.RbxthumbTypes.Avatar, 720)
	v35.thumbnail = v38
	v35.onActivated = onTileActivated
	local v39

	if fFlagUserSearchAddFocusActionsSupport then
		if not (v19 or props.shouldUseCompactTiles) then
			v39 = v23
		end
	elseif not (props.shouldUseCompactTiles or v11 == "Focus") then
		v39 = v23
	end

	v35.buttons = v39

	v35.relevancyInfo = v24

	local v40 = if props.shouldUseCompactTiles then Enum.HorizontalAlignment.Center else nil
	v35.horizontalAlignment = v40
	v35.isCircular = props.shouldUseCompactTiles
	local v41 = if props.shouldUseCompactTiles then UDim2.new(1, -size_250, 1, -size_250) else nil
	v35.thumbnailFrameSize = v41

	local v42 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
	v35.openTypeFeatures = v42
	local v33 = {
		Tile = createElement3(playerTile, v35),
		UserTileEventHandlers = 0
	}
	local v43

	if fFlagUserSearchAddFocusActionsSupport and v19 then
		local createElement4 = React.createElement

		if not fFlagUserSearchCancelTileActivationOnHoldIntent then
			v5 = nil
		end

		v43 = createElement4(userTileEventHandlers, {
			buttons = v23,
			onTileActivated = onTileActivated,
			tileRef = ref,
			setDisabledForHold = v5,
			disableRegularActionOnHoldIntent = fFlagUserSearchCancelTileActivationOnHoldIntent and true or nil
		})
	end

	v33.UserTileEventHandlers = v43
	local v29 = {
		UserTile = createElement2("Frame", {
			BackgroundTransparency = 1,
			Size = v32,
			ZIndex = 1
		}, v33),
		UserTileRoundCTAButton = 0
	}
	local v44

	if
		props.shouldUseCompactTiles
		and v23
		and #v23 > 0
		and not (fFlagUserSearchAddFocusActionsSupport and v19)
	then
		if fFlagSduiUserSearchTile then
			v44 = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeXX
				},
				{
					RoundCTAButton = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(v7.Tokens.Size.Size_900, v7.Tokens.Size.Size_900),
						AnchorPoint = Vector2.new(1, 1),
						Position = UDim2.new(1, -v7.Tokens.Size.Size_250, 1, -v7.Tokens.Size.Size_250)
					}, {
						RoundCTAButton = React.createElement(module10, {
							searchTileButtonProps = v23[1],
							playerTileSize = props.size
						})
					})
				}
			)
		else
			v44 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromOffset(v7.Tokens.Size.Size_900, v7.Tokens.Size.Size_900),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.fromOffset(
					props.size.X.Offset - v7.Tokens.Size.Size_250,
					props.size.X.Offset - v7.Tokens.Size.Size_250
				)
			}, {
				RoundCTAButton = React.createElement(module10, {
					searchTileButtonProps = v23[1],
					playerTileSize = props.size
				})
			})
		end
	end

	v29.UserTileRoundCTAButton = v44
	return createElement("Frame", { BackgroundTransparency = 1, Size = v28 }, v29)
end
