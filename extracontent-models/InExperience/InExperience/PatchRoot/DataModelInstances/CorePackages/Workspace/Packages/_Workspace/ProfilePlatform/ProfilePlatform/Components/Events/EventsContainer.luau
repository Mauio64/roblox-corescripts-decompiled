local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local VirtualEvents = require(parent.VirtualEvents)
local EventsListCarousel = VirtualEvents.EventsListCarousel
local Enums = require(ProfilePlatform.Common.Enums)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Cryo = require(parent.Cryo)
require(parent.Signals)

local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)

local GameLaunch = require(ProfilePlatform.Parent.GameLaunch)
local LaunchGame = GameLaunch.LaunchGame
local Navigation = require(ProfilePlatform.Parent.Navigation)
local useNavigation = Navigation.useNavigation

require(ProfilePlatform.Parent.GraphQLServer)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppGame = RoactServiceTags.AppGame

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local createGroupEventsStore = require(ProfilePlatform.Stores.createGroupEventsStore)

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled
local VirtualEvents2 = require(parent.VirtualEvents)
local navigateToEventDetails = VirtualEvents2.navigateToEventDetails

local ApolloClient = require(parent.ApolloClient)
local useApolloClient = ApolloClient.useApolloClient
local RoactNavigation = require(parent.RoactNavigation)

local EventsSkeleton = require(ProfilePlatform.Components.Events.EventsSkeleton)

local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)

local function EventsContainer(p)
	local v = useProfileJsonComponent(Enums.Components.Events)
	local profileId = tonumber(useProfileWrapperContext().profileId)

	local v2 = useRoactService(AppGame)
	local v3 = useNavigation()
	local v4 = useApolloClient()
	local v5 = useProfileAnalyticsContext()

	local v6 = React.useMemo(function()
		return createGroupEventsStore(profileId)
	end, { profileId })

	local v7 = useSignalState(v6.getEvents)

	local virtualEvents = React.useMemo(function()
		local result = {}

		if v7 == nil then
			return result
		end

		local v8 = {}

		for _, v9 in ipairs(v7) do
			v8[v9.id] = v9
		end

		for _, v9 in ipairs(not v and {} or v.events) do
			local v10 = v8[v9.id]

			if v10 ~= nil then
				table.insert(result, v10)
			end
		end

		return result
	end, { v7, v })

	local universeId = #virtualEvents > 0 and tonumber(virtualEvents[1].universeId) or 0

	local onRsvpChanged = React.useCallback(function(p2, status)
		v5.fireAnalyticsEvent(EventNames.EventRSVP, { virtualEventId = p2.id, status = status })

		VirtualEvents.fireVirtualEventRSVP({
			virtualEventId = p2.id,
			universeId = tostring(p2.universeId),
			channel = "communityPeekView",
			status = status
		})

		v6.updateRsvpStatus(p2, status)

		v4.cache:modify({
			id = "VirtualEvent:" .. p2.id,
			fields = {
				userRsvpStatus = function(_, _, _)
					return status
				end,
				rsvpCounters = function(_, p3, _)
					local v8 = status == "going" and 1 or -1
					return Cryo.Dictionary.join(p3, {
						going = p3.going + v8
					})
				end
			}
		})
	end, { v6 })

	local onTileActivated = React.useCallback(function(p2)
		v5.fireAnalyticsEvent(EventNames.EventOpened, { virtualEventId = p2.id })

		if FFlagLuaAppSduiEventDetailsEnabled then
			navigateToEventDetails(v3, p2.id, (tostring(p2.universeId)))
		else
			v3.navigate(AppPage.EventDetails, {
				extraProps = { currentTime = DateTime.now(), virtualEventId = p2.id }
			})
		end
	end, { v3 })

	local onJoinEvent = React.useCallback(function(data)
		v5.fireAnalyticsEvent(EventNames.EventJoined, { virtualEventId = data.id })

		VirtualEvents.fireVirtualEventJoined({
			virtualEventId = data.id,
			universeId = tostring(data.universeId),
			channel = "communityPeekView"
		})

		LaunchGame(data.placeId, nil, { eventId = data.id }, v2)
	end, {})

	local onEventImpression = React.useCallback(function(p2)
		VirtualEvents.fireVirtualEventImpression({
			virtualEventId = p2.id,
			universeId = p2.universeId,
			channel = "communityPeekView"
		})
	end, {})
	local v8

	if FFlagEnableCommunityProfileLoadingSkeletons then
		v8 = useSignalState(v6.isLoading)
	else
		v8 = false
	end

	local createElement = React.createElement
	local v9 = {
		size = UDim2.new(1, 0, 0, 0),
		backgroundTransparency = 1,
		layoutOrder = p.layoutOrder,
		useAutomaticSizing = true
	}

	local v10 = {
		NavEvents = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = function()
				v6.refetch()
			end
		}),
		EventsCarousel = 0
	}
	local eventsCarousel

	if FFlagEnableCommunityProfileLoadingSkeletons and v8 then
		eventsCarousel = React.createElement(EventsSkeleton, {
			numSkeletons = #v.events
		})
	else
		eventsCarousel = React.createElement(EventsListCarousel, {
			virtualEvents = virtualEvents,
			onTileActivated = onTileActivated,
			onRsvpChanged = onRsvpChanged,
			onJoinEvent = onJoinEvent,
			onEventImpression = onEventImpression,
			peekViewFormat = true,
			referralSource = "communityPeekView",
			universeId = universeId
		})
	end

	v10.EventsCarousel = eventsCarousel
	return createElement(HorizontalPageMargin, v9, v10)
end

return EventsContainer
