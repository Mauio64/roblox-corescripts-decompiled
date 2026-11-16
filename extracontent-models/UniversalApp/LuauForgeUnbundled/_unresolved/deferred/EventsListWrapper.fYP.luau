local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dCp")
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local Cryo = require(CorePackages.Packages.Cryo)
local module2 = require("@luauforge/bundled/dPI")
require("@luauforge/bundled/eeg")
local module3 = require("@luauforge/deferred/fYQ")
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local useNavigation = Navigation.useNavigation
local useNavigationFocus = Navigation.useNavigationFocus
local module5 = require("@luauforge/deferred/fYS")

local eventsListCarousel = module5.EventsListCarousel
local useQuery = ApolloClient.useQuery
local useMutation = ApolloClient.useMutation

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagLuaAppEnableVirtualEventPlaceId = SharedFlags.GetFFlagLuaAppEnableVirtualEventPlaceId
local fFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled

local v5 = { pollInterval = 300000 }

local function EventsListWrapper(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useNavigation()
	local state, setState = React.useState(nil)

	local v7 = React.useMemo(function()
		return DateTime.now()
	end, {})

	local v8 = useQuery(module5.requests.GET_EVENTS_FOR_EXPERIENCE, {
		variables = {
			universeId = joined.universeId,
			options = { fromUtc = v7:ToIsoDate() }
		},
		pollInterval = joined.pollInterval
	})

	local v9 = useMutation(module5.requests.UPDATE_RSVP_STATUS, {
		update = function(p3, object, p4)
			local virtualEvent = p4.data.virtualEventRsvp.virtualEvent

			object:modify({
				id = object:identify(virtualEvent),
				fields = {
					rsvpCounters = function(p5, p6)
						local v10 = virtualEvent.userRsvpStatus == "going" and 1 or -1
						return Cryo.Dictionary.join(p6, {
							going = p6.going + v10
						})
					end
				}
			})
		end
	})

	local v10 = React.useCallback(function(data, p3)
		module5.fireVirtualEventRSVP({
			virtualEventId = data.id,
			universeId = tostring(data.universeId),
			channel = joined.referralSource,
			status = p3,
			attendanceCount = not (data and data.experienceDetails) and 0 or data.experienceDetails.playing
		})

		v9[1]({
			variables = { virtualEventId = data.id, rsvpStatus = p3 }
		}):andThen(function(p4)
			if fFlagLuaAppSduiEventDetailsEnabled and data then
				local experienceEventInfoStore = module2.ExperienceEvents.getExperienceEventInfoStore(false)
				local experienceEventInfo = experienceEventInfoStore.getExperienceEventInfo(data.id)
				local v11 = experienceEventInfo and experienceEventInfo.data(false)

				if v11 ~= nil then
					local v12 = p3 == "going"
					local rsvpCount = v11.rsvpCount

					local v13 = if rsvpCount ~= nil then rsvpCount + (v12 and 1 or -1) else nil

					experienceEventInfoStore.updateExperienceEventInfo(data.id, {
						id = data.id,
						userRsvp = v12,
						rsvpCount = v13
					})
				end
			end

			if p4.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal then
				v6.navigate(module.EventNotificationsModal, {
					extraProps = {
						virtualEvent = data,
						channel = joined.referralSource
					}
				})
			end
		end)
	end, { joined.referralSource })

	local v11 = React.useCallback(function(p3)
		if fFlagLuaAppSduiEventDetailsEnabled then
			require("@luauforge/deferred/fYS").navigateToEventDetails(v6, p3.id, (tostring(p3.universeId)))
		else
			v6.navigate(module.EventDetails, {
				extraProps = {
					currentTime = DateTime.now(),
					virtualEventId = p3.id,
					referralSource = joined.referralSource
				}
			})
		end
	end, { v6 })

	local v12 = React.useCallback(function(p3)
		module5.fireVirtualEventImpression({
			virtualEventId = p3.id,
			universeId = p3.universeId,
			channel = joined.referralSource
		})
	end, { joined.referralSource })

	local v13 = React.useCallback(function(p3)
		setState(p3)
	end, {})

	local v14 = React.useCallback(function()
		module5.fireVirtualEventJoined({
			virtualEventId = state.id,
			universeId = tostring(state.universeId),
			channel = joined.referralSource,
			attendanceCount = not (state and state.experienceDetails) and 0 or state.experienceDetails.playing
		})
	end, { state })
	local v15

	if fFlagLuaAppSduiEventDetailsEnabled then
		v15 = not useNavigationFocus()

		local ref = React.useRef(v8.refetch)
		ref.current = v8.refetch
		React.useEffect(function()
			local virtualEvents = v8.data
				and v8.data.virtualEventsByUniverseId
				and v8.data.virtualEventsByUniverseId.virtualEvents

			if not virtualEvents then
				return
			end

			local experienceEventInfoStore = module2.ExperienceEvents.getExperienceEventInfoStore(false)

			local effect = Signals.createEffect(function(p3)
				for k, virtualEvent in virtualEvents do
					local data = experienceEventInfoStore.getExperienceEventInfo(virtualEvent.id).data(p3)

					if
						data ~= nil
						and (data.userRsvp == true) ~= (virtualEvent.userRsvpStatus == "going")
					then
						local current = ref.current

						if current then
							task.defer(current)
						end

						break
					end
				end
			end)

			return function()
				effect()
			end
		end, { v8.data, joined.universeId })
	end

	if not v8.data then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v18

	if state then
		local createElement2 = React.createElement
		local v20 = {
			universeId = tostring(state.universeId),
			placeId = 0,
			launchSource = 0,
			referralSource = 0,
			onGameLaunching = 0,
			experienceJoinData = 0
		}
		local v21 = if getFFlagLuaAppEnableVirtualEventPlaceId() and state.placeId then tostring(state.placeId) else nil
		v20.placeId = v21

		v20.launchSource = joined.referralSource
		v20.referralSource = joined.referralSource
		v20.onGameLaunching = v14

		v20.experienceJoinData = { eventId = state.id }
		v18 = createElement2(module3, v20)
	end

	local createElement2 = React.createElement
	local v20 = {
		layoutOrder = joined.layoutOrder,
		virtualEvents = v8.data.virtualEventsByUniverseId.virtualEvents,
		onTileActivated = v11,
		onRsvpChanged = v10,
		onJoinEvent = v13,
		onEventImpression = v12,
		defaultThumbnail = joined.defaultThumbnail,
		peekViewFormat = joined.peekViewFormat,
		referralSource = joined.referralSource,
		universeId = joined.universeId,
		suppressRsvpReminderToastBecauseEventDetailsFocused = 0
	}

	if not fFlagLuaAppSduiEventDetailsEnabled then
		v15 = nil
	end

	v20.suppressRsvpReminderToastBecauseEventDetailsFocused = v15
	return (createElement(fragment, nil, {
		GameLauncher = v18,
		EventsCarousel = createElement2(eventsListCarousel, v20)
	}))
end

return EventsListWrapper
