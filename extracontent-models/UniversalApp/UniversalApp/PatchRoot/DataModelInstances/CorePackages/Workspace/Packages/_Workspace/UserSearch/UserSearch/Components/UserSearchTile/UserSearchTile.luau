local HttpService = game:GetService("HttpService")
local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local React = require(UserSearchParent.React)
local Cryo = require(UserSearchParent.Cryo)
local UIBlox = require(UserSearchParent.UIBlox)
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local PlayerTile = UIBlox.App.Tile.PlayerTile
local useStyle = UIBlox.Core.Style.useStyle
local LuaSocialLibrariesDeps = require(UserSearchParent.LuaSocialLibrariesDeps)
local Enums = require(UserSearchParent.FriendsNetworking).Enums
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local AppUserLayers = require(UserSearchParent.ExperimentLayers).AppUserLayers
local useUserExperiment = require(UserSearchParent.RoactAppExperiment).useUserExperiment
local useLastInputMode = require(UserSearchParent.FocusNavigationUtils).useLastInputMode
local SetCentralOverlay = require(UserSearchParent.CentralOverlay).Actions.SetCentralOverlay
local useDispatch = require(UserSearchParent.RoactUtils).Hooks.RoactRodux.useDispatch
local getStandardSizeAvatarHeadShotRbxthumb = require(UserSearchParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local getRbxthumbWithTypeSizeAndOptions = require(UserSearchParent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require(UserSearchParent.UserLib).Utils.Constants
local useSelector = require(UserSearchParent.RoactUtils).Hooks.RoactRodux.useSelector
local useContextualInfo = require(script.Parent.useContextualInfo)
local useSearchTileButtons = require(script.Parent.useSearchTileButtons)
local useProfileNames = require(script.Parent.useProfileNames)
local useRelationshipSelector = require(script.Parent.useRelationshipSelector)
local Responsive = require(UserSearchParent.Responsive)
local EventNames = require(UserSearch.Analytics.EventNames)

require(UserSearch.Common.LocalTypes)

local RoundCTAButton = require(UserSearch.Components.RoundCTAButton)
local Constants2 = require(UserSearch.Common.Constants)

require(UserSearchParent.GraphQLServer)

local GetFFlagLuaAppEnableOpenTypeSupport = require(UserSearchParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local FFlagBlendedSerpUserPresenceInLineEnabled = require(UserSearchParent.SharedFlags).FFlagBlendedSerpUserPresenceInLineEnabled
local FFlagUserSearchAddFocusActionsSupport = require(UserSearchParent.SharedFlags).FFlagUserSearchAddFocusActionsSupport
local FFlagPPVEnabledOnConsole = require(UserSearchParent.SharedFlags).FFlagPPVEnabledOnConsole
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = require(UserSearchParent.SharedFlags).FFlagLuaAppSearchPeopleUnifiedSchemaFields
local RODUX_KEY = Constants2.RODUX_KEY
local PresenceHelpers = require(UserSearch.Utils.PresenceHelpers)
local UserTileEventHandlers = require(UserSearchParent.UserTile).UserTileEventHandlers

return function(t1: {[any]: any}) -- line: 90
	-- upvalues: FFlagUserSearchAddFocusActionsSupport (copy), React (copy), useStyle (copy), useDispatch (copy), useRelationshipSelector (copy), useUserExperiment (copy), AppUserLayers (copy), useLastInputMode (copy), useSelector (copy), getDeepValue (copy), RODUX_KEY (copy), useContextualInfo (copy), FFlagPPVEnabledOnConsole (copy), Responsive (copy), Cryo (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), HttpService (copy), SetCentralOverlay (copy), Enums (copy), EventNames (copy), useSearchTileButtons (copy), useProfileNames (copy), PresenceHelpers (copy), PlayerTile (copy), FFlagBlendedSerpUserPresenceInLineEnabled (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), UserTileEventHandlers (copy), RoundCTAButton (copy)
	local v41 = if not FFlagUserSearchAddFocusActionsSupport then nil else React.useRef(nil)
	local user = t1.user
	local v43 = useStyle()
	local v44 = useDispatch()
	local v45 = useRelationshipSelector(user.id)
	local v46 = t1.enablePresenceIndicator and not t1.shouldUseCompactTiles
	local Size_250 = v43.Tokens.Size.Size_250
	local v48 = useUserExperiment({ AppUserLayers.OmniSearchResultsPageUXExposureLayer }, function(p1) -- line: 102
		-- upvalues: AppUserLayers (copy)
		return (p1[AppUserLayers.OmniSearchResultsPageUXExposureLayer] or {}).userPresenceIndicator == "showPresenceInLine"
	end, false)
	local v49 = useLastInputMode()
	local v50 = useSelector(function(p2) -- line: 112
		-- upvalues: getDeepValue (copy), RODUX_KEY (copy), user (copy)
		return getDeepValue(p2, string.format("%s.Presence.byUserId.%s", RODUX_KEY, user.id)) or {}
	end)
	local v51, v52 = useContextualInfo({
		userId = user.id,
		previousUsernames = user.previousUsernames,
		searchKeyword = t1.searchParameters.searchKeyword,
		profileInsight = t1.profileInsight,
		shouldUseCompactTiles = t1.shouldUseCompactTiles,
		userPresence = v50
	})
	local v53 = if not FFlagPPVEnabledOnConsole then Responsive.usePreferredInput() == Responsive.Input.Directional else nil
	local v54 = if not FFlagPPVEnabledOnConsole then v53 else nil
	local v55 = if not FFlagUserSearchAddFocusActionsSupport then nil else Responsive.usePreferredInput() == Responsive.Input.Directional

	local function v56(s1: string, p3) -- line: 135
		-- upvalues: t1 (copy), Cryo (copy), user (copy), v52 (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), HttpService (copy)
		if t1.fireAnalyticsEvent then
			t1.fireAnalyticsEvent(s1, Cryo.Dictionary.join({
				playerId = user.id,
				tilePos = t1.index,
				contextualInfoType = v52,
				hasEmphasis = t1.hasEmphasis,
				rowInSort = t1.rowInSort,
				positionInRow = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else t1.positionInRow,
				feedRowNumber = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else t1.feedRowNumber,
				interactionUuid = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else HttpService:GenerateGUID(false)
			}, p3 or {}))
		end
	end
	local function v57() -- line: 155
		-- upvalues: v54 (copy), FFlagPPVEnabledOnConsole (copy), v44 (copy), SetCentralOverlay (copy), user (copy), v45 (copy), Enums (copy), t1 (copy), v52 (copy), v51 (copy), v56 (copy), EventNames (copy)
		if v54 and not FFlagPPVEnabledOnConsole then
			v44(SetCentralOverlay("PlayerContextualMenu", {
				subjectUserId = user.id,
				robloxFriendshipStatus = v45.status,
				friendshipOriginSourceType = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()
			}))
		else
			t1.luaAppNavigation.navigateToUserInfo({
				userId = user.id,
				index = t1.index,
				hasEmphasis = t1.hasEmphasis,
				contextualInfoType = v52,
				contextualInfoDisplay = v51
			})
		end

		v56(EventNames.PlayerTileClick)
	end

	local v58 = useSearchTileButtons({
		userId = user.id,
		index = t1.index,
		contextualInfoType = v52,
		shouldUseCompactTiles = t1.shouldUseCompactTiles,
		userPresence = v50,
		subpage = t1.subpage,
		shouldAddFocusEventName = if not FFlagUserSearchAddFocusActionsSupport then nil else v55
	}, v56)
	local v59 = v51 and {
		text = v51.text,
		fontStyle = v43.Font.CaptionBody,
		icon = if not t1.shouldUseCompactTiles then v51.icon else nil,
		horizontalAlignment = if not t1.shouldUseCompactTiles then nil else Enum.HorizontalAlignment.Center,
		textXAlignment = if not t1.shouldUseCompactTiles then nil else Enum.TextXAlignment.Center
	} or nil
	local v60 = useProfileNames({
		userId = user.id
	})
	local createElement = React.createElement
	local t2 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0)
	}
	local t3 = {}
	local createElement2 = React.createElement
	local t4 = {
		BackgroundTransparency = 1,
		ZIndex = 1,
		Size = UDim2.fromScale(1, 0)
	}
	local t5 = {}
	local createElement3 = React.createElement
	local v68 = PlayerTile
	local t6 = {
		Selectable = true,
		buttonRef = if not FFlagUserSearchAddFocusActionsSupport then nil else v41,
		tileSize = t1.size,
		title = if not v46 and (not v48 and not FFlagBlendedSerpUserPresenceInLineEnabled) then v60 and v60.combinedName else (function(p4, p5) -- line: 199
			-- upvalues: PresenceHelpers (copy), v43 (copy)
			if not p5 or not p5.combinedName then
				return ""
			end

			if not p4 or not PresenceHelpers.isUserOnline(p4.userPresenceType) then
				return p5.combinedName
			end

			local OnlineStatusColor = v43.Theme.OnlineStatus.Color

			return `<font color="rgb({ math.round(OnlineStatusColor.R * 255) },{ math.round(OnlineStatusColor.G * 255) },{ math.round(OnlineStatusColor.B * 255) })">● </font>` .. p5.combinedName
		end)(v50, v60),
		subtitle = v60 and v60.username
	}
	local id = user.id

	t6.thumbnail = if not t1.shouldUseCompactTiles then getRbxthumbWithTypeSizeAndOptions(tostring(id), Constants.RbxthumbTypes.Avatar, 720) else getStandardSizeAvatarHeadShotRbxthumb((tostring(id)))
	t6.onActivated = v57
	t6.buttons = if not FFlagUserSearchAddFocusActionsSupport then if not t1.shouldUseCompactTiles and v49 ~= "Focus" then v58 else nil else if not v55 and not t1.shouldUseCompactTiles then v58 else nil
	t6.relevancyInfo = v59
	t6.horizontalAlignment = if not t1.shouldUseCompactTiles then nil else Enum.HorizontalAlignment.Center
	t6.isCircular = t1.shouldUseCompactTiles
	t6.thumbnailFrameSize = if not t1.shouldUseCompactTiles then nil else UDim2.new(1, -Size_250, 1, -Size_250)
	t6.openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
	t5.Tile = createElement3(v68, t6)
	t5.UserTileEventHandlers = if not FFlagUserSearchAddFocusActionsSupport or not v55 then nil else React.createElement(UserTileEventHandlers, {
		buttons = v58,
		onTileActivated = v57,
		tileRef = v41
	})
	t3.UserTile = createElement2("Frame", t4, t5)
	t3.UserTileRoundCTAButton = if not t1.shouldUseCompactTiles or (not v58 or (not (#v58 > 0) or not not FFlagUserSearchAddFocusActionsSupport and v55)) then nil else React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.fromOffset(v43.Tokens.Size.Size_900, v43.Tokens.Size.Size_900),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromOffset(t1.size.X.Offset - v43.Tokens.Size.Size_250, t1.size.X.Offset - v43.Tokens.Size.Size_250)
	}, {
		RoundCTAButton = React.createElement(RoundCTAButton, {
			searchTileButtonProps = v58[1],
			playerTileSize = t1.size
		})
	})

	return createElement("Frame", t2, t3)
end
