local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ApolloClient")
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ExperimentLayers").AppUserLayers
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactAppExperiment").useUserExperiment
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventDetailsPage")
local EventDetailsVerticalPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventDetailsVerticalPage")
local EventNotFoundModal = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventNotFoundModal")
local requests = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/requests")
local getRetrievalStatusFromApolloQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getRetrievalStatusFromApolloQuery")

local useQuery = ApolloClient.useQuery
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState
local appStyleProvider = UIBlox.App.Style.AppStyleProvider

local FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Flags/FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment")
local FFlagLuaAppFixEventNotFoundErrorStateExit = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Flags/FFlagLuaAppFixEventNotFoundErrorStateExit")

local function EventDetailsPageLoader(props)
	local v5 = useQuery(requests.GET_VIRTUAL_EVENT, {
		variables = { virtualEventId = props.virtualEventId }
	})

	local v6 = getRetrievalStatusFromApolloQuery(v5)

	local v7 = useLocalization({ notFound = "Feature.VirtualEvents.EventNotFound" })

	if props.mockNetworkStatus then
		v6 = props.mockNetworkStatus
	end

	local v8, v9

	if FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment then
		v8, v9 = useUserExperiment({ appUserLayers.CreatorSuccessVirtualEvents }, function(p2)
			local v10 = p2[appUserLayers.CreatorSuccessVirtualEvents] or {}
			return v10.EnableEventDetailsNewModal, v10.NotifyMeUseEmphasisVariant
		end, true)
	else
		v9 = nil
		v8 = nil
	end

	return React.createElement(loadingStateContainer, {
		dataStatus = retrievalStatus.fromRawValue(v6),
		renderOnLoaded = function()
			local v13 = Cryo.Dictionary.join(props, {
				virtualEvent = v5.data.virtualEvent,
				virtualEventId = Cryo.None,
				notifyMeUseEmphasisVariant = if FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment then v9 else false
			})
			local v14 = if FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment then v8 else false

			if v14 then
				return React.createElement(React.Fragment, nil, {
					FoundationProvider = React.createElement(
						Foundation.FoundationProvider,
						{ colorMode = Foundation.Enums.ColorMode.Dark },
						{
							AppStyleProvider = React.createElement(appStyleProvider, {
								style = { themeName = "dark" }
							}, {
								EventDetailsPage = React.createElement(EventDetailsVerticalPage, v13)
							})
						}
					)
				})
			end

			return React.createElement(React.Fragment, nil, {
				EventDetailsPage = React.createElement(module6, v13)
			})
		end,
		renderOnFailed = function()
			if FFlagLuaAppFixEventNotFoundErrorStateExit then
				return (React.createElement(EventNotFoundModal, { onClose = props.onClose }))
			end

			return (React.createElement(React.Fragment, nil, {
				EventNotFound = React.createElement(emptyState, { text = v7.notFound })
			}))
		end
	})
end

return EventDetailsPageLoader
