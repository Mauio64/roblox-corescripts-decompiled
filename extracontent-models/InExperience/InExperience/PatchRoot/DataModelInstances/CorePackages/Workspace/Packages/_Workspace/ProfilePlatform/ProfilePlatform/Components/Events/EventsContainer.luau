local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local VirtualEvents = require(ProfilePlatformParent.VirtualEvents)
local EventsListCarousel = VirtualEvents.EventsListCarousel
local Enums = require(ProfilePlatform.Common.Enums)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Cryo = require(ProfilePlatformParent.Cryo)

require(ProfilePlatformParent.Signals)

local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local LaunchGame = require(ProfilePlatform.Parent.GameLaunch).LaunchGame
local useNavigation = require(ProfilePlatform.Parent.Navigation).useNavigation

require(ProfilePlatform.Parent.GraphQLServer)

local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local AppGame = require(ProfilePlatformParent.RoactServiceTags).AppGame
local React = require(ProfilePlatformParent.React)
local HorizontalPageMargin = require(ProfilePlatformParent.UIBlox).App.Container.HorizontalPageMargin
local createGroupEventsStore = require(ProfilePlatform.Stores.createGroupEventsStore)
local useSignalState = require(ProfilePlatformParent.SignalsReact).useSignalState
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local FFlagLuaAppSduiEventDetailsEnabled = require(ProfilePlatformParent.SharedFlags).FFlagLuaAppSduiEventDetailsEnabled
local navigateToEventDetails = require(ProfilePlatformParent.VirtualEvents).navigateToEventDetails
local useApolloClient = require(ProfilePlatformParent.ApolloClient).useApolloClient
local RoactNavigation = require(ProfilePlatformParent.RoactNavigation)
local EventsSkeleton = require(ProfilePlatform.Components.Events.EventsSkeleton)
local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)

local function EventsContainer(t1: {[any]: any}) -- line: 63
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), useProfileWrapperContext (copy), useRoactService (copy), AppGame (copy), useNavigation (copy), useApolloClient (copy), useProfileAnalyticsContext (copy), React (copy), createGroupEventsStore (copy), useSignalState (copy), EventNames (copy), VirtualEvents (copy), Cryo (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), navigateToEventDetails (copy), AppPage (copy), LaunchGame (copy), FFlagEnableCommunityProfileLoadingSkeletons (copy), HorizontalPageMargin (copy), RoactNavigation (copy), EventsSkeleton (copy), EventsListCarousel (copy)
	local v28 = useProfileJsonComponent(Enums.Components.Events)
	local num = tonumber(useProfileWrapperContext().profileId)
	local v30 = useRoactService(AppGame)
	local v31 = useNavigation()
	local v32 = useApolloClient()
	local v33 = useProfileAnalyticsContext()
	local v34 = React.useMemo(function() -- line: 73
		-- upvalues: createGroupEventsStore (copy), num (copy)
		return createGroupEventsStore(num)
	end, { num })
	local v35 = useSignalState(v34.getEvents)
	local v36 = React.useMemo(function() -- line: 80
		-- upvalues: v35 (copy), v28 (copy)
		local t2 = {}

		if v35 == nil then
			return t2
		end

		local t3 = {}

		for _, v in ipairs(v35) do
			t3[v.id] = v
		end

		for _, v in ipairs(if not v28 then {} else v28.events) do
			local v49 = t3[v.id]

			if v49 ~= nil then
				table.insert(t2, v49)
			end
		end

		return t2
	end, {
		v35,
		v28
	})
	local v37 = not (#v36 > 0) and 0 or (tonumber(v36[1].universeId) or 0)
	local v38 = React.useCallback(function(p1, p2) -- line: 110
		-- upvalues: v33 (copy), EventNames (copy), VirtualEvents (copy), v34 (copy), v32 (copy), Cryo (copy)
		v33.fireAnalyticsEvent(EventNames.EventRSVP, {
			virtualEventId = p1.id,
			status = p2
		})
		VirtualEvents.fireVirtualEventRSVP({
			channel = "communityPeekView",
			virtualEventId = p1.id,
			universeId = tostring(p1.universeId),
			status = p2
		})
		v34.updateRsvpStatus(p1, p2)
		v32.cache:modify({
			id = "VirtualEvent:" .. p1.id,
			fields = {
				userRsvpStatus = function(_, _, _) -- line: 126
					-- upvalues: p2 (copy)
					return p2
				end,
				rsvpCounters = function(_, t4: {[any]: any}, _) -- line: 129
					-- upvalues: p2 (copy), Cryo (copy)
					local v61 = p2 ~= "going" and -1 or 1

					return Cryo.Dictionary.join(t4, {
						going = t4.going + v61
					})
				end
			}
		})
	end, { v34 })
	local v39 = React.useCallback(function(p8) -- line: 141
		-- upvalues: v33 (copy), EventNames (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), navigateToEventDetails (copy), v31 (copy), AppPage (copy)
		v33.fireAnalyticsEvent(EventNames.EventOpened, {
			virtualEventId = p8.id
		})

		if FFlagLuaAppSduiEventDetailsEnabled then
			navigateToEventDetails(v31, p8.id, (tostring(p8.universeId)))

			return
		end

		v31.navigate(AppPage.EventDetails, {
			extraProps = {
				currentTime = DateTime.now(),
				virtualEventId = p8.id
			}
		})
	end, { v31 })
	local v40 = React.useCallback(function(p9) -- line: 157
		-- upvalues: v33 (copy), EventNames (copy), VirtualEvents (copy), LaunchGame (copy), v30 (copy)
		v33.fireAnalyticsEvent(EventNames.EventJoined, {
			virtualEventId = p9.id
		})
		VirtualEvents.fireVirtualEventJoined({
			channel = "communityPeekView",
			virtualEventId = p9.id,
			universeId = tostring(p9.universeId)
		})
		LaunchGame(p9.placeId, nil, {
			eventId = p9.id
		}, v30)
	end, {})
	local v41 = React.useCallback(function(p10) -- line: 169
		-- upvalues: VirtualEvents (copy)
		VirtualEvents.fireVirtualEventImpression({
			channel = "communityPeekView",
			virtualEventId = p10.id,
			universeId = p10.universeId
		})
	end, {})
	local v42 = not not FFlagEnableCommunityProfileLoadingSkeletons and useSignalState(v34.isLoading)

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		size = UDim2.new(1, 0, 0, 0),
		layoutOrder = t1.layoutOrder
	}, {
		NavEvents = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = function() -- line: 188
				-- upvalues: v34 (copy)
				v34.refetch()
			end
		}),
		EventsCarousel = if not FFlagEnableCommunityProfileLoadingSkeletons or not v42 then React.createElement(EventsListCarousel, {
			peekViewFormat = true,
			referralSource = "communityPeekView",
			virtualEvents = v36,
			onTileActivated = v39,
			onRsvpChanged = v38,
			onJoinEvent = v40,
			onEventImpression = v41,
			universeId = v37
		}) else React.createElement(EventsSkeleton, {
			numSkeletons = #v28.events
		})
	})
end

return EventsContainer
