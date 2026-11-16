local HttpService = game:GetService("HttpService")
local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)
local React = require(VirtualEvents.Parent.React)
local Responsive = require(VirtualEvents.Parent.Responsive)
local CollectionViews = require(VirtualEvents.Parent.CollectionViews)
local sortEventsByStartDate = require(VirtualEvents.Common.sortEventsByStartDate)
local GameCollections = require(VirtualEvents.Parent.GameCollections)
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Style = require(VirtualEvents.Parent.Style)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useDesignTokens = Style.useDesignTokens

local Impressions = require(VirtualEvents.Parent.Impressions)
local FrameBoundsImpressionsTracker = Impressions.FrameBoundsImpressionsTracker

local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local DiscoveryUtils = require(VirtualEvents.Parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local EventTile = require(script.Parent.EventTile)

local useCallback = React.useCallback
local useEffect = React.useEffect

local SharedFlags = require(VirtualEvents.Parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled

local SharedFlags2 = require(VirtualEvents.Parent.SharedFlags)
local FFlagLuaAppGameViewTileBackgroundColorOverride = SharedFlags2.FFlagLuaAppGameViewTileBackgroundColorOverride

return function(props)
	local v = useTextSizeOffset()
	local v2 = useDesignTokens()
	local disableButtons = Responsive.usePreferredInput() == Responsive.Input.Directional

	local impressionsTag = React.useMemo(function()
		return `EventsListCarousel_{props.universeId}{HttpService:GenerateGUID()}`
	end, { props.universeId })
	local surface_200

	if FFlagLuaAppGameViewTileBackgroundColorOverride and props.peekViewFormat then
		surface_200 = v2.Color.Surface.Surface_200
	else
		surface_200 = nil
	end

	local function fn(event, layoutOrder: number, size: UDim2, _: number?)
		local createElement = React.createElement
		local v3 = {
			Event = event,
			DefaultThumbnail = props.defaultThumbnail,
			backgroundStyle = surface_200,
			onJoinEvent = props.onJoinEvent,
			onRsvpChanged = props.onRsvpChanged,
			onTileActivated = props.onTileActivated,
			impressionsTag = impressionsTag,
			layoutOrder = layoutOrder,
			size = size,
			disableButtons = disableButtons,
			suppressRsvpReminderToastBecauseEventDetailsFocused = 0
		}
		local suppressRsvpReminderToastBecauseEventDetailsFocused

		if FFlagLuaAppSduiEventDetailsEnabled then
			suppressRsvpReminderToastBecauseEventDetailsFocused = props.suppressRsvpReminderToastBecauseEventDetailsFocused
		end

		v3.suppressRsvpReminderToastBecauseEventDetailsFocused = suppressRsvpReminderToastBecauseEventDetailsFocused
		return createElement(EventTile, v3), event.id
	end

	local defaultThumbnail = props.defaultThumbnail
	local onJoinEvent = props.onJoinEvent
	local onRsvpChanged = props.onRsvpChanged
	local onTileActivated = props.onTileActivated
	local suppressRsvpReminderToastBecauseEventDetailsFocused

	if FFlagLuaAppSduiEventDetailsEnabled then
		suppressRsvpReminderToastBecauseEventDetailsFocused = props.suppressRsvpReminderToastBecauseEventDetailsFocused
	end

	local v3

	if FFlagLuaAppGameViewTileBackgroundColorOverride then
		v3 = surface_200
	end

	local renderItem = useCallback(fn, {
		defaultThumbnail,
		onJoinEvent,
		onRsvpChanged,
		onTileActivated,
		suppressRsvpReminderToastBecauseEventDetailsFocused,
		impressionsTag,
		disableButtons,
		v3
	})

	local getItemHeight = useGetGameTileHeight(
		false,
		"Event",
		true,
		false,
		false,
		v,
		disableButtons and 0 or v2.Size.Size_700 + v2.Size.Size_200
	)

	local v4 = useLocalization({ title = "Feature.VirtualEvents.EventsListTitle" })

	local items2 = sortEventsByStartDate(props.virtualEvents)
	local ref = React.useRef({})
	local sendImpressions = useCallback(function(items)
		for _, item in items do
			local v5 = items2[item]

			if v5 == nil then
				DiscoveryEventErrorLogger.reportError(
					"EventsListCarouselNilViewedEvent",
					`Viewed event at index {item} was nil when sending Event Tile impressions with referral source {props.referralSource}`,
					{ index = item, referralSource = props.referralSource }
				)
			elseif not ref.current[v5.id] then
				ref.current[v5.id] = true
				props.onEventImpression(v5)
			end
		end
	end, { props.onEventImpression, items2, props.referralSource })

	local ref2 = React.useRef(nil)
	local scrollViewPositionChangedSignal, v5 = useCollectionImpressionsSignal()
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
		EventsCarousel = React.createElement(CollectionCarousel, {
			scrollingFrameRef = ref2,
			title = v4.title,
			hideHeaderButton = true,
			items = items2,
			renderItem = renderItem,
			getItemHeight = getItemHeight,
			onViewableItemsChanged = v5,
			onChangeCanvasPosition = v5,
			numColumns = props.peekViewFormat and 1 or 2,
			columnGap = v2.Size.Size_300,
			fractionalItemAmount = 0.33,
			sideMargin = 0
		}),
		FrameBoundsImpressionsTracker = React.createElement(FrameBoundsImpressionsTracker, {
			pageContext = props.referralSource,
			parentRef = ref2,
			impressionsTag = impressionsTag,
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			sendImpressions = sendImpressions,
			dataUpdatedTimestamp = state
		})
	})
end
