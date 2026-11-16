local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local SessionService = game:GetService("SessionService")
local GuiService = game:GetService("GuiService")

local ApolloClient = require(CorePackages.Packages.ApolloClient)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/SharedFlags").isSubjectToDesktopPolicies
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local module = require("@luauforge/bundled/dHo")
local module2 = require("@luauforge/bundled/dCp")

local default = require("@luauforge/bundled/bXs").ExternalContentSharingProtocol.default
local sessionType = require("@luauforge/bundled/foF").SessionType
local setGamePlaySession = require("@luauforge/bundled/foF").SetGamePlaySession
local module3 = require("@luauforge/deferred/fYS")
local module4 = require("@luauforge/bundled/fue")
local module5 = require("@luauforge/deferred/fYQ")

local useQuery = ApolloClient.useQuery
local useUserExperiment = RoactAppExperiment.useUserExperiment
local useIXPService = RoactAppExperiment.useIXPService

local getFFlagRemoveVirtualEventsExperiment = require("@game/CorePackages/Workspace/Packages/SharedFlags").getFFlagRemoveVirtualEventsExperiment

local getFFlagLuaAppEnableVirtualEventPlaceId = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableVirtualEventPlaceId

local fFlagLuaAppSduiEventDetailsLogExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiEventDetailsLogExposure

local fStringLuaAppSduiEventDetailsIxpLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaAppSduiEventDetailsIxpLayer

local v5 = { referralSource = "link" }

local function EventDetailsWrapper(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useDispatch()
	local v7 = useNavigation()
	local state, setState = React.useState(false)
	local ref = React.useRef(true)
	local safeZoneOffsets = GuiService:GetSafeZoneOffsets()

	local v8 = useQuery(module3.requests.GET_VIRTUAL_EVENT, {
		variables = { virtualEventId = joined.virtualEventId }
	})

	local virtualEvent = if v8.data then v8.data.virtualEvent else nil
	local universeId

	if virtualEvent and virtualEvent.universeId then
		universeId = tostring(virtualEvent.universeId)
	else
		universeId = nil
	end

	local placeId

	if getFFlagLuaAppEnableVirtualEventPlaceId() and virtualEvent and virtualEvent.placeId then
		placeId = tostring(virtualEvent.placeId)
	end

	local v9 = not virtualEvent and 0 or virtualEvent.experienceDetails.playing

	local v10 = useLocalization({ hostTitle = "Feature.GameDetails.Label.Developer" })

	local v11 = useIXPService()
	local v12

	if getFFlagRemoveVirtualEventsExperiment() then
		v12 = nil
	else
		v12 = useUserExperiment({ "Ecosystems.EventsOnExperienceDetailsPage" }, function(p3)
			local ecosystemsEventsOnExperienceDetailsPage = p3["Ecosystems.EventsOnExperienceDetailsPage"]

			if ecosystemsEventsOnExperienceDetailsPage then
				return ecosystemsEventsOnExperienceDetailsPage.virtualEventsMVPEnabled
			end

			return nil
		end, false)
	end

	local v13 = React.useCallback(function()
		v7.goBack()
	end, {})

	local v14 = React.useCallback(function()
		if universeId then
			v6(module(universeId))
		end
	end, { universeId })

	local v15 = React.useCallback(function(p3)
		if default then
			default:shareUrl({ url = p3, context = "eventDetailsPage" })
		end
	end, {})

	local v16 = React.useCallback(function(p3)
		if universeId then
			module3.fireVirtualEventLinkCopied({
				virtualEventId = joined.virtualEventId,
				virtualEventLink = p3,
				universeId = universeId,
				attendanceCount = v9
			})
		end
	end, { joined.virtualEventId, universeId, v9 })

	local v17 = React.useCallback(function()
		if universeId then
			module3.fireShareVirtualEventIconClicked({
				virtualEventId = joined.virtualEventId,
				universeId = universeId,
				channel = "eventDetailsPage",
				attendanceCount = v9
			})

			local appsflyer = urlBuilder.virtualevents.appsflyer({
				eventId = joined.virtualEventId
			})

			if isSubjectToDesktopPolicies() then
				v7.navigate(module2.ShareVirtualEventModal, {
					extraProps = {
						virtualEventId = joined.virtualEventId,
						onCopy = function()
							v16(appsflyer)

							if default then
								default:shareUrl({
									url = appsflyer,
									context = "eventDetailsPage"
								})
							end
						end
					}
				})
			else
				v15(appsflyer)
			end
		end
	end, { joined.virtualEventId, universeId, v9 })

	local v18 = React.useCallback(function()
		setState(true)
	end, {})

	local v19 = React.useCallback(function()
		setGamePlaySession(SessionService, sessionType.StructuralIdentifier.GamePlayFromEventDetails, true)

		module3.fireVirtualEventJoined({
			virtualEventId = virtualEvent.id,
			universeId = tostring(virtualEvent.universeId),
			channel = "eventDetailsPage",
			attendanceCount = v9
		})
	end, { virtualEvent, v9 })

	local v20 = React.useCallback(function(p3, p4)
		module3.fireVirtualEventRSVP({
			virtualEventId = virtualEvent.id,
			universeId = tostring(virtualEvent.universeId),
			channel = "eventDetailsPage",
			status = p3,
			attendanceCount = v9
		})

		if p4 then
			if getFFlagRemoveVirtualEventsExperiment() then
				v7.navigate(module2.EventNotificationsModal, {
					extraProps = {
						virtualEvent = virtualEvent,
						channel = "eventDetailsPage"
					}
				})
				return
			end

			v11:LogUserLayerExposure("Ecosystems.EventsOnExperienceDetailsPage")

			if v12 then
				v7.navigate(module2.EventNotificationsModal, {
					extraProps = {
						virtualEvent = virtualEvent,
						channel = "eventDetailsPage"
					}
				})
			end
		end
	end, { virtualEvent, v7, v9, v12, v11 })

	React.useEffect(function()
		if ref.current and virtualEvent then
			module3.fireEventDetailsPageVisit({
				virtualEventId = virtualEvent.id,
				universeId = tostring(virtualEvent.universeId),
				channel = joined.referralSource
			})

			ref.current = false
		end
	end, { virtualEvent })

	React.useEffect(function()
		if joined.virtualEventId and fFlagLuaAppSduiEventDetailsLogExposure then
			IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppSduiEventDetailsIxpLayer)
		end
	end, { joined.virtualEventId })

	local v21 = React.useCallback(function(p3)
		v7.navigate(module2.GenericWebPage, {
			detail = urlBuilder.game.info.creator({
				creatorType = p3.hostType == "group" and "Group" or "User",
				creatorId = p3.hostId
			}),
			extraProps = {
				title = v10.hostTitle,
				transitionAnimation = module4.SlideInFromRight
			}
		})
	end, { v7, v10 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v24

	if state and universeId then
		local createElement2 = React.createElement
		local v26 = {
			universeId = universeId,
			placeId = 0,
			launchSource = "eventDetailsPage",
			referralSource = 0,
			onGameLaunching = 0,
			experienceJoinData = 0
		}

		if not getFFlagLuaAppEnableVirtualEventPlaceId() then
			placeId = nil
		end

		v26.placeId = placeId

		v26.referralSource = joined.referralSource
		v26.onGameLaunching = v19
		v26.experienceJoinData = { eventId = joined.virtualEventId }
		v24 = createElement2(module5, v26)
	end

	return createElement(fragment, nil, {
		GameLauncher = v24,
		Wrapper = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(0, safeZoneOffsets.top),
			Position = UDim2.fromOffset(0, safeZoneOffsets.top),
			BackgroundTransparency = 1,
			SelectionGroup = true,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		}, {
			EventDetailsPageLoader = React.createElement(module3.EventDetailsPageLoader, {
				virtualEventId = joined.virtualEventId,
				currentTime = DateTime.now(),
				onClose = v13,
				onShare = v17,
				onRsvpChanged = v20,
				onJoinEvent = v18,
				onExperienceTileActivated = v14,
				onHostActivated = v21
			})
		})
	})
end

return EventDetailsWrapper
