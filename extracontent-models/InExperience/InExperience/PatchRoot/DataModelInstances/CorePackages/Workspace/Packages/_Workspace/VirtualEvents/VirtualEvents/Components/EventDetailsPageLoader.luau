local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local ApolloClient = require(VirtualEvents.Parent.ApolloClient)
local ExperimentLayers = require(VirtualEvents.Parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local RoactAppExperiment = require(VirtualEvents.Parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Foundation = require(VirtualEvents.Parent.Foundation)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local EventDetailsPage = require(VirtualEvents.Components.EventDetailsPage)
local EventDetailsVerticalPage = require(VirtualEvents.Components.EventDetailsVerticalPage)
local EventNotFoundModal = require(VirtualEvents.Components.EventNotFoundModal)
local requests = require(VirtualEvents.requests)
local getRetrievalStatusFromApolloQuery = require(VirtualEvents.Common.getRetrievalStatusFromApolloQuery)

local useQuery = ApolloClient.useQuery
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment = require(VirtualEvents.Flags.FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment)
local FFlagLuaAppFixEventNotFoundErrorStateExit = require(VirtualEvents.Flags.FFlagLuaAppFixEventNotFoundErrorStateExit)

local function EventDetailsPageLoader(props)
	local v = useQuery(requests.GET_VIRTUAL_EVENT, {
		variables = { virtualEventId = props.virtualEventId }
	})

	local v2 = getRetrievalStatusFromApolloQuery(v)

	local v3 = useLocalization({ notFound = "Feature.VirtualEvents.EventNotFound" })

	if props.mockNetworkStatus then
		v2 = props.mockNetworkStatus
	end

	local v4, v5

	if FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment then
		v4, v5 = useUserExperiment({ AppUserLayers.CreatorSuccessVirtualEvents }, function(p)
			local v6 = p[AppUserLayers.CreatorSuccessVirtualEvents] or {}
			return v6.EnableEventDetailsNewModal, v6.NotifyMeUseEmphasisVariant
		end, true)
	else
		v5 = nil
		v4 = nil
	end

	return React.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus.fromRawValue(v2),
		renderOnLoaded = function()
			local join = Cryo.Dictionary.join
			local v6 = {
				virtualEvent = v.data.virtualEvent,
				virtualEventId = Cryo.None,
				notifyMeUseEmphasisVariant = 0
			}
			local notifyMeUseEmphasisVariant

			if FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment then
				notifyMeUseEmphasisVariant = v5
			else
				notifyMeUseEmphasisVariant = false
			end

			v6.notifyMeUseEmphasisVariant = notifyMeUseEmphasisVariant
			local v7 = join(props, v6)
			local v8

			if FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment then
				v8 = v4
			else
				v8 = false
			end

			if v8 then
				return React.createElement(React.Fragment, nil, {
					FoundationProvider = React.createElement(
						Foundation.FoundationProvider,
						{ colorMode = Foundation.Enums.ColorMode.Dark },
						{
							AppStyleProvider = React.createElement(AppStyleProvider, {
								style = { themeName = "dark" }
							}, {
								EventDetailsPage = React.createElement(EventDetailsVerticalPage, v7)
							})
						}
					)
				})
			end

			return React.createElement(React.Fragment, nil, {
				EventDetailsPage = React.createElement(EventDetailsPage, v7)
			})
		end,
		renderOnFailed = function()
			if FFlagLuaAppFixEventNotFoundErrorStateExit then
				return (React.createElement(EventNotFoundModal, { onClose = props.onClose }))
			end

			return (React.createElement(React.Fragment, nil, {
				EventNotFound = React.createElement(EmptyState, { text = v3.notFound })
			}))
		end
	})
end

return EventDetailsPageLoader
