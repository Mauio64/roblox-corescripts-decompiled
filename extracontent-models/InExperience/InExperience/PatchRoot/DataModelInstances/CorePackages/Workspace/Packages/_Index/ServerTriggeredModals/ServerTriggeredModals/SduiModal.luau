local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local ServerDrivenUi = require(parent.ServerDrivenUi)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local React = require(parent.React)
local reportModalImpression = require(ServerTriggeredModals.reportModalImpression)
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent
local RoactServiceTags = require(parent.RoactServiceTags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local AppPage = RobloxAppEnums.AppPage
local useSduiContext = ServerDrivenUi.useSduiContext
local SduiComponent = ServerDrivenUi.SduiComponent

return React.memo(function(props)
	local v = useRoactService(RoactServiceTags.RoactNetworking)
	local sduiContext = useSduiContext({ appPage = AppPage.Home, dataUpdatedTimestamp = os.time() })

	local modalId = props.modalId
	local modalType = props.modalType

	React.useEffect(function()
		reportModalImpression(v, modalId, modalType)
		sendModalImpressionEvent(modalId, modalType)
	end, {})

	return React.createElement(SduiComponent, {
		debugName = "SduiModal",
		componentConfig = props.sduiComponentConfig,
		sduiContext = sduiContext
	})
end)
