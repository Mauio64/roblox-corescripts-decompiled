local module = require("@luauforge/deferred/eiR")
local module2 = require("@luauforge/deferred/ely")
local module3 = require("@luauforge/deferred/eil")
local module4 = require("@luauforge/deferred/eiS")
local module5 = require("@luauforge/deferred/elx")
local module6 = require("@luauforge/deferred/eiP")
local module7 = require("@luauforge/deferred/eiw")
local module8 = require("@luauforge/deferred/elN")
local module9 = require("@luauforge/deferred/eiT")
local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization
local module10 = require("@luauforge/deferred/elO")
local useImpressionsTagger = require("@luauforge/deferred/elu").useImpressionsTagger
local useLocalUserId = require("@luauforge/deferred/eiQ").useLocalUserId
local useNavigation = require("@luauforge/deferred/ein").useNavigation
local module11 = require("@luauforge/deferred/eio")

local view = require("@luauforge/deferred/eiU").View

local contexts = module7.Analytics.Enums.Contexts
local sources = module7.Analytics.Enums.Sources
local openTypeSupport = module9.Utility.OpenTypeSupport
local playerTile = module9.App.Tile.PlayerTile
local useDispatch = module6.Hooks.RoactRodux.useDispatch
local useFocusGuiObject = module4.useFocusGuiObject
local useStyle = module9.Core.Style.useStyle
local images = module9.App.ImageSet.Images
local appPage = module11.AppPage

local module12 = require("@luauforge/deferred/elD")
local module13 = require("@luauforge/deferred/eiD")
local module14 = require("@luauforge/deferred/eiu")
local eventNames = module14.EventNames
local namespaces = module14.Namespaces
local entityTypes = module7.Analytics.Enums.EntityTypes
local module15 = require("@luauforge/deferred/eiF")

require("@luauforge/deferred/elP")
local module16 = require("@luauforge/deferred/elQ")
local module17 = require("@luauforge/deferred/elW")
local contextInfoType = require("@luauforge/deferred/elR").ContextInfoType

local userTileEventHandlers = require("@luauforge/deferred/elX").UserTileEventHandlers

local getFFlagLuaAppEnableOpenTypeSupport = require("@luauforge/deferred/eiz").GetFFlagLuaAppEnableOpenTypeSupport
local useLastInputMode = module.useLastInputMode

require("@luauforge/deferred/eka")

local module18 = require("@luauforge/deferred/eiI")
local presenceType = module18.Presence.PresenceEnums.PresenceType

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/eiz").FFlagAddFriendsUserListEnabled

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@luauforge/deferred/eiz").FFlagAddFriendsPageTrustedFriendRequestSection
local fFlagEnableSplitPane = require("@luauforge/deferred/eiz").FFlagEnableSplitPane

local module19 = require("@luauforge/deferred/elS")

local module20 = require("@luauforge/deferred/elY")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@luauforge/deferred/eiz").FFlagEnableFriendsStoreChallengeInterceptor
local v5 = module18.Friends.FriendsStore.get()
local enums = module18.Friends.Enums
local getUserTrustedConnectionStatus = module18.TrustedConnections.Requests.GetUserTrustedConnectionStatus
local trustedConnectionStatus = module18.TrustedConnections.TrustedConnectionsEnums.TrustedConnectionStatus
local module21 = require("@luauforge/deferred/eiJ")
local v6

if fFlagAddFriendsPageTrustedFriendRequestSection then
	v6 = module18.TrustedConnections.TrustedConnectionsStore.get()
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

	local v14 = module10.Hooks.useUserProfilesFetch({
		userIds = { props.user.id },
		query = module10.Queries.userProfilesCombinedNameByUserIds
	})

	local v16 = useLocalization({
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
		classmatesText = module19 and "Feature.Schools.Label.Classmates" or nil,
		connectionRequests = "Feature.Friends.Label.ConnectionRequest",
		frequents = "Feature.Friends.Label.Frequent",
		fromContacts = "Feature.Friends.Description.FromContacts",
		fromQrCode = "Feature.Friends.Description.FromQrCode",
		fromSearch = "Feature.PlayerSearchResults.Label.FromSearch",
		nowTrusted = {
			"Feature.Friends.Label.NowTrusted",
			username = v14 and v14.data and (module10.Selectors.getCombinedNameFromId(
				v14.data,
				props.user.id
			) or "") or nil
		}
	})

	local v17 = module16(props.contextInfo)
	local kind = props.contextInfo and props.contextInfo.type

	local v19 = {
		targetUserId = props.user.id,
		absolutePosition = props.position,
		rank = rank,
		contextType = kind,
		entityType = 0,
		namespace = 0,
		friendStatus = 0,
		presence = 0
	}

	local v20 = if isContact then entityTypes.Contact else nil
	v19.entityType = v20
	local v21

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		if props.isFriendRequest then
			v21 = namespaces.FriendRequests
		else
			v21 = if props.isTrustedFriendRequest then namespaces.TrustedFriendRequests else namespaces.PYMK
		end
	else
		v21 = if props.isFriendRequest then namespaces.FriendRequests else namespaces.PYMK
	end

	v19.namespace = v21

	v19.friendStatus = friendStatus
	v19.presence = (presence or {}).userPresenceType
	local v22 = module13(v19)

	module3.useEffect(function()
		local v23 = module8.Stopwatch.stop(module8.Events.AFPUserTileLoadFromHomeCarousel)

		if v23 then
			v22(eventNames.AFPUserTileLoadFromHomeCarousel, {
				loadingTime = v23.timeElapsed,
				statValue = v23.timeElapsed
			})
		end
	end, {})

	local v23 = module3.useCallback(function(data)
		if not data then
			return
		end

		v7(module2.Actions.SetCurrentToastMessage({
			toastMessage = data.toastTitle,
			toastIcon = data.iconImage,
			isLocalized = data.isLocalized
		}))
	end, { v7 })

	local v24 = module3.useCallback(function(object, p2)
		return object:andThen(function()
			v23(p2)
		end):catch(function()
			v23({ toastTitle = "Feature.Toast.NetworkingError.SomethingIsWrong" })
		end)
	end, { v23 })

	local v25 = module3.useCallback(function(callback)
		v22(eventNames.AcceptFriendshipBtnClick)
		return v5.AcceptFriendRequest(props.user.id):andThen(function()
			if callback then
				callback()
			end

			if props.contextInfo and props.contextInfo.type == contextInfoType.FromCI then
				return (getUserTrustedConnectionStatus(props.user.id))
			end

			return (module21.resolve(nil))
		end):andThen(function(p2)
			if p2 == trustedConnectionStatus.TrustedFriends then
				v23({
					toastTitle = v16.nowTrusted,
					iconImage = images["icons/actions/friends/friendAdd"],
					isLocalized = true
				})
			else
				v23({
					toastTitle = "Feature.Friends.Action.FriendAdded",
					iconImage = images["icons/actions/friends/friendAdd"]
				})
			end
		end):catch(function()
			v23({ toastTitle = "Feature.Toast.NetworkingError.SomethingIsWrong" })
		end)
	end, { props.user.id, v13, v7, v24, v23, v22, v16.nowTrusted })

	local v26 = module3.useCallback(function(callback)
		v22(eventNames.DeclineFriendshipBtnClick)

		return v24(v5.DeclineFriendRequest(props.user.id):andThen(function(p2)
			if callback then
				callback()
			end

			return p2
		end), {
			toastTitle = "Feature.AddFriends.Action.RequestIgnored",
			iconImage = images["icons/actions/reject"]
		})
	end, { props.user.id, v13, v7, v24, v22 })

	local v27 = module3.useCallback(function()
		v22(eventNames.RequestFriendshipBtnClick)

		local requestFriendship = v5.RequestFriendship
		local id = props.user.id
		local friendRecommendations

		if props.isRecommendation then
			friendRecommendations = enums.FriendshipOriginSourceType.FriendRecommendations
		end

		local v29 = if fFlagEnableFriendsStoreChallengeInterceptor then module20 else nil
		return v24(requestFriendship(id, friendRecommendations, {
			isContact = isContact
		}, v29), {
			toastTitle = "Feature.Friends.Action.FriendRequestSent",
			iconImage = images["icons/actions/friends/friendAdd"]
		})
	end, { isContact, props.isRecommendation, props.user.id, v13, v7, v24, v22 })

	local v28 = useNavigation()
	local v29

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v29 = module3.useCallback(function()
			v28.push(appPage.TrustedContactsModal, {
				props = { userId = props.user.id, source = sources.AddFriendsPage }
			})
		end, { v28, props.user.id })
	end

	local v30

	if fFlagAddFriendsPageTrustedFriendRequestSection then
		v30 = module3.useCallback(function()
			return v24(v6.ignoreTrustedConnectionRequest(props.user.id), {
				toastTitle = "Feature.AddFriends.Action.RequestIgnored",
				iconImage = images["icons/actions/reject"]
			})
		end, { props.user.id, v24 })
	end

	local v31 = module3.useCallback(function()
		v22(eventNames.PlayerTileClick)

		local v32 = if fFlagEnableSplitPane then v28.push else v28.navigate
		local profilePlatform = appPage.ProfilePlatform
		local v33 = { detail = props.user.id, extraProps = 0 }
		local v34 = {
			profileType = isContact and "Contact" or nil,
			recommendationSessionId = module15.getPymkSessionId(),
			absolutePosition = props.position,
			rank = rank,
			isRecommendation = props.isRecommendation,
			isContact = isContact,
			contactProps = isContact and {
				contactId = props.user.entityId,
				contactname = props.user.entityDisplayName,
				avatarImageUrl = props.user.thumbnailEntities and props.user.thumbnailEntities.avatarImageUrl
			} or nil,
			friendStatus = friendStatus,
			source = 0,
			contextualInfoType = 0,
			contextualInfoDisplay = 0
		}

		local v35 = if props.isRecommendation then module12.AddFriendsPYMKSourceName else contexts.AddFriends
		v34.source = v35
		v34.contextualInfoType = kind
		local v36 = if props.isRecommendation then v17 else nil
		v34.contextualInfoDisplay = v36
		v33.extraProps = v34
		v32(profilePlatform, v33)
	end, {
		props.user,
		props.position,
		props.isRecommendation,
		friendStatus,
		isContact,
		v28,
		kind,
		v17,
		rank
	})

	local v32 = module3.useCallback(function()
		v31()
	end, { v31 })
	local v33, v34, v35

	if fFlagAddFriendsUserListEnabled then
		v35 = nil
	else
		local v36 = module10.Hooks.useUserProfilesFetch({
			userIds = { props.user.id },
			query = module10.Queries.userProfilesCombinedNameAndUsernameByUserIds,
			skip = isContact
		})

		if isContact then
			v35 = props.user.entityDisplayName

			v33 = props.user.thumbnailEntities and props.user.thumbnailEntities.avatarImageUrl
		else
			local v37

			if v36 and v36.data then
				v35 = module10.Selectors.getCombinedNameFromId(v36.data, props.user.id) or ""
				v37 = module10.Selectors.getUsernameFromId(v36.data, props.user.id) or ""
			else
				v35 = ""
				v37 = ""
			end

			v34 = "@" .. v37
			v33 = string.format("rbxthumb://type=Avatar&id=%s&w=720&h=720", (tostring(props.user.id)))
		end
	end

	local v36 = nil
	local v37 = nil

	if fFlagAddFriendsUserListEnabled then
		v37 = module3.useMemo(function()
			return presence and presence.userPresenceType or presenceType.Offline
		end, { presence })
	else
		local v38 = module3.useMemo(function(): boolean
			local userPresenceType = presence and presence.userPresenceType or nil
			return userPresenceType == presenceType.Online
				or userPresenceType == presenceType.InStudio
				or userPresenceType == presenceType.InGame
		end, { presence })

		local color = v10.Theme.OnlineStatus.Color

		v36 = module3.useMemo(function()
			local formatted = `<font color="rgb({math.round(color.R * 255)},{math.round(color.G * 255)},{math.round(color.B * 255)})">● </font>`

			if v38 then
				return formatted .. v35
			end

			return v35
		end, { v35, v38, color })
	end

	local v39 = {
		ctaActions = props.ctaActions,
		handleRequestFriendship = v27,
		handleAcceptFriendRequest = v25,
		handleDeclineFriendRequest = v26,
		handleAcceptTrustedFriendRequest = 0,
		handleIgnoreTrustedFriendRequest = 0,
		handleViewProfile = 0,
		shouldAddFocusEventName = 0
	}

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		v29 = nil
	end

	v39.handleAcceptTrustedFriendRequest = v29

	if not fFlagAddFriendsPageTrustedFriendRequestSection then
		v30 = nil
	end

	v39.handleIgnoreTrustedFriendRequest = v30

	v39.handleViewProfile = v31
	v39.shouldAddFocusEventName = v11
	local v40 = module17(v39)

	if fFlagAddFriendsUserListEnabled then
		local v41 = if v40 then v40[#v40] or nil else nil
		local v42 = if v40 then v40[#v40 - 1] or nil else nil

		local createElement = module3.createElement

		local v45 = {
			UserRow = props.createRow({
				onRowActivated = v32,
				primaryCta = v41 and {
					type = v41.type,
					icon = v41.icon,
					variant = v41.variant,
					isDisabled = v41.isDisabled,
					onActivated = v41.onActivated,
					minWidth = module12.PRIMARY_CTA_BUTTON_MIN_WIDTH,
					maxWidth = module12.PRIMARY_CTA_BUTTON_MAX_WIDTH
				},
				secondaryCta = v42 and {
					type = v42.type,
					icon = v42.icon,
					isDisabled = v42.isDisabled,
					onActivated = v42.onActivated
				},
				contextualInfo = v17 and { text = v17.text, icon = v17.icon },
				loadingState = props.contextInfo and props.contextInfo.type == contextInfoType.Loading and {
					contextualInfo = true
				} or nil,
				presence = v37,
				shouldShowNewIndicator = props.isUnseen
			}),
			UserTileEventHandlers = 0
		}

		local v46 = if v11 then module3.createElement(userTileEventHandlers, {
			buttons = v40,
			onTileActivated = v32,
			tileRef = ref
		}) else nil
		v45.UserTileEventHandlers = v46
		return createElement(view, { tag = "size-full-0 auto-y", ref = ref }, v45)
	else
		local createElement = module3.createElement
		local v42 = {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.new(0, props.size.X, 0, props.size.Y),
			BackgroundTransparency = 1,
			ZIndex = 1,
			LayoutOrder = props.layoutOrder
		}

		local createElement2 = module3.createElement
		local v45 = {
			buttonRef = ref,
			thumbnail = v33,
			title = v36,
			tileSize = UDim2.new(0, props.size.X, 0, props.size.Y),
			subtitle = v34,
			buttons = if not v11 then v40 else nil,
			relevancyInfo = v17,
			onActivated = v32,
			Selectable = true,
			openTypeFeatures = 0
		}

		local v47 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
		v45.openTypeFeatures = v47
		local v43 = {
			PlayerTile = createElement2(playerTile, v45),
			UserTileEventHandlers = 0
		}

		local v48 = if v11 then module3.createElement(userTileEventHandlers, {
			buttons = v40,
			onTileActivated = v32,
			tileRef = ref
		}) else nil
		v43.UserTileEventHandlers = v48
		return createElement("Frame", v42, v43)
	end
end

return AddFriendsTile
