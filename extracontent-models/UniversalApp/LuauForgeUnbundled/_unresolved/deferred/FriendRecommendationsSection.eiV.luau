local module = require("@luauforge/deferred/eeO")

local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization
local module2 = require("@luauforge/deferred/efi")
local module3 = require("@luauforge/deferred/efZ")
local appPage = require("@luauforge/deferred/eeR").AppPage

local module4 = require("@luauforge/deferred/egi")
local module5 = require("@luauforge/deferred/eiW")
local friendsRecommendationsStore = module5.FriendsRecommendationsStore
local dataSource = module5.Enums.DataSource
local dataStatus = require("@luauforge/deferred/efT").DataStatus

local screenSizeImpressionsTracker = require("@luauforge/deferred/eia").ScreenSizeImpressionsTracker

local module6 = require("@luauforge/deferred/egB")
local collectionGrid = module6.CollectionGrid
local useCollectionImpressionsSignal = module6.useCollectionImpressionsSignal

local module7 = require("@luauforge/deferred/egD")
local module8 = require("@luauforge/deferred/eiX")
local module9 = require("@luauforge/deferred/eiY")

local module10 = require("@luauforge/deferred/eiT")
require("@luauforge/deferred/eij")

local module11 = require("@luauforge/deferred/eeX")
local useFireUserTileImpressionEvent = module11.useFireUserTileImpressionEvent
local namespaces = module11.Namespaces
local module12 = require("@luauforge/deferred/efQ")

local module13 = require("@luauforge/deferred/egF")
local userListLayoutAdaptor = module13.UserListLayoutAdaptor
local contactsContext = module13.ContactsContext
local entityType = module13.Enums.EntityType
local layoutMode = module13.Enums.LayoutMode

local fFlagAddFriendsUserListEnabled = require("@luauforge/deferred/efc").FFlagAddFriendsUserListEnabled
local fFlagAddFriendsPymkSessionService = require("@luauforge/deferred/efc").FFlagAddFriendsPymkSessionService

local function FriendRecommendationsSection(p2)
	local sectionProps = p2.sectionProps
	local layoutOrder = sectionProps.LayoutOrder

	local v5 = module.useMemo(function()
		return friendsRecommendationsStore.get().getFriendsRecommendations(dataSource.AddFriendsPage, {
			forceFetch = true
		})
	end, {})
	local v6 = module4.useSignalState(v5.data)
	local v7 = module4.useSignalState(v5.status)

	local data = v6 and v6.data or {}

	local count = #data

	local recommendationRequestId = if fFlagAddFriendsPymkSessionService then v6 and v6.recommendationRequestId else nil

	if fFlagAddFriendsPymkSessionService then
		module.useEffect(function()
			if not recommendationRequestId then
				return
			end

			module12.setPymkSessionId(recommendationRequestId)
		end, { recommendationRequestId })
	end

	module9()

	module.useEffect(function()
		sectionProps.onLoadingChange(v7 == dataStatus.NotReady)
		sectionProps.onCountChange(count)
	end, { sectionProps, count, v7 })

	module.useEffect(function()
		if not sectionProps.refreshSignal then
			return
		end

		local refreshSignalConnection = sectionProps.refreshSignal:connect(function()
			friendsRecommendationsStore.get().refreshFriendsRecommendations(dataSource.AddFriendsPage)
		end)
		return function()
			refreshSignalConnection:disconnect()
		end
	end, { sectionProps })

	local v8 = useLocalization({ peopleYouMayKnow = "Feature.Friends.Label.PYMK" })

	local v9, v10 = module10()

	local v11 = module.useCallback(function(p3, p4)
		local v12 = tostring(p4) .. " "

		return module.createElement(module8, {
			entity = p3,
			createRow = nil,
			position = p4,
			layoutOrder = p4,
			size = Vector2.new(v10.itemWidth, v9.getItemHeight(v10.itemWidth)),
			impressionsTag = "ADDFRIENDSPAGE_RECOMMENDATIONS_TILE_IMPRESSIONS"
		}), v12
	end, { v10.itemWidth, v9.getItemHeight })
	local v12

	if fFlagAddFriendsUserListEnabled then
		v12 = module.useCallback(function(p3, p4, p5)
			return module.createElement(module8, {
				entity = p4,
				createRow = p3,
				position = p5,
				impressionsTag = "ADDFRIENDSPAGE_RECOMMENDATIONS_TILE_IMPRESSIONS"
			})
		end, {})
	end

	local v13 = module.useCallback(function()
		return module.createElement(module7, {
			layoutOrder = 1,
			title = v8.peopleYouMayKnow,
			iconVisible = false
		})
	end, { v8.peopleYouMayKnow })

	local ref = module.useRef(nil)
	local ref2 = module.useRef(module3.Signal.new())

	local v14 = useCollectionImpressionsSignal(ref2.current)
	local v15 = useFireUserTileImpressionEvent(
		data,
		fFlagAddFriendsUserListEnabled and 1 or v10.itemsPerRow,
		namespaces.PYMK
	)

	local v16 = module.useCallback(function()
		ref2.current:fire()
	end, { ref2 })
	local v17

	if fFlagAddFriendsUserListEnabled then
		v17 = module.useMemo(function()
			return {
				contacts = module2.List.foldLeft(data, function(p3, data2)
					if data2.type == entityType.Contact then
						local contactProps = data2.contactProps
						local thumbnailEntities = contactProps and contactProps.thumbnailEntities
						p3[data2.id] = {
							name = contactProps and contactProps.displayName or "",
							avatarThumbnailUrl = thumbnailEntities and thumbnailEntities.headshotImageUrl or ""
						}
					end

					return p3
				end, {})
			}
		end, { data })
	end

	if sectionProps.hide or count == 0 then
		return nil
	end

	local createElement = module.createElement
	local v19 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		ref = ref,
		[module.Change.AbsolutePosition] = v16
	}

	local v21 = if fFlagAddFriendsUserListEnabled then module.createElement(
		contactsContext.Provider,
		{ value = v17 },
		{
			UserListLayoutAdaptor = module.createElement(userListLayoutAdaptor, {
				layoutOrder = layoutOrder,
				layoutMode = layoutMode.Vertical,
				header = { title = v8.peopleYouMayKnow },
				entities = data,
				isScrollEnabled = false,
				renderRow = v12
			})
		}
	) else nil

	local v22 = if not fFlagAddFriendsUserListEnabled then module.createElement(
		collectionGrid,
		module2.Dictionary.join(v9, {
			items = data,
			renderItem = v11,
			title = v13,
			onViewableItemsChanged = nil
		})
	) else nil
	return createElement("Frame", v19, {
		UserListWithContacts = v21,
		FriendRecommendationsCollectionsGrid = v22,
		ScreenSizeImpressionsDetector = module.createElement(screenSizeImpressionsTracker, {
			parentRef = ref,
			pageContext = appPage.AddFriendsPage,
			impressionsTag = "ADDFRIENDSPAGE_RECOMMENDATIONS_TILE_IMPRESSIONS",
			sendImpressions = v15,
			scrollViewPositionChangedSignal = v14
		})
	})
end

return FriendRecommendationsSection
