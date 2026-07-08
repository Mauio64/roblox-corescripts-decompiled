local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local ApolloClient = require(VirtualEvents.Parent.ApolloClient)
local AppUserLayers = require(VirtualEvents.Parent.ExperimentLayers).AppUserLayers
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local useUserExperiment = require(VirtualEvents.Parent.RoactAppExperiment).useUserExperiment
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Foundation = require(VirtualEvents.Parent.Foundation)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
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

local function EventDetailsPageLoader(p1) -- line: 33
	-- upvalues: useQuery (copy), requests (copy), getRetrievalStatusFromApolloQuery (copy), useLocalization (copy), FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment (copy), useUserExperiment (copy), AppUserLayers (copy), React (copy), LoadingStateContainer (copy), RetrievalStatus (copy), Cryo (copy), Foundation (copy), AppStyleProvider (copy), EventDetailsVerticalPage (copy), EventDetailsPage (copy), FFlagLuaAppFixEventNotFoundErrorStateExit (copy), EventNotFoundModal (copy), EmptyState (copy)
	local v24 = useQuery(requests.GET_VIRTUAL_EVENT, {
		variables = {
			virtualEventId = p1.virtualEventId
		}
	})
	local v25 = getRetrievalStatusFromApolloQuery(v24)
	local v26 = useLocalization({
		notFound = "Feature.VirtualEvents.EventNotFound"
	})

	if p1.mockNetworkStatus then
		v25 = p1.mockNetworkStatus
	end

	local u27 = nil
	local u28 = nil

	if FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment then
		local v29, v30 = useUserExperiment({ AppUserLayers.CreatorSuccessVirtualEvents }, function(p2) -- line: 54
			-- upvalues: AppUserLayers (copy)
			local v32 = p2[AppUserLayers.CreatorSuccessVirtualEvents] or {}

			return v32.EnableEventDetailsNewModal, v32.NotifyMeUseEmphasisVariant
		end, true)

		u27 = v29
		u28 = v30
	end

	return React.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus.fromRawValue(v25),
		renderOnLoaded = function() -- line: 64
			-- upvalues: Cryo (copy), p1 (copy), v24 (copy), FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment (copy), u28 (ref), u27 (ref), React (copy), Foundation (copy), AppStyleProvider (copy), EventDetailsVerticalPage (copy), EventDetailsPage (copy)
			local v33 = Cryo.Dictionary.join(p1, {
				virtualEvent = v24.data.virtualEvent,
				virtualEventId = Cryo.None,
				notifyMeUseEmphasisVariant = not not FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment and u28
			})

			if not not FFlagLuaAppCreatorSuccessVirtualEventsLayerUseRoactExperiment and u27 then
				return React.createElement(React.Fragment, nil, {
					FoundationProvider = React.createElement(Foundation.FoundationProvider, {
						theme = Foundation.Enums.Theme.Dark
					}, {
						AppStyleProvider = React.createElement(AppStyleProvider, {
							style = {
								themeName = "dark"
							}
						}, {
							EventDetailsPage = React.createElement(EventDetailsVerticalPage, v33)
						})
					})
				})
			end

			return React.createElement(React.Fragment, nil, {
				EventDetailsPage = React.createElement(EventDetailsPage, v33)
			})
		end,
		renderOnFailed = function() -- line: 98
			-- upvalues: FFlagLuaAppFixEventNotFoundErrorStateExit (copy), React (copy), EventNotFoundModal (copy), p1 (copy), EmptyState (copy), v26 (copy)
			if FFlagLuaAppFixEventNotFoundErrorStateExit then
				return (React.createElement(EventNotFoundModal, {
					onClose = p1.onClose
				}))
			end

			return (React.createElement(React.Fragment, nil, {
				EventNotFound = React.createElement(EmptyState, {
					text = v26.notFound
				})
			}))
		end
	})
end

return EventDetailsPageLoader
