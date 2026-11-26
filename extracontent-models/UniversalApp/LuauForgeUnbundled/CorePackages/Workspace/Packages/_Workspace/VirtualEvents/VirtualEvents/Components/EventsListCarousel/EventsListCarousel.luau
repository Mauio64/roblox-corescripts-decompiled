local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Responsive")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/CollectionViews")
local sortEventsByStartDate = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/sortEventsByStartDate")
local useGetGameTileHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GameCollections").useGetGameTileHeight
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Style")
local useTextSizeOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox").Core.Style.useTextSizeOffset
local useDesignTokens = Style.useDesignTokens

local frameBoundsImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Impressions").FrameBoundsImpressionsTracker

local collectionCarousel = CollectionViews.CollectionCarousel
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/DiscoveryUtils").DiscoveryEventErrorLogger

local EventTile = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventsListCarousel/EventTile")

local useCallback = React.useCallback
local useEffect = React.useEffect

local fFlagLuaAppSduiEventDetailsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppSduiEventDetailsEnabled

local fFlagLuaAppGameViewTileBackgroundColorOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppGameViewTileBackgroundColorOverride

return function(props)
	local v5 = useTextSizeOffset()
	local v6 = useDesignTokens()
	local v7 = Responsive.usePreferredInput() == Responsive.Input.Directional

	local v8 = React.useMemo(function()
		return `EventsListCarousel_{props.universeId}{HttpService:GenerateGUID()}`
	end, { props.universeId })
	local surface_200

	if fFlagLuaAppGameViewTileBackgroundColorOverride and props.peekViewFormat then
		surface_200 = v6.Color.Surface.Surface_200
	else
		surface_200 = nil
	end

	local function fn(p2, p3, p4, p5)
		local createElement = React.createElement
		local v11 = {
			Event = p2,
			DefaultThumbnail = props.defaultThumbnail,
			backgroundStyle = surface_200,
			onJoinEvent = props.onJoinEvent,
			onRsvpChanged = props.onRsvpChanged,
			onTileActivated = props.onTileActivated,
			impressionsTag = v8,
			layoutOrder = p3,
			size = p4,
			disableButtons = v7,
			suppressRsvpReminderToastBecauseEventDetailsFocused = 0
		}

		local v12 = if fFlagLuaAppSduiEventDetailsEnabled then props.suppressRsvpReminderToastBecauseEventDetailsFocused else nil
		v11.suppressRsvpReminderToastBecauseEventDetailsFocused = v12
		return createElement(EventTile, v11), p2.id
	end

	local defaultThumbnail = props.defaultThumbnail
	local onJoinEvent = props.onJoinEvent
	local onRsvpChanged = props.onRsvpChanged
	local onTileActivated = props.onTileActivated
	local suppressRsvpReminderToastBecauseEventDetailsFocused

	if fFlagLuaAppSduiEventDetailsEnabled then
		suppressRsvpReminderToastBecauseEventDetailsFocused = props.suppressRsvpReminderToastBecauseEventDetailsFocused
	end

	local v12 = useCallback(fn, {
		defaultThumbnail,
		onJoinEvent,
		onRsvpChanged,
		onTileActivated,
		suppressRsvpReminderToastBecauseEventDetailsFocused,
		v8,
		v7,
		if fFlagLuaAppGameViewTileBackgroundColorOverride then surface_200 else nil
	})

	local v13 = useGetGameTileHeight(
		false,
		"Event",
		true,
		false,
		false,
		v5,
		v7 and 0 or v6.Size.Size_700 + v6.Size.Size_200
	)

	local v14 = useLocalization({ title = "Feature.VirtualEvents.EventsListTitle" })

	local v15 = sortEventsByStartDate(props.virtualEvents)
	local ref = React.useRef({})
	local v16 = useCallback(function(items)
		for k, item in items do
			local v17 = v15[item]

			if v17 == nil then
				discoveryEventErrorLogger.reportError(
					"EventsListCarouselNilViewedEvent",
					`Viewed event at index {item} was nil when sending Event Tile impressions with referral source {props.referralSource}`,
					{ index = item, referralSource = props.referralSource }
				)
			elseif not ref.current[v17.id] then
				ref.current[v17.id] = true
				props.onEventImpression(v17)
			end
		end
	end, { props.onEventImpression, v15, props.referralSource })

	local ref2 = React.useRef(nil)
	local v17, v18 = useCollectionImpressionsSignal()
	local state, setState = React.useState(os.clock())
	useEffect(function()
		setState(os.clock())
	end, { props.virtualEvents })

	if #props.virtualEvents == 0 then
		return nil
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants = not props.peekViewFormat,
		LayoutOrder = props.layoutOrder
	}, {
		EventsCarousel = React.createElement(collectionCarousel, {
			scrollingFrameRef = ref2,
			title = v14.title,
			hideHeaderButton = true,
			items = v15,
			renderItem = v12,
			getItemHeight = v13,
			onViewableItemsChanged = v18,
			onChangeCanvasPosition = v18,
			numColumns = props.peekViewFormat and 1 or 2,
			columnGap = v6.Size.Size_300,
			fractionalItemAmount = 0.33,
			sideMargin = 0
		}),
		FrameBoundsImpressionsTracker = React.createElement(frameBoundsImpressionsTracker, {
			pageContext = props.referralSource,
			parentRef = ref2,
			impressionsTag = v8,
			scrollViewPositionChangedSignal = v17,
			sendImpressions = v16,
			dataUpdatedTimestamp = state
		})
	})
end
