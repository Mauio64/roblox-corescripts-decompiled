local HttpService = game:GetService("HttpService")
local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local UIBlox = require(parent.UIBlox)
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local PlayerTile = UIBlox.App.Tile.PlayerTile
local useStyle = UIBlox.Core.Style.useStyle
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local UserLib2 = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib2.Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib3 = require(parent.UserLib)
local Constants = UserLib3.Utils.Constants

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useContextualInfo = require(script.Parent.useContextualInfo)
local useSearchTileButtons = require(script.Parent.useSearchTileButtons)
local useProfileNames = require(script.Parent.useProfileNames)
local Responsive = require(parent.Responsive)

local SignalsReact = require(parent.SignalsReact)
local ProfileInsights = require(parent.DataHydration.ProfileInsights)
local ProfileInsightsStore = ProfileInsights.ProfileInsightsStore

local EventNames = require(UserSearch.Analytics.EventNames)
require(UserSearch.Common.LocalTypes)
local RoundCTAButton = require(UserSearch.Components.RoundCTAButton)
local Constants2 = require(UserSearch.Common.Constants)

require(parent.GraphQLServer)

local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport

local SharedFlags2 = require(parent.SharedFlags)
local FFlagBlendedSerpUserPresenceInLineEnabled = SharedFlags2.FFlagBlendedSerpUserPresenceInLineEnabled
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserSearchAddFocusActionsSupport = SharedFlags3.FFlagUserSearchAddFocusActionsSupport

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = SharedFlags4.FFlagLuaAppSearchPeopleUnifiedSchemaFields
local FFlagUserSearchPresenceStoreMigration = require(UserSearch.Flags.FFlagUserSearchPresenceStoreMigration)
local FFlagUserSearchUseProfileFrameThumbnail = require(UserSearch.Flags.FFlagUserSearchUseProfileFrameThumbnail)

local SharedFlags5 = require(parent.SharedFlags)
local FFlagUserSearchCancelTileActivationOnHoldIntent = SharedFlags5.FFlagUserSearchCancelTileActivationOnHoldIntent
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiUserSearchTile = SharedFlags6.FFlagSduiUserSearchTile

local SharedFlags7 = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequentsForAll = SharedFlags7.FFlagPlayerSearchEnableOnlineFrequentsForAll
local SharedFlags8 = require(parent.SharedFlags)
local FFlagUserSearchClassmatesInsight = SharedFlags8.FFlagUserSearchClassmatesInsight

local RODUX_KEY = Constants2.RODUX_KEY
local PresenceHelpers = require(UserSearch.Utils.PresenceHelpers)

local UserTile = require(parent.UserTile)
local UserTileEventHandlers = UserTile.UserTileEventHandlers

local function fn(id, shouldUseCompactTiles: boolean?) -- 1 equivalent call inferred from this helper
	if shouldUseCompactTiles then
		return getStandardSizeAvatarHeadShotRbxthumb(tostring(id), FFlagUserSearchUseProfileFrameThumbnail)
	end

	return getRbxthumbWithTypeSizeAndOptions(tostring(id), Constants.RbxthumbTypes.Avatar, 720)
end

return function(props)
	local ref

	if FFlagUserSearchAddFocusActionsSupport then
		ref = React.useRef(nil)
	end

	local ref2, setDisabledForHold

	if FFlagUserSearchCancelTileActivationOnHoldIntent then
		ref2 = React.useRef(false)

		setDisabledForHold = React.useCallback(function(current: boolean)
			ref2.current = current
		end, {})
	else
		ref2 = nil
	end

	local user = props.user
	local v = useStyle()
	local profileInsight

	if FFlagSduiUserSearchTile then
		local v2 = React.useMemo(function()
			local rankingStrategy = FFlagPlayerSearchEnableOnlineFrequentsForAll and "profile_info_boost" or nil
			return ProfileInsightsStore.get().GetProfileInsight(user.id, {
				rankingStrategy = rankingStrategy,
				count = FFlagUserSearchClassmatesInsight and rankingStrategy and 3 or nil
			})
		end, { user.id })
		profileInsight = SignalsReact.useSignalState(v2.data)
	else
		profileInsight = props.profileInsight
	end

	local v2 = props.enablePresenceIndicator and not props.shouldUseCompactTiles
	local size_250 = v.Tokens.Size.Size_250

	local v3 = useUserExperiment({ AppUserLayers.OmniSearchResultsPageUXExposureLayer }, function(p): boolean
		return (p[AppUserLayers.OmniSearchResultsPageUXExposureLayer] or {}).userPresenceIndicator == "showPresenceInLine"
	end, false)

	local v4 = useLastInputMode()
	local userPresence

	if FFlagUserSearchPresenceStoreMigration then
		userPresence = useGetPresenceByUserId((tostring(user.id)))
	else
		userPresence = useSelector(function(p)
			return getDeepValue(p, string.format("%s.Presence.byUserId.%s", RODUX_KEY, user.id)) or {}
		end)
	end

	local contextualInfoDisplay, contextualInfoType = useContextualInfo({
		userId = user.id,
		previousUsernames = user.previousUsernames,
		searchKeyword = props.searchParameters.searchKeyword,
		profileInsight = profileInsight,
		shouldUseCompactTiles = props.shouldUseCompactTiles,
		userPresence = userPresence
	})
	local v5

	if FFlagUserSearchAddFocusActionsSupport then
		v5 = Responsive.usePreferredInput() == Responsive.Input.Directional
	end

	local function fn2(playerTileClick: string, options)
		if props.fireAnalyticsEvent then
			local fireAnalyticsEvent = props.fireAnalyticsEvent

			local join = Cryo.Dictionary.join
			local v6 = {
				playerId = user.id,
				tilePos = props.index,
				contextualInfoType = contextualInfoType,
				hasEmphasis = props.hasEmphasis,
				rowInSort = props.rowInSort,
				positionInRow = 0,
				feedRowNumber = 0,
				interactionUuid = 0
			}
			local positionInRow

			if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
				positionInRow = props.positionInRow
			end

			v6.positionInRow = positionInRow
			local feedRowNumber

			if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
				feedRowNumber = props.feedRowNumber
			end

			v6.feedRowNumber = feedRowNumber
			local interactionUuid

			if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
				interactionUuid = HttpService:GenerateGUID(false)
			end

			v6.interactionUuid = interactionUuid
			fireAnalyticsEvent(playerTileClick, join(v6, options or {}))
		end
	end

	local function onTileActivated()
		if FFlagUserSearchCancelTileActivationOnHoldIntent and ref2.current then
			ref2.current = false
			return
		end

		props.luaAppNavigation.navigateToUserInfo({
			userId = user.id,
			index = props.index,
			hasEmphasis = props.hasEmphasis,
			contextualInfoType = contextualInfoType,
			contextualInfoDisplay = contextualInfoDisplay
		})

		fn2(EventNames.PlayerTileClick)
	end

	local v6 = {
		userId = user.id,
		index = props.index,
		contextualInfoType = contextualInfoType,
		shouldUseCompactTiles = props.shouldUseCompactTiles,
		userPresence = userPresence,
		subpage = props.subpage,
		shouldAddFocusEventName = 0
	}
	local shouldAddFocusEventName

	if FFlagUserSearchAddFocusActionsSupport then
		shouldAddFocusEventName = v5
	end

	v6.shouldAddFocusEventName = shouldAddFocusEventName
	local buttons = useSearchTileButtons(v6, fn2)
	local relevancyInfo

	if contextualInfoDisplay then
		local v7 = {
			text = contextualInfoDisplay.text,
			fontStyle = v.Font.CaptionBody,
			icon = 0,
			horizontalAlignment = 0,
			textXAlignment = 0
		}
		local icon

		if not props.shouldUseCompactTiles then
			icon = contextualInfoDisplay.icon
		end

		v7.icon = icon
		local horizontalAlignment

		if props.shouldUseCompactTiles then
			horizontalAlignment = Enum.HorizontalAlignment.Center
		end

		v7.horizontalAlignment = horizontalAlignment
		local textXAlignment

		if props.shouldUseCompactTiles then
			textXAlignment = Enum.TextXAlignment.Center
		end

		v7.textXAlignment = textXAlignment
		relevancyInfo = v7 or nil
	end

	local v7 = useProfileNames({ userId = user.id })

	local function fn3(p, p2)
		if not (p2 and p2.combinedName) then
			return ""
		end

		if p and PresenceHelpers.isUserOnline(p.userPresenceType) then
			local color = v.Theme.OnlineStatus.Color

			return `<font color="rgb({math.round(color.R * 255)},{math.round(color.G * 255)},{math.round(color.B * 255)})">● </font>` .. p2.combinedName
		end

		return p2.combinedName
	end

	local createElement = React.createElement
	local size

	if FFlagSduiUserSearchTile then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.fromScale(1, 0)
	end

	local createElement2 = React.createElement
	local size2

	if FFlagSduiUserSearchTile then
		size2 = UDim2.fromScale(1, 1)
	else
		size2 = UDim2.fromScale(1, 0)
	end

	local createElement3 = React.createElement
	local buttonRef

	if FFlagUserSearchAddFocusActionsSupport then
		buttonRef = ref
	end

	local v8 = {
		buttonRef = buttonRef,
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
	local title

	if v2 or v3 or FFlagBlendedSerpUserPresenceInLineEnabled then
		title = fn3(userPresence, v7)
	else
		title = v7 and v7.combinedName
	end

	v8.title = title

	v8.subtitle = v7 and v7.username
	v8.thumbnail = fn(user.id, props.shouldUseCompactTiles) -- inferred equivalent call
	v8.onActivated = onTileActivated
	local buttons2

	if FFlagUserSearchAddFocusActionsSupport then
		if not (v5 or props.shouldUseCompactTiles) then
			buttons2 = buttons
		end
	elseif not (props.shouldUseCompactTiles or v4 == "Focus") then
		buttons2 = buttons
	end

	v8.buttons = buttons2

	v8.relevancyInfo = relevancyInfo
	local horizontalAlignment

	if props.shouldUseCompactTiles then
		horizontalAlignment = Enum.HorizontalAlignment.Center
	end

	v8.horizontalAlignment = horizontalAlignment
	v8.isCircular = props.shouldUseCompactTiles
	local thumbnailFrameSize

	if props.shouldUseCompactTiles then
		thumbnailFrameSize = UDim2.new(1, -size_250, 1, -size_250)
	end

	v8.thumbnailFrameSize = thumbnailFrameSize
	local openTypeFeatures

	if GetFFlagLuaAppEnableOpenTypeSupport() then
		openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
	end

	v8.openTypeFeatures = openTypeFeatures
	local v9 = { Tile = createElement3(PlayerTile, v8), UserTileEventHandlers = 0 }
	local userTileEventHandlers

	if FFlagUserSearchAddFocusActionsSupport and v5 then
		local createElement4 = React.createElement

		if not FFlagUserSearchCancelTileActivationOnHoldIntent then
			setDisabledForHold = nil
		end

		userTileEventHandlers = createElement4(UserTileEventHandlers, {
			buttons = buttons,
			onTileActivated = onTileActivated,
			tileRef = ref,
			setDisabledForHold = setDisabledForHold,
			disableRegularActionOnHoldIntent = FFlagUserSearchCancelTileActivationOnHoldIntent and true or nil
		})
	end

	v9.UserTileEventHandlers = userTileEventHandlers
	local v10 = {
		UserTile = createElement2("Frame", { BackgroundTransparency = 1, Size = size2, ZIndex = 1 }, v9),
		UserTileRoundCTAButton = 0
	}
	local userTileRoundCTAButton

	if
		props.shouldUseCompactTiles
		and buttons
		and #buttons > 0
		and not (FFlagUserSearchAddFocusActionsSupport and v5)
	then
		if FFlagSduiUserSearchTile then
			userTileRoundCTAButton = React.createElement(
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
						Size = UDim2.fromOffset(v.Tokens.Size.Size_900, v.Tokens.Size.Size_900),
						AnchorPoint = Vector2.new(1, 1),
						Position = UDim2.new(1, -v.Tokens.Size.Size_250, 1, -v.Tokens.Size.Size_250)
					}, {
						RoundCTAButton = React.createElement(RoundCTAButton, {
							searchTileButtonProps = buttons[1],
							playerTileSize = props.size
						})
					})
				}
			)
		else
			userTileRoundCTAButton = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromOffset(v.Tokens.Size.Size_900, v.Tokens.Size.Size_900),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.fromOffset(
					props.size.X.Offset - v.Tokens.Size.Size_250,
					props.size.X.Offset - v.Tokens.Size.Size_250
				)
			}, {
				RoundCTAButton = React.createElement(RoundCTAButton, {
					searchTileButtonProps = buttons[1],
					playerTileSize = props.size
				})
			})
		end
	end

	v10.UserTileRoundCTAButton = userTileRoundCTAButton
	return createElement("Frame", { BackgroundTransparency = 1, Size = size }, v10)
end
