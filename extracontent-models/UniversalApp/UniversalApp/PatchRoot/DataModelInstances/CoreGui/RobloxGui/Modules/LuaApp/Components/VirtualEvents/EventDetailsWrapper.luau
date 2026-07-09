local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local SessionService = game:GetService("SessionService")
local GuiService = game:GetService("GuiService")
local Modules = script:FindFirstAncestor("Modules")
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local isSubjectToDesktopPolicies = require(CorePackages.Workspace.Packages.SharedFlags).isSubjectToDesktopPolicies
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local AppPage = require(Modules.LuaApp.AppPage)
local default = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local SetGamePlaySession = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SetGamePlaySession
local VirtualEvents = require(CorePackages.Workspace.Packages.VirtualEvents)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local LaunchGameOnMount = require(script.Parent.LaunchGameOnMount)
local useQuery = ApolloClient.useQuery
local useUserExperiment = RoactAppExperiment.useUserExperiment
local useIXPService = RoactAppExperiment.useIXPService
local getFFlagRemoveVirtualEventsExperiment = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagRemoveVirtualEventsExperiment
local GetFFlagLuaAppEnableVirtualEventPlaceId = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableVirtualEventPlaceId
local FFlagLuaAppSduiEventDetailsLogExposure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSduiEventDetailsLogExposure
local FStringLuaAppSduiEventDetailsIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaAppSduiEventDetailsIxpLayer
local t1 = {
	referralSource = "link"
}

local function EventDetailsWrapper(t2: {[any]: any}) -- line: 55
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), useNavigation (copy), React (copy), GuiService (copy), useQuery (copy), VirtualEvents (copy), GetFFlagLuaAppEnableVirtualEventPlaceId (copy), useLocalization (copy), useIXPService (copy), getFFlagRemoveVirtualEventsExperiment (copy), useUserExperiment (copy), OpenGameDetails (copy), default (copy), UrlBuilder (copy), isSubjectToDesktopPolicies (copy), AppPage (copy), SetGamePlaySession (copy), SessionService (copy), SessionType (copy), FFlagLuaAppSduiEventDetailsLogExposure (copy), IXPService (copy), FStringLuaAppSduiEventDetailsIxpLayer (copy), TransitionAnimation (copy), LaunchGameOnMount (copy)
	local v33 = Cryo.Dictionary.join(t1, t2)
	local v34 = useDispatch()
	local v35 = useNavigation()
	local v36, v37 = React.useState(false)
	local v38 = React.useRef(true)
	local SafeZoneOffsets = GuiService:GetSafeZoneOffsets()
	local v40 = useQuery(VirtualEvents.requests.GET_VIRTUAL_EVENT, {
		variables = {
			virtualEventId = v33.virtualEventId
		}
	})
	local v41 = if not v40.data then nil else v40.data.virtualEvent
	local v42 = if not v41 or not v41.universeId then nil else tostring(v41.universeId)
	local v43 = if not GetFFlagLuaAppEnableVirtualEventPlaceId() or (not v41 or not v41.placeId) then nil else tostring(v41.placeId)
	local v44 = not v41 and 0 or v41.experienceDetails.playing
	local v45 = useLocalization({
		hostTitle = "Feature.GameDetails.Label.Developer"
	})
	local v46 = useIXPService()
	local v47 = if not getFFlagRemoveVirtualEventsExperiment() then useUserExperiment({ "Ecosystems.EventsOnExperienceDetailsPage" }, function(p1) -- line: 89
		local v58 = p1["Ecosystems.EventsOnExperienceDetailsPage"]

		if v58 then
			return v58.virtualEventsMVPEnabled
		end

		return nil
	end, false) else nil
	local v48 = React.useCallback(function() -- line: 94
		-- upvalues: v35 (copy)
		v35.goBack()
	end, {})
	local v49 = React.useCallback(function() -- line: 98
		-- upvalues: v42 (copy), v34 (copy), OpenGameDetails (copy)
		if v42 then
			v34(OpenGameDetails(v42))
		end
	end, { v42 })
	local v50 = React.useCallback(function(s1: string) -- line: 104
		-- upvalues: default (copy)
		if default then
			default:shareUrl({
				context = "eventDetailsPage",
				url = s1
			})
		end
	end, {})
	local v51 = React.useCallback(function(s2: string) -- line: 113
		-- upvalues: v42 (copy), VirtualEvents (copy), v33 (copy), v44 (copy)
		if v42 then
			VirtualEvents.fireVirtualEventLinkCopied({
				virtualEventId = v33.virtualEventId,
				virtualEventLink = s2,
				universeId = v42,
				attendanceCount = v44
			})
		end
	end, {
		v33.virtualEventId,
		v42,
		v44
	})
	local v52 = React.useCallback(function() -- line: 124
		-- upvalues: v42 (copy), VirtualEvents (copy), v33 (copy), v44 (copy), UrlBuilder (copy), isSubjectToDesktopPolicies (copy), v35 (copy), AppPage (copy), v51 (copy), default (copy), v50 (copy)
		if v42 then
			VirtualEvents.fireShareVirtualEventIconClicked({
				channel = "eventDetailsPage",
				virtualEventId = v33.virtualEventId,
				universeId = v42,
				attendanceCount = v44
			})

			local v61 = UrlBuilder.virtualevents.appsflyer({
				eventId = v33.virtualEventId
			})

			if isSubjectToDesktopPolicies() then
				v35.navigate(AppPage.ShareVirtualEventModal, {
					extraProps = {
						virtualEventId = v33.virtualEventId,
						onCopy = function() -- line: 141
							-- upvalues: v51 (copy), v61 (copy), default (copy)
							v51(v61)

							if default then
								default:shareUrl({
									context = "eventDetailsPage",
									url = v61
								})
							end
						end
					}
				})

				return
			end

			v50(v61)
		end
	end, {
		v33.virtualEventId,
		v42,
		v44
	})
	local v53 = React.useCallback(function() -- line: 159
		-- upvalues: v37 (copy)
		v37(true)
	end, {})
	local v54 = React.useCallback(function() -- line: 163
		-- upvalues: SetGamePlaySession (copy), SessionService (copy), SessionType (copy), VirtualEvents (copy), v41 (copy), v44 (copy)
		SetGamePlaySession(SessionService, SessionType.StructuralIdentifier.GamePlayFromEventDetails, true)
		VirtualEvents.fireVirtualEventJoined({
			channel = "eventDetailsPage",
			virtualEventId = v41.id,
			universeId = tostring(v41.universeId),
			attendanceCount = v44
		})
	end, {
		v41,
		v44
	})
	local v55 = React.useCallback(function(p2, b1: boolean?) -- line: 175
		-- upvalues: VirtualEvents (copy), v41 (copy), v44 (copy), getFFlagRemoveVirtualEventsExperiment (copy), v35 (copy), AppPage (copy), v46 (copy), v47 (copy)
		VirtualEvents.fireVirtualEventRSVP({
			channel = "eventDetailsPage",
			virtualEventId = v41.id,
			universeId = tostring(v41.universeId),
			status = p2,
			attendanceCount = v44
		})

		if b1 then
			if getFFlagRemoveVirtualEventsExperiment() then
				v35.navigate(AppPage.EventNotificationsModal, {
					extraProps = {
						channel = "eventDetailsPage",
						virtualEvent = v41
					}
				})

				return
			end

			v46:LogUserLayerExposure("Ecosystems.EventsOnExperienceDetailsPage")

			if v47 then
				v35.navigate(AppPage.EventNotificationsModal, {
					extraProps = {
						channel = "eventDetailsPage",
						virtualEvent = v41
					}
				})
			end
		end
	end, {
		v41,
		v35,
		v44,
		v47,
		v46
	})

	React.useEffect(function() -- line: 209
		-- upvalues: v38 (copy), v41 (copy), VirtualEvents (copy), v33 (copy)
		if v38.current and v41 then
			VirtualEvents.fireEventDetailsPageVisit({
				virtualEventId = v41.id,
				universeId = tostring(v41.universeId),
				channel = v33.referralSource
			})
			v38.current = false
		end
	end, { v41 })
	React.useEffect(function() -- line: 221
		-- upvalues: v33 (copy), FFlagLuaAppSduiEventDetailsLogExposure (copy), IXPService (copy), FStringLuaAppSduiEventDetailsIxpLayer (copy)
		if v33.virtualEventId and FFlagLuaAppSduiEventDetailsLogExposure then
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppSduiEventDetailsIxpLayer)
		end
	end, { v33.virtualEventId })

	local v56 = React.useCallback(function(p3) -- line: 227
		-- upvalues: v35 (copy), AppPage (copy), UrlBuilder (copy), v45 (copy), TransitionAnimation (copy)
		v35.navigate(AppPage.GenericWebPage, {
			detail = UrlBuilder.game.info.creator({
				creatorType = p3.hostType ~= "group" and "User" or "Group",
				creatorId = p3.hostId
			}),
			extraProps = {
				title = v45.hostTitle,
				transitionAnimation = TransitionAnimation.SlideInFromRight
			}
		})
	end, {
		v35,
		v45
	})

	return React.createElement(React.Fragment, nil, {
		GameLauncher = if not v36 or not v42 then nil else React.createElement(LaunchGameOnMount, {
			launchSource = "eventDetailsPage",
			universeId = v42,
			placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else v43,
			referralSource = v33.referralSource,
			onGameLaunching = v54,
			experienceJoinData = {
				eventId = v33.virtualEventId
			}
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			SelectionGroup = true,
			Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(0, SafeZoneOffsets.top),
			Position = UDim2.fromOffset(0, SafeZoneOffsets.top),
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		}, {
			EventDetailsPageLoader = React.createElement(VirtualEvents.EventDetailsPageLoader, {
				virtualEventId = v33.virtualEventId,
				currentTime = DateTime.now(),
				onClose = v48,
				onShare = v52,
				onRsvpChanged = v55,
				onJoinEvent = v53,
				onExperienceTileActivated = v49,
				onHostActivated = v56
			})
		})
	})
end

return EventDetailsWrapper
