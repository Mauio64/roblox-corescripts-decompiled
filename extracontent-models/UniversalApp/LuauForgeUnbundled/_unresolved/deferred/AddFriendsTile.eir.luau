local module = require("@luauforge/deferred/egb")
local module2 = require("@luauforge/deferred/eie")
local module3 = require("@luauforge/deferred/eeO")
local module4 = require("@luauforge/deferred/egc")
local module5 = require("@luauforge/deferred/eid")
local module6 = require("@luauforge/deferred/efh")
local module7 = require("@luauforge/deferred/eeZ")
local module8 = require("@luauforge/deferred/eis")
local module9 = require("@luauforge/deferred/egd")
local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization
local module10 = require("@luauforge/deferred/eit")
local useImpressionsTagger = require("@luauforge/deferred/eia").useImpressionsTagger
local useLocalUserId = require("@luauforge/deferred/efV").useLocalUserId
local useNavigation = require("@luauforge/deferred/eeQ").useNavigation
local module11 = require("@luauforge/deferred/eeR")

local view = require("@luauforge/deferred/ege").View

local contexts = module7.Analytics.Enums.Contexts
local sources = module7.Analytics.Enums.Sources
local openTypeSupport = module9.Utility.OpenTypeSupport
local playerTile = module9.App.Tile.PlayerTile
local useSelector = module6.Hooks.RoactRodux.useSelector
local useDispatch = module6.Hooks.RoactRodux.useDispatch
local useFocusGuiObject = module4.useFocusGuiObject
local useStyle = module9.Core.Style.useStyle
local images = module9.App.ImageSet.Images
local appPage = module11.AppPage

local module12 = require("@luauforge/deferred/efj")
local module13 = require("@luauforge/deferred/efP")
local module14 = require("@luauforge/deferred/efg")
local module15 = require("@luauforge/deferred/eeX")
local eventNames = module15.EventNames
local namespaces = module15.Namespaces
local entityTypes = module7.Analytics.Enums.EntityTypes
local getSessionIdByKey = module12.RoduxAnalytics.Selectors.getSessionIdByKey
local module16 = require("@luauforge/deferred/efQ")

require("@luauforge/deferred/eiu")
local module17 = require("@luauforge/deferred/eiv")
local module18 = require("@luauforge/deferred/eiB")
local contextInfoType = require("@luauforge/deferred/eiw").ContextInfoType

local userTileEventHandlers = require("@luauforge/deferred/eiC").UserTileEventHandlers

local getFFlagLuaAppEnableOpenTypeSupport = require("@luauforge/deferred/efc").GetFFlagLuaAppEnableOpenTypeSupport
local useLastInputMode = module.useLastInputMode

require("@luauforge/deferred/egF")

local module19 = require("@luauforge/deferred/efT")
local presenceType = module19.Presence.PresenceEnums.PresenceType

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/efc").FFlagAddFriendsUserListEnabled

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@luauforge/deferred/efc").FFlagAddFriendsPageTrustedFriendRequestSection
local fFlagEnableSplitPane = require("@luauforge/deferred/efc").FFlagEnableSplitPane
local fFlagAddFriendsPymkSessionService = require("@luauforge/deferred/efc").FFlagAddFriendsPymkSessionService

local module20 = require("@luauforge/deferred/eix")

local module21 = require("@luauforge/deferred/eiD")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@luauforge/deferred/efc").FFlagEnableFriendsStoreChallengeInterceptor
local v5 = module19.Friends.FriendsStore.get()
local enums = module19.Friends.Enums
local getUserTrustedConnectionStatus = module19.TrustedConnections.Requests.GetUserTrustedConnectionStatus
local trustedConnectionStatus = module19.TrustedConnections.TrustedConnectionsEnums.TrustedConnectionStatus
local module22 = require("@luauforge/deferred/efU")
local v6

if fFlagAddFriendsPageTrustedFriendRequestSection then
	v6 = module19.TrustedConnections.TrustedConnectionsStore.get()
else
	v6 = nil
end

local function AddFriendsTile(props)
	local v7 = useDispatch()
	local v8 = useFocusGuiObject()
	local v9 = useLastInputMode()
	local v10 = useStyle()

	local ref = module3.useRef(nil)
	local v11 = module5.usePreferredInput() == module5.Input.Directional

	local v12 = module3.useCallback(function()
		local current = props.selected and v9 == "Focus" and ref.current

		if current then
			v8(current)
		end
	end, { props.selected, v9, ref, v8 })

	module3.useEffect(function()
		v12()
	end, {})

	useImpressionsTagger(ref, props.impressionsTag, props.position)

	local isContact = props.isContact or false

	local v13 = useLocalUserId()

	local friendStatus = props.friendStatus
	local rank = props.rank
	local presence = props.presence
	local v14

	if fFlagAddFriendsPymkSessionService then
		v14 = nil
	else
		v14 = useSelector(function(p2)
			return getSessionIdByKey(p2)(module13.RECOMMENDATION_SESSION_ID_KEY)
		end)
	end

	local v15 = module10.Hooks.useUserProfilesFetch({
		userIds = { props.user.id },
		query = module10.Queries.userProfilesCombinedNameByUserIds
	})

	local v17 = useLocalization({
		sentFromWithContextText = {
			"Feature.Friends.Label.SentFromWithContext",
			gameName = ""
		},
		youAreFollowingText = "Feature.Friends.Label.YouAreFollowing",
		followsYouText = "Feature.Friends.Label.FollowsYou",
		fromContactsText = "Feature.Friends.Description.FoundFromContactImporter",
		singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
		mutualConnections = { "Feature.Friends.Label.MutualFriendsTitle" },
		foundThroughQRCode = "Feature.Profile.Label.QRCodeFriendRequest",
		classmatesText = module20 and "Feature.Schools.Label.Classmates" or nil,
		connectionRequests = "Feature.Friends.Label.ConnectionRequest",
		frequents = "Feature.Friends.Label.Frequent",
		fromContacts = "Feature.Friends.Description.FromContacts",
		fromQrCode = "Feature.Friends.Description.FromQrCode",
		fromSearch = "Feature.PlayerSearchResults.Label.FromSearch",
		nowTrusted = {
			"Feature.Friends.Label.NowTrusted",
			username = v15 and v15.data and (module10.Selectors.getCombinedNameFromId(
				v15.data,
				props.user.id
			) or "") or nil
		}
	})

	local v18 = module17(props.contextInfo)
	local kind = props.contextInfo and props.contextInfo.type

	local v20 = {
		targetUserId = props.user.id,
		absolutePosition = props.position,
		rank = rank,
		contextType = kind,
		entityType = 0,
		namespace = 0,
		friendStatus = 0,
		presence = 0
	}

	local v21 = if isContact then entityTypes.Contact else nil
	v20.entityType = v21
	local v22

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		if props.isFriendRequest then
			v22 = namespaces.FriendRequests
		else
			v22 = if props.isTrustedFriendRequest then namespaces.TrustedFriendRequests else namespaces.PYMK
		end
	else
		v22 = if props.isFriendRequest then namespaces.FriendRequests else namespaces.PYMK
	end

	v20.namespace = v22

	v20.friendStatus = friendStatus
	v20.presence = (presence or {}).userPresenceType
	local v23 = module14(v20)

	module3.useEffect(function()
		local v24 = module8.Stopwatch.stop(module8.Events.AFPUserTileLoadFromHomeCarousel)

		if v24 then
			v23(eventNames.AFPUserTileLoadFromHomeCarousel, {
				loadingTime = v24.timeElapsed,
				statValue = v24.timeElapsed
			})
		end
	end, {})

	local v24 = module3.useCallback(function(data)
		if not data then
			return
		end

		v7(module2.Actions.SetCurrentToastMessage({
			toastMessage = data.toastTitle,
			toastIcon = data.iconImage,
			isLocalized = data.isLocalized
		}))
	end, { v7 })

	local v25 = module3.useCallback(function(object, p2)
		return object:andThen(function()
			v24(p2)
		end):catch(function()
			v24({ toastTitle = "Feature.Toast.NetworkingError.SomethingIsWrong" })
		end)
	end, { v24 })

	local v26 = module3.useCallback(function(callback)
		v23(eventNames.AcceptFriendshipBtnClick)
		return v5.AcceptFriendRequest(props.user.id):andThen(function()
			if callback then
				callback()
			end

			if props.contextInfo and props.contextInfo.type == contextInfoType.FromCI then
				return (getUserTrustedConnectionStatus(props.user.id))
			end

			return (module22.resolve(nil))
		end):andThen(function(p2)
			if p2 == trustedConnectionStatus.TrustedFriends then
				v24({
					toastTitle = v17.nowTrusted,
					iconImage = images["icons/actions/friends/friendAdd"],
					isLocalized = true
				})
			else
				v24({
					toastTitle = "Feature.Friends.Action.FriendAdded",
					iconImage = images["icons/actions/friends/friendAdd"]
				})
			end
		end):catch(function()
			v24({ toastTitle = "Feature.Toast.NetworkingError.SomethingIsWrong" })
		end)
	end, { props.user.id, v13, v7, v25, v24, v23, v17.nowTrusted })

	local v27 = module3.useCallback(function(callback)
		v23(eventNames.DeclineFriendshipBtnClick)

		return v25(v5.DeclineFriendRequest(props.user.id):andThen(function(p2)
			if callback then
				callback()
			end

			return p2
		end), {
			toastTitle = "Feature.AddFriends.Action.RequestIgnored",
			iconImage = images["icons/actions/reject"]
		})
	end, { props.user.id, v13, v7, v25, v23 })

	local v28 = module3.useCallback(function()
		v23(eventNames.RequestFriendshipBtnClick)

		local requestFriendship = v5.RequestFriendship
		local id = props.user.id
		local friendRecommendations

		if props.isRecommendation then
			friendRecommendations = enums.FriendshipOriginSourceType.FriendRecommendations
		end

		local v30 = if fFlagEnableFriendsStoreChallengeInterceptor then module21 else nil
		return v25(requestFriendship(id, friendRecommendations, {
			isContact = isContact
		}, v30), {
			toastTitle = "Feature.Friends.Action.FriendRequestSent",
			iconImage = images["icons/actions/friends/friendAdd"]
		})
	end, { isContact, props.isRecommendation, props.user.id, v13, v7, v25, v23 })

	local v29 = useNavigation()
	local v30

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v30 = module3.useCallback(function()
			v29.push(appPage.TrustedContactsModal, {
				props = { userId = props.user.id, source = sources.AddFriendsPage }
			})
		end, { v29, props.user.id })
	end

	local v31

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v31 = module3.useCallback(function()
			return v25(v6.ignoreTrustedConnectionRequest(props.user.id), {
				toastTitle = "Feature.AddFriends.Action.RequestIgnored",
				iconImage = images["icons/actions/reject"]
			})
		end, { props.user.id, v25 })
	end

	local v32 = module3.useCallback(function()
		v23(eventNames.PlayerTileClick)

		local v33 = if fFlagEnableSplitPane then v29.push else v29.navigate
		local profilePlatform = appPage.ProfilePlatform
		local v34 = { detail = props.user.id, extraProps = 0 }
		local v35 = {
			profileType = isContact and "Contact" or nil,
			recommendationSessionId = 0,
			absolutePosition = 0,
			rank = 0,
			isRecommendation = 0,
			isContact = 0,
			contactProps = 0,
			friendStatus = 0,
			source = 0,
			contextualInfoType = 0,
			contextualInfoDisplay = 0
		}

		local v36 = if fFlagAddFriendsPymkSessionService then module16.getPymkSessionId() else v14
		v35.recommendationSessionId = v36

		v35.absolutePosition = props.position
		v35.rank = rank
		v35.isRecommendation = props.isRecommendation
		v35.isContact = isContact
		v35.contactProps = isContact and {
			contactId = props.user.entityId,
			contactname = props.user.entityDisplayName,
			avatarImageUrl = props.user.thumbnailEntities and props.user.thumbnailEntities.avatarImageUrl
		} or nil

		v35.friendStatus = friendStatus
		local v37 = if props.isRecommendation then module13.AddFriendsPYMKSourceName else contexts.AddFriends
		v35.source = v37
		v35.contextualInfoType = kind
		local v38 = if props.isRecommendation then v18 else nil
		v35.contextualInfoDisplay = v38
		v34.extraProps = v35
		v33(profilePlatform, v34)
	end, {
		props.user,
		props.position,
		props.isRecommendation,
		friendStatus,
		v14,
		isContact,
		v29,
		kind,
		v18,
		rank
	})

	local v33 = module3.useCallback(function()
		v32()
	end, { v32 })
	local v34, v35, v36

	if fFlagAddFriendsUserListEnabled then
		v36 = nil
	else
		local v37 = module10.Hooks.useUserProfilesFetch({
			userIds = { props.user.id },
			query = module10.Queries.userProfilesCombinedNameAndUsernameByUserIds,
			skip = isContact
		})

		if isContact then
			v36 = props.user.entityDisplayName

			v34 = props.user.thumbnailEntities and props.user.thumbnailEntities.avatarImageUrl
		else
			local v38

			if v37 and v37.data then
				v36 = module10.Selectors.getCombinedNameFromId(v37.data, props.user.id) or ""
				v38 = module10.Selectors.getUsernameFromId(v37.data, props.user.id) or ""
			else
				v36 = ""
				v38 = ""
			end

			v35 = "@" .. v38
			v34 = string.format("rbxthumb://type=Avatar&id=%s&w=720&h=720", (tostring(props.user.id)))
		end
	end

	local v37 = nil
	local v38 = nil

	if fFlagAddFriendsUserListEnabled then
		v38 = module3.useMemo(function()
			return presence and presence.userPresenceType or presenceType.Offline
		end, { presence })
	else
		local v39 = module3.useMemo(function(): boolean
			local userPresenceType = presence and presence.userPresenceType or nil
			return userPresenceType == presenceType.Online
				or userPresenceType == presenceType.InStudio
				or userPresenceType == presenceType.InGame
		end, { presence })

		local color = v10.Theme.OnlineStatus.Color

		v37 = module3.useMemo(function()
			local formatted = `<font color="rgb({math.round(color.R * 255)},{math.round(color.G * 255)},{math.round(color.B * 255)})">● </font>`

			if v39 then
				return formatted .. v36
			end

			return v36
		end, { v36, v39, color })
	end

	local v40 = {
		ctaActions = props.ctaActions,
		handleRequestFriendship = v28,
		handleAcceptFriendRequest = v26,
		handleDeclineFriendRequest = v27,
		handleAcceptTrustedFriendRequest = 0,
		handleIgnoreTrustedFriendRequest = 0,
		handleViewProfile = 0,
		shouldAddFocusEventName = 0
	}

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		v30 = nil
	end

	v40.handleAcceptTrustedFriendRequest = v30

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		v31 = nil
	end

	v40.handleIgnoreTrustedFriendRequest = v31

	v40.handleViewProfile = v32
	v40.shouldAddFocusEventName = v11
	local v41 = module18(v40)

	if fFlagAddFriendsUserListEnabled then
		local v42 = if v41 then v41[#v41] or nil else nil
		local v43 = if v41 then v41[#v41 - 1] or nil else nil

		local createElement = module3.createElement

		local v46 = {
			UserRow = props.createRow({
				onRowActivated = v33,
				primaryCta = v42 and {
					type = v42.type,
					icon = v42.icon,
					variant = v42.variant,
					isDisabled = v42.isDisabled,
					onActivated = v42.onActivated,
					minWidth = module13.PRIMARY_CTA_BUTTON_MIN_WIDTH,
					maxWidth = module13.PRIMARY_CTA_BUTTON_MAX_WIDTH
				},
				secondaryCta = v43 and {
					type = v43.type,
					icon = v43.icon,
					isDisabled = v43.isDisabled,
					onActivated = v43.onActivated
				},
				contextualInfo = v18 and { text = v18.text, icon = v18.icon },
				loadingState = props.contextInfo and props.contextInfo.type == contextInfoType.Loading and {
					contextualInfo = true
				} or nil,
				presence = v38,
				shouldShowNewIndicator = props.isUnseen
			}),
			UserTileEventHandlers = 0
		}

		local v47 = if v11 then module3.createElement(userTileEventHandlers, {
			buttons = v41,
			onTileActivated = v33,
			tileRef = ref
		}) else nil
		v46.UserTileEventHandlers = v47
		return createElement(view, { tag = "size-full-0 auto-y", ref = ref }, v46)
	else
		local createElement = module3.createElement
		local v43 = {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.new(0, props.size.X, 0, props.size.Y),
			BackgroundTransparency = 1,
			ZIndex = 1,
			LayoutOrder = props.layoutOrder
		}

		local createElement2 = module3.createElement
		local v46 = {
			buttonRef = ref,
			thumbnail = v34,
			title = v37,
			tileSize = UDim2.new(0, props.size.X, 0, props.size.Y),
			subtitle = v35,
			buttons = if not v11 then v41 else nil,
			relevancyInfo = v18,
			onActivated = v33,
			Selectable = true,
			openTypeFeatures = 0
		}

		local v48 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
		v46.openTypeFeatures = v48
		local v44 = {
			PlayerTile = createElement2(playerTile, v46),
			UserTileEventHandlers = 0
		}

		local v49 = if v11 then module3.createElement(userTileEventHandlers, {
			buttons = v41,
			onTileActivated = v33,
			tileRef = ref
		}) else nil
		v44.UserTileEventHandlers = v49
		return createElement("Frame", v43, v44)
	end
end

return AddFriendsTile
