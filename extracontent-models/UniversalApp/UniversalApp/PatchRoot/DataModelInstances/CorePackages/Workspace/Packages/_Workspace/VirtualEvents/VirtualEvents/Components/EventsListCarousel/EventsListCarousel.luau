local HttpService = game:GetService("HttpService")
local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local React = require(VirtualEvents.Parent.React)
local Responsive = require(VirtualEvents.Parent.Responsive)
local CollectionViews = require(VirtualEvents.Parent.CollectionViews)
local sortEventsByStartDate = require(VirtualEvents.Common.sortEventsByStartDate)
local useGetGameTileHeight = require(VirtualEvents.Parent.GameCollections).useGetGameTileHeight
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local Style = require(VirtualEvents.Parent.Style)
local useTextSizeOffset = require(VirtualEvents.Parent.UIBlox).Core.Style.useTextSizeOffset
local useDesignTokens = Style.useDesignTokens
local FrameBoundsImpressionsTracker = require(VirtualEvents.Parent.Impressions).FrameBoundsImpressionsTracker
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local flaggedMutedError = require(VirtualEvents.Parent.Loggers).flaggedMutedError
local DiscoveryEventErrorLogger = require(VirtualEvents.Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local EventTile = require(script.Parent.EventTile)
local useCallback = React.useCallback
local useEffect = React.useEffect
local FFlagLuaAppEventsListImpressionToEventError = require(VirtualEvents.Parent.SharedFlags).FFlagLuaAppEventsListImpressionToEventError
local FFlagLuaAppSduiEventDetailsEnabled = require(VirtualEvents.Parent.SharedFlags).FFlagLuaAppSduiEventDetailsEnabled

return function(t1: {[any]: any}) -- line: 52
	-- upvalues: useTextSizeOffset (copy), useDesignTokens (copy), Responsive (copy), React (copy), HttpService (copy), useCallback (copy), EventTile (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), useGetGameTileHeight (copy), useLocalization (copy), sortEventsByStartDate (copy), FFlagLuaAppEventsListImpressionToEventError (copy), DiscoveryEventErrorLogger (copy), flaggedMutedError (copy), useCollectionImpressionsSignal (copy), useEffect (copy), CollectionCarousel (copy), FrameBoundsImpressionsTracker (copy)
	local v23 = useTextSizeOffset()
	local v24 = useDesignTokens()
	local v25 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v26 = React.useMemo(function() -- line: 57
		-- upvalues: t1 (copy), HttpService (copy)
		return `EventsListCarousel_{ t1.universeId }{ HttpService:GenerateGUID() }`
	end, { t1.universeId })
	local v27 = useCallback(function(p1, n1: number, uDim2: UDim2, _: number?) -- line: 62
		-- upvalues: React (copy), EventTile (copy), t1 (copy), v26 (copy), v25 (copy), FFlagLuaAppSduiEventDetailsEnabled (copy)
		return React.createElement(EventTile, {
			Event = p1,
			DefaultThumbnail = t1.defaultThumbnail,
			onJoinEvent = t1.onJoinEvent,
			onRsvpChanged = t1.onRsvpChanged,
			onTileActivated = t1.onTileActivated,
			impressionsTag = v26,
			layoutOrder = n1,
			size = uDim2,
			disableButtons = v25,
			suppressRsvpReminderToastBecauseEventDetailsFocused = if not FFlagLuaAppSduiEventDetailsEnabled then nil else t1.suppressRsvpReminderToastBecauseEventDetailsFocused
		}), p1.id
	end, {
		t1.defaultThumbnail,
		t1.onJoinEvent,
		t1.onRsvpChanged,
		t1.onTileActivated,
		if not FFlagLuaAppSduiEventDetailsEnabled then nil else t1.suppressRsvpReminderToastBecauseEventDetailsFocused,
		v26,
		v25
	})
	local v28 = useGetGameTileHeight(false, "Event", true, false, false, v23, v25 and 0 or v24.Size.Size_700 + v24.Size.Size_200)
	local v29 = useLocalization({
		title = "Feature.VirtualEvents.EventsListTitle"
	})
	local v30 = sortEventsByStartDate(t1.virtualEvents)
	local v31 = React.useRef({})
	local v32 = useCallback(function(p2) -- line: 109
		-- upvalues: v30 (copy), v31 (copy), t1 (copy), FFlagLuaAppEventsListImpressionToEventError (copy), DiscoveryEventErrorLogger (copy), flaggedMutedError (copy)
		for _, v44 in p2 do
			local v45 = v30[v44]

			if v45 ~= nil then
				if not v31.current[v45.id] then
					v31.current[v45.id] = true
					t1.onEventImpression(v45)
				end
			elseif FFlagLuaAppEventsListImpressionToEventError then
				DiscoveryEventErrorLogger.reportError("EventsListCarouselNilViewedEvent", `Viewed event at index { v44 } was nil when sending Event Tile impressions with referral source { t1.referralSource }`, {
					index = v44,
					referralSource = t1.referralSource
				})
			else
				flaggedMutedError("EventsListCarouselNilViewedEvent", `Viewed event at index ${ v44 } was nil when sending Event Tile impressions with referral source ${ t1.referralSource }`)
			end
		end
	end, {
		t1.onEventImpression,
		v30,
		t1.referralSource
	})
	local v33 = React.useRef(nil)
	local v34, v35 = useCollectionImpressionsSignal()
	local v36, v37 = React.useState(os.clock())

	useEffect(function() -- line: 147
		-- upvalues: v37 (copy)
		v37(os.clock())
	end, { t1.virtualEvents })

	if #t1.virtualEvents == 0 then
		return nil
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ClipsDescendants = not t1.peekViewFormat,
		LayoutOrder = t1.layoutOrder
	}, {
		EventsCarousel = React.createElement(CollectionCarousel, {
			hideHeaderButton = true,
			fractionalItemAmount = 0.33,
			sideMargin = 0,
			scrollingFrameRef = v33,
			title = v29.title,
			items = v30,
			renderItem = v27,
			getItemHeight = v28,
			onViewableItemsChanged = v35,
			onChangeCanvasPosition = v35,
			numColumns = not t1.peekViewFormat and 2 or 1,
			columnGap = v24.Size.Size_300
		}),
		FrameBoundsImpressionsTracker = React.createElement(FrameBoundsImpressionsTracker, {
			pageContext = t1.referralSource,
			parentRef = v33,
			impressionsTag = v26,
			scrollViewPositionChangedSignal = v34,
			sendImpressions = v32,
			dataUpdatedTimestamp = v36
		})
	})
end
