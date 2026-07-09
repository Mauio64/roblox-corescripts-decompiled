local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local Cryo = require(AddFriendsParent.Cryo)
local AppCommonLib = require(AddFriendsParent.AppCommonLib)
local AppPage = require(AddFriendsParent.RobloxAppEnums).AppPage
local ScreenSizeImpressionsTracker = require(AddFriendsParent.Impressions).ScreenSizeImpressionsTracker
local CollectionViews = require(AddFriendsParent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local ParentParent = script.Parent.Parent
local AddFriendsTile = require(ParentParent.AddFriendsTile)
local AddFriendsSectionHeaderFrame = require(ParentParent.AddFriendsSectionHeaderFrame)
local useUserTileCollectionGridItemMetricsProps = require(ParentParent.SectionsUtils.useUserTileCollectionGridItemMetricsProps)
local Analytics = require(AddFriends.Analytics)
local useFireUserTileImpressionEvent = Analytics.useFireUserTileImpressionEvent
local Namespaces = Analytics.Namespaces
local UserList = require(AddFriendsParent.UserList)
local UserListLayoutAdaptor = UserList.UserListLayoutAdaptor
local ContactsContext = UserList.ContactsContext
local EntityType = UserList.Enums.EntityType
local LayoutMode = UserList.Enums.LayoutMode
local FFlagAddFriendsRenderTileRefactor = require(AddFriendsParent.SharedFlags).FFlagAddFriendsRenderTileRefactor
local FFlagAddFriendsUserListEnabled = require(AddFriendsParent.SharedFlags).FFlagAddFriendsUserListEnabled

local function FriendRecommendationsSection(t1: {[any]: any}) -- line: 55
	-- upvalues: useLocalization (copy), useUserTileCollectionGridItemMetricsProps (copy), React (copy), FFlagAddFriendsRenderTileRefactor (copy), AddFriendsTile (copy), FFlagAddFriendsUserListEnabled (copy), AddFriendsSectionHeaderFrame (copy), AppCommonLib (copy), useCollectionImpressionsSignal (copy), useFireUserTileImpressionEvent (copy), Namespaces (copy), Cryo (copy), EntityType (copy), ContactsContext (copy), UserListLayoutAdaptor (copy), LayoutMode (copy), CollectionGrid (copy), ScreenSizeImpressionsTracker (copy), AppPage (copy)
	local renderAddFriendsTile = t1.renderAddFriendsTile
	local friendRecommendations = t1.friendRecommendations
	local v30 = useLocalization({
		peopleYouMayKnow = "Feature.Friends.Label.PYMK"
	})
	local v31, v32 = useUserTileCollectionGridItemMetricsProps()
	local v33 = React.useCallback(function(p1, p2) -- line: 65
		-- upvalues: FFlagAddFriendsRenderTileRefactor (copy), React (copy), AddFriendsTile (copy), v32 (copy), v31 (copy), renderAddFriendsTile (copy)
		if FFlagAddFriendsRenderTileRefactor then
			local v44 = tostring(p2) .. " "

			return React.createElement(AddFriendsTile, {
				impressionsTag = "ADDFRIENDSPAGE_RECOMMENDATIONS_TILE_IMPRESSIONS",
				isRecommendation = true,
				layoutOrder = p2,
				position = p2,
				user = p1,
				size = Vector2.new(v32.itemWidth, v31.getItemHeight(v32.itemWidth))
			}), v44
		end

		return renderAddFriendsTile(p1, v32.itemWidth, v31.getItemHeight(v32.itemWidth), p2, nil, "ADDFRIENDSPAGE_RECOMMENDATIONS_TILE_IMPRESSIONS"), tostring(p2) .. " "
	end, {
		v32.itemWidth,
		v31.getItemHeight,
		renderAddFriendsTile
	})
	local v34 = if not FFlagAddFriendsUserListEnabled then nil else React.useCallback(function(p3, p4, p5) -- line: 99
		-- upvalues: React (copy), AddFriendsTile (copy)
		return React.createElement(AddFriendsTile, {
			isRecommendation = true,
			impressionsTag = "ADDFRIENDSPAGE_RECOMMENDATIONS_TILE_IMPRESSIONS",
			user = p4,
			createRow = p3,
			position = p5
		})
	end, {})
	local v35 = React.useCallback(function() -- line: 111
		-- upvalues: React (copy), AddFriendsSectionHeaderFrame (copy), v30 (copy)
		return React.createElement(AddFriendsSectionHeaderFrame, {
			layoutOrder = 1,
			iconVisible = false,
			title = v30.peopleYouMayKnow
		})
	end, { v30.peopleYouMayKnow })
	local v36 = React.useRef(nil)
	local v37 = React.useRef(AppCommonLib.Signal.new())
	local v38 = useCollectionImpressionsSignal(v37.current)
	local v39 = useFireUserTileImpressionEvent(friendRecommendations, if not FFlagAddFriendsUserListEnabled then v32.itemsPerRow else 1, Namespaces.PYMK)
	local v40 = React.useCallback(function() -- line: 128
		-- upvalues: v37 (copy)
		v37.current:fire()
	end, { v37 })
	local v41 = if not FFlagAddFriendsUserListEnabled then nil else React.useMemo(function() -- line: 133
		-- upvalues: Cryo (copy), friendRecommendations (copy), EntityType (copy)
		return {
			contacts = Cryo.List.foldLeft(friendRecommendations, function(p6, p7) -- line: 134
				-- upvalues: EntityType (copy)
				if p7.type == EntityType.Contact then
					p6[p7.id] = {
						name = p7.entityDisplayName or "",
						avatarThumbnailUrl = p7.thumbnailEntities and p7.thumbnailEntities.headshotImageUrl or ""
					}
				end

				return p6
			end, {})
		}
	end, { friendRecommendations })

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		ref = v36,
		[React.Change.AbsolutePosition] = v40
	}, {
		UserListWithContacts = if not FFlagAddFriendsUserListEnabled then nil else React.createElement(ContactsContext.Provider, {
			value = v41
		}, {
			UserListLayoutAdaptor = React.createElement(UserListLayoutAdaptor, {
				isScrollEnabled = false,
				layoutOrder = t1.LayoutOrder,
				layoutMode = LayoutMode.Vertical,
				header = {
					title = v30.peopleYouMayKnow
				},
				entities = friendRecommendations,
				renderRow = v34
			})
		}),
		FriendRecommendationsCollectionsGrid = if not FFlagAddFriendsUserListEnabled then React.createElement(CollectionGrid, Cryo.Dictionary.join(v31, {
			onViewableItemsChanged = nil,
			items = friendRecommendations,
			renderItem = v33,
			title = v35
		})) else nil,
		ScreenSizeImpressionsDetector = React.createElement(ScreenSizeImpressionsTracker, {
			impressionsTag = "ADDFRIENDSPAGE_RECOMMENDATIONS_TILE_IMPRESSIONS",
			parentRef = v36,
			pageContext = AppPage.AddFriendsPage,
			sendImpressions = v39,
			scrollViewPositionChangedSignal = v38
		})
	})
end

return FriendRecommendationsSection
