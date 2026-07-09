local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local ScreenSizeImpressionsDetector = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsDetector
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local LayoutConfig = require(CorePackages.Workspace.Packages.RobloxAppEnums).LayoutConfig
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useResponsiveLayout = UIBlox.Core.Layout.Responsive.useResponsiveLayout
local CarouselGenericSquareTile = require(CorePackages.Workspace.Packages.SocialCommon).Components.CarouselGenericSquareTile
local useRouteName = require(CorePackages.Workspace.Packages.Navigation).useRouteName
local TopicContentsReducer = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsReducer
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local OmniFeedProps = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedProps
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CarouselWidget = require(Modules.LuaApp.Components.Generic.CarouselWidget)
local JoinYourFriendsTile = require(Modules.Personalization.OmniFeed.JoinYourFriendsTile)
local Constants = require(Modules.LuaApp.Constants)
local useNavigateFromAddFriends = require(Modules.LuaApp.Components.FriendsCarousel.utils.useNavigateFromAddFriends)
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING
local GAME_CAROUSEL_CHILD_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_CHILD_PADDING

local function onImpressionsDetected(p1, p2, p3, p4) -- line: 53
	-- upvalues: JoinYourFriendsTile (copy), Constants (copy)
	if not p1 or #p1 == 0 then
		return
	end

	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}

	for i = 1, #p1 do
		local v46 = p1[i]
		local v47 = p3[v46]

		if v47 then
			if v47.type == JoinYourFriendsTile then
				table.insert(t1, v47.props.friendUserId)
				table.insert(t2, v47.props.universeId)
				table.insert(t3, v47.props.rootPlaceId)
				table.insert(t4, v46)
			else
				table.insert(t2, "Other")
				table.insert(t4, v46)
			end
		end
	end

	p2:sendEventDeferred(p4, Constants.ImpressionsEvents.JoinYourFriends, {
		coplayIds = table.concat(t1, ","),
		contentIds = table.concat(t2, ","),
		rootPlaceIds = table.concat(t3, ","),
		positions = table.concat(t4, ",")
	})
end
local function reportFindFriends(p5, p6) -- line: 89
	p6:sendEventDeferred(p5, "joinYourFriendProfileViewOpen", {
		friendId = "FIND_FRIENDS"
	})
end
local function createFindFriendsTile(p7, p8, p9, p10, p11) -- line: 98
	-- upvalues: React (copy), CarouselGenericSquareTile (copy), Images (copy)
	return React.createElement(CarouselGenericSquareTile, {
		borderThickness = 1,
		impressionsTag = "JYF_TILE_IMPRESSION",
		LayoutOrder = p7,
		tileSize = p8.Y,
		icon = Images["icons/graphic/findfriends_large"],
		labelText = p9,
		onActivated = p11,
		styleProps = {
			containFooterInTileSize = true,
			font = p10,
			textXAlignment = Enum.TextXAlignment.Left
		}
	})
end
local function getTilesForData(p12, p13, t5: {[any]: any}?) -- line: 115
	-- upvalues: React (copy), GAME_CAROUSEL_CHILD_PADDING (copy), createFindFriendsTile (copy), JoinYourFriendsTile (copy)
	local t6 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, GAME_CAROUSEL_CHILD_PADDING),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})
	}
	local n1 = 0

	if t5 then
		n1 += 1
		t6[n1] = createFindFriendsTile(n1, p13, t5.tileText, t5.textFont, t5.onActivated)
	end

	for i = 1, #p12 do
		local v61 = p12[i]

		for j = 1, #v61.coplayUsers do
			n1 += 1
			t6[n1] = React.createElement(JoinYourFriendsTile, {
				impressionsTag = "JYF_TILE_IMPRESSION",
				LayoutOrder = n1,
				size = p13,
				friendUserId = tostring(v61.coplayUsers[j].userId),
				thumbnailAssetId = tostring(v61.thumbnailAssetId),
				experienceName = v61.name,
				rootPlaceId = v61.rootPlaceId,
				universeId = v61.contentId
			})
		end
	end

	return {
		tiles = t6,
		tileCount = n1
	}
end
local function JoinYourFriendsFeedItem(t7: {[any]: any}) -- line: 160
	-- upvalues: useSelector (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), Constants (copy), LayoutConfig (copy), useResponsiveLayout (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), React (copy), Signal (copy), useRoactService (copy), AppEventIngestService (copy), OmniFeedProps (copy), useRouteName (copy), useLocalization (copy), GridMetrics (copy), TopicContentsReducer (copy), useStyle (copy), useAppPolicy (copy), useNavigateFromAddFriends (copy), OmniFeedConstants (copy), getTilesForData (copy), GAME_CAROUSEL_CHILD_PADDING (copy), CarouselWidget (copy), RetrievalStatus (copy), ScreenSizeImpressionsDetector (copy), onImpressionsDetected (copy)
	local v64, NarrowColumnCount

	if useSelector(function(p14) -- line: 161
		return p14.FormFactor
	end) == FormFactor.COMPACT then
		v64 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
		NarrowColumnCount = Constants.JoinYourFriendsTile.NarrowColumnCount
	else
		local GridTile = LayoutConfig.Kind.Experiences.GridTile
		local v67 = useResponsiveLayout("gutter", GridTile) or 0

		v64 = if v67 == 0 then GAME_CAROUSEL_SIDE_WIDE_PADDING else v67
		NarrowColumnCount = Constants.JoinYourFriendsTile.WideColumnCount
	end

	local v68 = React.useRef(Signal.new())
	local v69 = useRoactService(AppEventIngestService)
	local appPage = (t7[OmniFeedProps.key] or {}).appPage
	local v71 = React.useCallback(function(_) -- line: 183
		-- upvalues: v68 (copy)
		v68.current:fire()
	end)
	local v72 = useRouteName()
	local v73 = useLocalization({
		carouselTitle = "Feature.Home.Heading.JoinYourFriends",
		findFriendsTile = "Feature.Friends.Action.FindFriends"
	})
	local v74 = useSelector(function(p16) -- line: 193
		return p16.ScreenSize
	end).X - 2 * v64
	local itemWidth = GridMetrics.getMetricsForFixedColumns(v74, v64, NarrowColumnCount).itemWidth
	local v76 = itemWidth / 1.7777777777777777 + 50
	local vector2 = Vector2.new(itemWidth, v76)
	local topicId = t7.topicId
	local v79 = useSelector(function(p17) -- line: 206
		-- upvalues: topicId (copy), TopicContentsReducer (copy)
		if topicId then
			return p17.Personalization[TopicContentsReducer.key][topicId]
		end

		return nil
	end)
	local v80 = v79 and v79.entries or {}
	local v81 = useStyle()
	local v82 = useAppPolicy(function(p18) -- line: 217
		return p18.getContactImporterEnabled()
	end)
	local v83 = useNavigateFromAddFriends({
		policyIsEnabled = v82
	})
	local t8 = nil

	if t7.topicLayoutData and t7.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.JYFFindFriendsEnabled] then
		t8 = {
			tileText = v73.findFriendsTile,
			textFont = v81.Font.Header2,
			onActivated = function() -- line: 230
				-- upvalues: v72 (copy), v69 (copy), v83 (copy)
				local v94 = v72

				v69:sendEventDeferred(v94, "joinYourFriendProfileViewOpen", {
					friendId = "FIND_FRIENDS"
				})
				v83()
			end
		}
	end

	local t9 = {}
	local n2 = 0

	if v79 then
		local v87 = getTilesForData(v80, vector2, t8)

		t9 = v87.tiles
		n2 = v87.tileCount
	end

	local v88 = (n2 - 1) * (GAME_CAROUSEL_CHILD_PADDING + vector2.X) + (GAME_CAROUSEL_CHILD_PADDING + vector2.X / 2)

	React.useEffect(function() -- line: 248
		-- upvalues: v68 (copy)
		v68.current:fire()
	end, {})

	if n2 > 0 then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v64),
				PaddingBottom = UDim.new(1, 0)
			}),
			TileCarousel = React.createElement(CarouselWidget, {
				index = 1,
				showSeeAll = false,
				title = v73.carouselTitle,
				itemWidth = vector2.X,
				canvasWidth = v88,
				carouselHeight = vector2.Y,
				itemPadding = GAME_CAROUSEL_CHILD_PADDING,
				items = t9,
				itemCount = n2,
				fetchingStatus = RetrievalStatus.Done,
				onChangeCanvasPosition = v71
			}),
			JYFCarouselImpressionsDetector = React.createElement(ScreenSizeImpressionsDetector, {
				impressionsTag = "JYF_TILE_IMPRESSION",
				onRequestImpressionsSignal = v68.current,
				onImpressionsDetected = function(p19) -- line: 277
					-- upvalues: onImpressionsDetected (copy), v69 (copy), t9 (ref), appPage (copy)
					onImpressionsDetected(p19, v69, t9, appPage)
				end
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
end

return JoinYourFriendsFeedItem
