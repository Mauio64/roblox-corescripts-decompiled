local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local AppPage = require(Modules.LuaApp.AppPage)
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local Cryo = require(CorePackages.Packages.Cryo)
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)

require(CorePackages.Workspace.Packages.GraphQLServer)

local LaunchGameOnMount = require(script.Parent.LaunchGameOnMount)
local Navigation = require(CorePackages.Workspace.Packages.Navigation)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local useNavigation = Navigation.useNavigation
local useNavigationFocus = Navigation.useNavigationFocus
local VirtualEvents = require(CorePackages.Workspace.Packages.VirtualEvents)
local EventsListCarousel = VirtualEvents.EventsListCarousel
local useQuery = ApolloClient.useQuery
local useMutation = ApolloClient.useMutation
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuaAppEnableVirtualEventPlaceId = SharedFlags.GetFFlagLuaAppEnableVirtualEventPlaceId
local FFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled
local t1 = {
	pollInterval = 300000
}

local function EventsListWrapper(t2: {[any]: any}) -- line: 49
	-- upvalues: Cryo (copy), t1 (copy), useNavigation (copy), React (copy), useQuery (copy), VirtualEvents (copy), useMutation (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), DataHydration (copy), AppPage (copy), CorePackages (copy), useNavigationFocus (copy), Signals (copy), LaunchGameOnMount (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), EventsListCarousel (copy)
	local v23 = Cryo.Dictionary.join(t1, t2)
	local v24 = useNavigation()
	local v25, v26 = React.useState(nil)
	local v27 = React.useMemo(function() -- line: 55
		return DateTime.now()
	end, {})
	local v28 = useQuery(VirtualEvents.requests.GET_EVENTS_FOR_EXPERIENCE, {
		variables = {
			universeId = v23.universeId,
			options = {
				fromUtc = v27:ToIsoDate()
			}
		},
		pollInterval = v23.pollInterval
	})
	local v29 = useMutation(VirtualEvents.requests.UPDATE_RSVP_STATUS, {
		update = function(_, p2, p3) -- line: 70
			-- upvalues: Cryo (copy)
			local virtualEvent = p3.data.virtualEventRsvp.virtualEvent

			p2:modify({
				id = p2:identify(virtualEvent),
				fields = {
					rsvpCounters = function(_, t3: {[any]: any}) -- line: 76
						-- upvalues: virtualEvent (copy), Cryo (copy)
						local v51 = virtualEvent.userRsvpStatus ~= "going" and -1 or 1

						return Cryo.Dictionary.join(t3, {
							going = t3.going + v51
						})
					end
				}
			})
		end
	})
	local v30 = React.useCallback(function(p5, p6) -- line: 88
		-- upvalues: VirtualEvents (copy), v23 (copy), v29 (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), DataHydration (copy), v24 (copy), AppPage (copy)
		VirtualEvents.fireVirtualEventRSVP({
			virtualEventId = p5.id,
			universeId = tostring(p5.universeId),
			channel = v23.referralSource,
			status = p6,
			attendanceCount = (not p5 or not p5.experienceDetails) and 0 or p5.experienceDetails.playing
		})
		v29[1]({
			variables = {
				virtualEventId = p5.id,
				rsvpStatus = p6
			}
		}):andThen(function(p7) -- line: 106
			-- upvalues: FFlagLuaAppSduiEventDetailsEnabled (copy), p5 (copy), DataHydration (copy), p6 (copy), v24 (copy), AppPage (copy), v23 (copy)
			if FFlagLuaAppSduiEventDetailsEnabled and p5 then
				local v53 = DataHydration.ExperienceEvents.getExperienceEventInfoStore(false)
				local v54 = v53.getExperienceEventInfo(p5.id)
				local v55 = v54 and v54.data(false)

				if v55 ~= nil then
					local v56 = p6 == "going"
					local rsvpCount = v55.rsvpCount
					local v58 = if rsvpCount == nil then nil else rsvpCount + (not v56 and -1 or 1)

					v53.updateExperienceEventInfo(p5.id, {
						id = p5.id,
						userRsvp = v56,
						rsvpCount = v58
					})
				end
			end

			if p7.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal then
				v24.navigate(AppPage.EventNotificationsModal, {
					extraProps = {
						virtualEvent = p5,
						channel = v23.referralSource
					}
				})
			end
		end)
	end, { v23.referralSource })
	local v31 = React.useCallback(function(p8) -- line: 140
		-- upvalues: FFlagLuaAppSduiEventDetailsEnabled (copy), CorePackages (copy), v24 (copy), AppPage (copy), v23 (copy)
		if FFlagLuaAppSduiEventDetailsEnabled then
			require(CorePackages.Workspace.Packages.VirtualEvents).navigateToEventDetails(v24, p8.id, (tostring(p8.universeId)))

			return
		end

		v24.navigate(AppPage.EventDetails, {
			extraProps = {
				currentTime = DateTime.now(),
				virtualEventId = p8.id,
				referralSource = v23.referralSource
			}
		})
	end, { v24 })
	local v32 = React.useCallback(function(p9) -- line: 155
		-- upvalues: VirtualEvents (copy), v23 (copy)
		VirtualEvents.fireVirtualEventImpression({
			virtualEventId = p9.id,
			universeId = p9.universeId,
			channel = v23.referralSource
		})
	end, { v23.referralSource })
	local v33 = React.useCallback(function(p10) -- line: 163
		-- upvalues: v26 (copy)
		v26(p10)
	end, {})
	local v34 = React.useCallback(function() -- line: 167
		-- upvalues: VirtualEvents (copy), v25 (copy), v23 (copy)
		VirtualEvents.fireVirtualEventJoined({
			virtualEventId = v25.id,
			universeId = tostring(v25.universeId),
			channel = v23.referralSource,
			attendanceCount = (not v25 or not v25.experienceDetails) and 0 or v25.experienceDetails.playing
		})
	end, { v25 })
	local v35 = nil

	if FFlagLuaAppSduiEventDetailsEnabled then
		v35 = not useNavigationFocus()

		local v36 = React.useRef(v28.refetch)

		v36.current = v28.refetch
		React.useEffect(function() -- line: 189
			-- upvalues: v28 (copy), DataHydration (copy), Signals (copy), v36 (copy)
			local v46 = v28.data and (v28.data.virtualEventsByUniverseId and v28.data.virtualEventsByUniverseId.virtualEvents)

			if not v46 then
				return
			end

			local v47 = DataHydration.ExperienceEvents.getExperienceEventInfoStore(false)
			local v48 = Signals.createEffect(function(p11) -- line: 198
				-- upvalues: v46 (copy), v47 (copy), v36 (copy)
				for _, v61 in v46 do
					local v62 = v47.getExperienceEventInfo(v61.id).data(p11)

					if v62 ~= nil and v62.userRsvp == true ~= (v61.userRsvpStatus == "going") then
						local current = v36.current

						if current then
							task.defer(current)
						end

						return
					end
				end
			end)

			return function() -- line: 216
				-- upvalues: v48 (copy)
				v48()
			end
		end, {
			v28.data,
			v23.universeId
		})
	end

	if v28.data then
		return (React.createElement(React.Fragment, nil, {
			GameLauncher = if not v25 then nil else React.createElement(LaunchGameOnMount, {
				universeId = tostring(v25.universeId),
				placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() or not v25.placeId then nil else tostring(v25.placeId),
				launchSource = v23.referralSource,
				referralSource = v23.referralSource,
				onGameLaunching = v34,
				experienceJoinData = {
					eventId = v25.id
				}
			}),
			EventsCarousel = React.createElement(EventsListCarousel, {
				layoutOrder = v23.layoutOrder,
				virtualEvents = v28.data.virtualEventsByUniverseId.virtualEvents,
				onTileActivated = v31,
				onRsvpChanged = v30,
				onJoinEvent = v33,
				onEventImpression = v32,
				defaultThumbnail = v23.defaultThumbnail,
				peekViewFormat = v23.peekViewFormat,
				referralSource = v23.referralSource,
				universeId = v23.universeId,
				suppressRsvpReminderToastBecauseEventDetailsFocused = if not FFlagLuaAppSduiEventDetailsEnabled then nil else v35
			})
		}))
	end

	return nil
end

return EventsListWrapper
