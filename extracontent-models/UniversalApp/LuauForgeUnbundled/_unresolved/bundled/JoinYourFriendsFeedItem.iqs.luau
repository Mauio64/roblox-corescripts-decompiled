local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local screenSizeImpressionsDetector = require("@luauforge/bundled/egA").ScreenSizeImpressionsDetector
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local layoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LayoutConfig
local UIBlox = require(CorePackages.Packages.UIBlox)
local gridMetrics = UIBlox.App.Grid.GridMetrics
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useResponsiveLayout = UIBlox.Core.Layout.Responsive.useResponsiveLayout

local carouselGenericSquareTile = require("@luauforge/bundled/eoT").Components.CarouselGenericSquareTile
local useRouteName = require("@game/CorePackages/Workspace/Packages/Navigation").useRouteName
local topicContentsReducer = require("@luauforge/bundled/dCO").TopicContentsReducer
local module = require("@luauforge/bundled/cBc")
local omniFeedConstants = module.OmniFeedConstants
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local omniFeedProps = require("@luauforge/bundled/dtb").Modules.Personalization.OmniFeed.OmniFeedProps

local module2 = require("@luauforge/bundled/iqt")
local module3 = require("@luauforge/bundled/iqv")
local module4 = require("@luauforge/bundled/dzD")
local module5 = require("@luauforge/bundled/iqx")

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = module.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING
local GAME_CAROUSEL_CHILD_PADDING = module.Constants.GAME_CAROUSEL_CHILD_PADDING

local function onImpressionsDetected(list, object, p2, appPage)
	if not list or #list == 0 then
		return
	end

	local friendUserIds = {}
	local v5 = {}
	local rootPlaceIds = {}
	local v6 = {}

	for i = 1, #list do
		local item = list[i]
		local v7 = p2[item]

		if not v7 then
			continue
		end

		if v7.type == module3 then
			table.insert(friendUserIds, v7.props.friendUserId)
			table.insert(v5, v7.props.universeId)
			table.insert(rootPlaceIds, v7.props.rootPlaceId)
		else
			table.insert(v5, "Other")
		end

		table.insert(v6, item)
	end

	object:sendEventDeferred(appPage, module4.ImpressionsEvents.JoinYourFriends, {
		coplayIds = table.concat(friendUserIds, ","),
		contentIds = table.concat(v5, ","),
		rootPlaceIds = table.concat(rootPlaceIds, ","),
		positions = table.concat(v6, ",")
	})
end

local function reportFindFriends(p2, object)
	object:sendEventDeferred(p2, "joinYourFriendProfileViewOpen", {
		friendId = "FIND_FRIENDS"
	})
end

local function createFindFriendsTile(count, p2, tileText, textFont, onActivated)
	return React.createElement(carouselGenericSquareTile, {
		LayoutOrder = count,
		borderThickness = 1,
		tileSize = p2.Y,
		icon = images["icons/graphic/findfriends_large"],
		labelText = tileText,
		onActivated = onActivated,
		impressionsTag = "JYF_TILE_IMPRESSION",
		styleProps = {
			font = textFont,
			textXAlignment = Enum.TextXAlignment.Left,
			containFooterInTileSize = true
		}
	})
end

local function getTilesForData(entries, vector2, props)
	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, GAME_CAROUSEL_CHILD_PADDING),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})
	}

	local count = 0

	if props then
		count += 1
		children[count] = createFindFriendsTile(
			count,
			vector2,
			props.tileText,
			props.textFont,
			props.onActivated
		)
	end

	for i = 1, #entries do
		local item = entries[i]

		for j = 1, #item.coplayUsers do
			count += 1
			children[count] = React.createElement(module3, {
				LayoutOrder = count,
				size = vector2,
				friendUserId = tostring(item.coplayUsers[j].userId),
				thumbnailAssetId = tostring(item.thumbnailAssetId),
				experienceName = item.name,
				rootPlaceId = item.rootPlaceId,
				universeId = item.contentId,
				impressionsTag = "JYF_TILE_IMPRESSION"
			})
		end
	end

	return { tiles = children, tileCount = count }
end

local function JoinYourFriendsFeedItem(p2)
	local v5, v6

	if useSelector(function(p3)
		return p3.FormFactor
	end) == formFactor.COMPACT then
		v5 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
		v6 = module4.JoinYourFriendsTile.NarrowColumnCount
	else
		v5 = useResponsiveLayout("gutter", layoutConfig.Kind.Experiences.GridTile) or 0

		if v5 == 0 then
			v5 = GAME_CAROUSEL_SIDE_WIDE_PADDING
		end

		v6 = module4.JoinYourFriendsTile.WideColumnCount
	end

	local ref = React.useRef(signal.new())

	local v7 = useRoactService(appEventIngestService)
	local appPage = (p2[omniFeedProps.key] or {}).appPage
	local v8 = React.useCallback(function(p3)
		ref.current:fire()
	end)

	local v9 = useRouteName()
	local v10 = useLocalization({
		carouselTitle = "Feature.Home.Heading.JoinYourFriends",
		findFriendsTile = "Feature.Friends.Action.FindFriends"
	})

	local v11 = useSelector(function(p3)
		return p3.ScreenSize
	end).X - 2 * v5
	local itemWidth = gridMetrics.getMetricsForFixedColumns(v11, v5, v6).itemWidth
	local v12 = itemWidth / (16 / 9) + 50

	local vector2 = Vector2.new(itemWidth, v12)

	local topicId = p2.topicId

	local v13 = useSelector(function(p3)
		if topicId then
			return p3.Personalization[topicContentsReducer.key][topicId]
		end

		return nil
	end)
	local entries = v13 and v13.entries or {}

	local v14 = useStyle()
	local v16 = module5({
		policyIsEnabled = useAppPolicy(function(p3)
			return p3.getContactImporterEnabled()
		end)
	})

	local v17 = p2.topicLayoutData
		and p2.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.JYFFindFriendsEnabled]
		and {
			tileText = v10.findFriendsTile,
			textFont = v14.Font.Header2,
			onActivated = function()
				v7:sendEventDeferred(v9, "joinYourFriendProfileViewOpen", {
					friendId = "FIND_FRIENDS"
				})

				v16()
			end
		}
		or nil
	local v18, v19

	if v13 then
		local tilesForData = getTilesForData(entries, vector2, v17)
		v18 = tilesForData.tiles
		v19 = tilesForData.tileCount
	else
		v19 = 0
		v18 = {}
	end

	local v20 = (v19 - 1) * (GAME_CAROUSEL_CHILD_PADDING + vector2.X) + (GAME_CAROUSEL_CHILD_PADDING + vector2.X / 2)

	React.useEffect(function()
		ref.current:fire()
	end, {})

	if v19 > 0 then
		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v5),
					PaddingBottom = UDim.new(1, 0)
				}),
				TileCarousel = React.createElement(module2, {
					title = v10.carouselTitle,
					index = 1,
					itemWidth = vector2.X,
					canvasWidth = v20,
					carouselHeight = vector2.Y,
					itemPadding = GAME_CAROUSEL_CHILD_PADDING,
					items = v18,
					itemCount = v19,
					fetchingStatus = retrievalStatus.Done,
					showSeeAll = false,
					onChangeCanvasPosition = v8
				}),
				JYFCarouselImpressionsDetector = React.createElement(screenSizeImpressionsDetector, {
					onRequestImpressionsSignal = ref.current,
					onImpressionsDetected = function(p3)
						onImpressionsDetected(p3, v7, v18, appPage)
					end,
					impressionsTag = "JYF_TILE_IMPRESSION"
				})
			}
		)
	end

	return React.createElement("Frame", {
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	})
end

return JoinYourFriendsFeedItem
