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
local FFlagLuaAppGameViewTileBackgroundColorOverride = require(VirtualEvents.Parent.SharedFlags).FFlagLuaAppGameViewTileBackgroundColorOverride

return function(t1: {[any]: any}) -- line: 54
	-- upvalues: useTextSizeOffset (copy), useDesignTokens (copy), Responsive (copy), React (copy), HttpService (copy), FFlagLuaAppGameViewTileBackgroundColorOverride (copy), useCallback (copy), EventTile (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), useGetGameTileHeight (copy), useLocalization (copy), sortEventsByStartDate (copy), FFlagLuaAppEventsListImpressionToEventError (copy), DiscoveryEventErrorLogger (copy), flaggedMutedError (copy), useCollectionImpressionsSignal (copy), useEffect (copy), CollectionCarousel (copy), FrameBoundsImpressionsTracker (copy)
	local v24 = useTextSizeOffset()
	local v25 = useDesignTokens()
	local v26 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v27 = React.useMemo(function() -- line: 59
		-- upvalues: t1 (copy), HttpService (copy)
		return `EventsListCarousel_{ t1.universeId }{ HttpService:GenerateGUID() }`
	end, { t1.universeId })
	local v28 = if not FFlagLuaAppGameViewTileBackgroundColorOverride or not t1.peekViewFormat then nil else v25.Color.Surface.Surface_200
	local v29 = useCallback(function(p1, n1: number, uDim2: UDim2, _: number?) -- line: 71
		-- upvalues: React (copy), EventTile (copy), t1 (copy), v28 (copy), v27 (copy), v26 (copy), FFlagLuaAppSduiEventDetailsEnabled (copy)
		return React.createElement(EventTile, {
			Event = p1,
			DefaultThumbnail = t1.defaultThumbnail,
			backgroundStyle = v28,
			onJoinEvent = t1.onJoinEvent,
			onRsvpChanged = t1.onRsvpChanged,
			onTileActivated = t1.onTileActivated,
			impressionsTag = v27,
			layoutOrder = n1,
			size = uDim2,
			disableButtons = v26,
			suppressRsvpReminderToastBecauseEventDetailsFocused = if not FFlagLuaAppSduiEventDetailsEnabled then nil else t1.suppressRsvpReminderToastBecauseEventDetailsFocused
		}), p1.id
	end, {
		t1.defaultThumbnail,
		t1.onJoinEvent,
		t1.onRsvpChanged,
		t1.onTileActivated,
		if not FFlagLuaAppSduiEventDetailsEnabled then nil else t1.suppressRsvpReminderToastBecauseEventDetailsFocused,
		v27,
		v26,
		if not FFlagLuaAppGameViewTileBackgroundColorOverride then nil else v28
	})
	local v30 = useGetGameTileHeight(false, "Event", true, false, false, v24, v26 and 0 or v25.Size.Size_700 + v25.Size.Size_200)
	local v31 = useLocalization({
		title = "Feature.VirtualEvents.EventsListTitle"
	})
	local v32 = sortEventsByStartDate(t1.virtualEvents)
	local v33 = React.useRef({})
	local v34 = useCallback(function(p2) -- line: 120
		-- upvalues: v32 (copy), v33 (copy), t1 (copy), FFlagLuaAppEventsListImpressionToEventError (copy), DiscoveryEventErrorLogger (copy), flaggedMutedError (copy)
		for _, v46 in p2 do
			local v47 = v32[v46]

			if v47 ~= nil then
				if not v33.current[v47.id] then
					v33.current[v47.id] = true
					t1.onEventImpression(v47)
				end
			elseif FFlagLuaAppEventsListImpressionToEventError then
				DiscoveryEventErrorLogger.reportError("EventsListCarouselNilViewedEvent", `Viewed event at index { v46 } was nil when sending Event Tile impressions with referral source { t1.referralSource }`, {
					index = v46,
					referralSource = t1.referralSource
				})
			else
				flaggedMutedError("EventsListCarouselNilViewedEvent", `Viewed event at index ${ v46 } was nil when sending Event Tile impressions with referral source ${ t1.referralSource }`)
			end
		end
	end, {
		t1.onEventImpression,
		v32,
		t1.referralSource
	})
	local v35 = React.useRef(nil)
	local v36, v37 = useCollectionImpressionsSignal()
	local v38, v39 = React.useState(os.clock())

	useEffect(function() -- line: 158
		-- upvalues: v39 (copy)
		v39(os.clock())
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
			scrollingFrameRef = v35,
			title = v31.title,
			items = v32,
			renderItem = v29,
			getItemHeight = v30,
			onViewableItemsChanged = v37,
			onChangeCanvasPosition = v37,
			numColumns = not t1.peekViewFormat and 2 or 1,
			columnGap = v25.Size.Size_300
		}),
		FrameBoundsImpressionsTracker = React.createElement(FrameBoundsImpressionsTracker, {
			pageContext = t1.referralSource,
			parentRef = v35,
			impressionsTag = v27,
			scrollViewPositionChangedSignal = v36,
			sendImpressions = v34,
			dataUpdatedTimestamp = v38
		})
	})
end
