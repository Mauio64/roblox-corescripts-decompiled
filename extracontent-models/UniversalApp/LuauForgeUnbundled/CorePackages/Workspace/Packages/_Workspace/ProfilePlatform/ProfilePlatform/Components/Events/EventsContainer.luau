local VirtualEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/VirtualEvents")
local eventsListCarousel = VirtualEvents.EventsListCarousel
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")

local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")

local launchGame = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameLaunch").LaunchGame
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GraphQLServer")

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService
local appGame = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").AppGame

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local horizontalPageMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Container.HorizontalPageMargin

local createGroupEventsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Stores/createGroupEventsStore")

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local fFlagLuaAppSduiEventDetailsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagLuaAppSduiEventDetailsEnabled
local navigateToEventDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/VirtualEvents").navigateToEventDetails

local useApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ApolloClient").useApolloClient
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactNavigation")

local EventsSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Events/EventsSkeleton")

local FFlagEnableCommunityProfileLoadingSkeletons = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableCommunityProfileLoadingSkeletons")

local function EventsContainer(p2)
	local v5 = useProfileJsonComponent(Enums.Components.Events)
	local profileId = tonumber(useProfileWrapperContext().profileId)

	local v6 = useRoactService(appGame)
	local v7 = useNavigation()
	local v8 = useApolloClient()
	local v9 = useProfileAnalyticsContext()

	local v10 = React.useMemo(function()
		return createGroupEventsStore(profileId)
	end, { profileId })

	local v11 = useSignalState(v10.getEvents)

	local v12 = React.useMemo(function()
		local result = {}

		if v11 == nil then
			return result
		end

		local v13 = {}

		for i, v14 in ipairs(v11) do
			v13[v14.id] = v14
		end

		for i, v14 in ipairs(not v5 and {} or v5.events) do
			local v15 = v13[v14.id]

			if v15 ~= nil then
				table.insert(result, v15)
			end
		end

		return result
	end, { v11, v5 })

	local universeId = #v12 > 0 and tonumber(v12[1].universeId) or 0

	local v13 = React.useCallback(function(p3, p4)
		v9.fireAnalyticsEvent(EventNames.EventRSVP, { virtualEventId = p3.id, status = p4 })

		VirtualEvents.fireVirtualEventRSVP({
			virtualEventId = p3.id,
			universeId = tostring(p3.universeId),
			channel = "communityPeekView",
			status = p4
		})

		v10.updateRsvpStatus(p3, p4)

		v8.cache:modify({
			id = "VirtualEvent:" .. p3.id,
			fields = {
				userRsvpStatus = function(p5, p6, p7)
					return p4
				end,
				rsvpCounters = function(p5, p6, p7)
					local v14 = p4 == "going" and 1 or -1
					return Cryo.Dictionary.join(p6, {
						going = p6.going + v14
					})
				end
			}
		})
	end, { v10 })

	local v14 = React.useCallback(function(p3)
		v9.fireAnalyticsEvent(EventNames.EventOpened, { virtualEventId = p3.id })

		if fFlagLuaAppSduiEventDetailsEnabled then
			navigateToEventDetails(v7, p3.id, (tostring(p3.universeId)))
		else
			v7.navigate(appPage.EventDetails, {
				extraProps = { currentTime = DateTime.now(), virtualEventId = p3.id }
			})
		end
	end, { v7 })

	local v15 = React.useCallback(function(data)
		v9.fireAnalyticsEvent(EventNames.EventJoined, { virtualEventId = data.id })

		VirtualEvents.fireVirtualEventJoined({
			virtualEventId = data.id,
			universeId = tostring(data.universeId),
			channel = "communityPeekView"
		})

		launchGame(data.placeId, nil, { eventId = data.id }, v6)
	end, {})

	local v16 = React.useCallback(function(p3)
		VirtualEvents.fireVirtualEventImpression({
			virtualEventId = p3.id,
			universeId = p3.universeId,
			channel = "communityPeekView"
		})
	end, {})

	local v17 = if FFlagEnableCommunityProfileLoadingSkeletons then useSignalState(v10.isLoading) else false

	local createElement = React.createElement
	local v19 = {
		size = UDim2.new(1, 0, 0, 0),
		backgroundTransparency = 1,
		layoutOrder = p2.layoutOrder,
		useAutomaticSizing = true
	}

	local v20 = {
		NavEvents = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = function()
				v10.refetch()
			end
		}),
		EventsCarousel = 0
	}

	local v21 = if FFlagEnableCommunityProfileLoadingSkeletons and v17 then React.createElement(EventsSkeleton, {
		numSkeletons = #v5.events
	}) else React.createElement(eventsListCarousel, {
		virtualEvents = v12,
		onTileActivated = v14,
		onRsvpChanged = v13,
		onJoinEvent = v15,
		onEventImpression = v16,
		peekViewFormat = true,
		referralSource = "communityPeekView",
		universeId = universeId
	})
	v20.EventsCarousel = v21
	return createElement(horizontalPageMargin, v19, v20)
end

return EventsContainer
