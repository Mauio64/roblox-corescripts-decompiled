local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local ServerDrivenUi = require(ServerTriggeredModalsParent.ServerDrivenUi)
local RobloxAppEnums = require(ServerTriggeredModalsParent.RobloxAppEnums)
local React = require(ServerTriggeredModalsParent.React)
local reportModalImpression = require(ServerTriggeredModals.reportModalImpression)
local sendModalImpressionEvent = require(ServerTriggeredModals.sendModalImpressionEvent)
local RoactServiceTags = require(ServerTriggeredModalsParent.RoactServiceTags)
local useRoactService = require(ServerTriggeredModalsParent.RobloxAppHooks).useRoactService
local AppPage = RobloxAppEnums.AppPage
local useSduiContext = ServerDrivenUi.useSduiContext
local SduiComponent = ServerDrivenUi.SduiComponent

return React.memo(function(t1: {[any]: any}) -- line: 22
	-- upvalues: useRoactService (copy), RoactServiceTags (copy), useSduiContext (copy), AppPage (copy), React (copy), reportModalImpression (copy), sendModalImpressionEvent (copy), SduiComponent (copy)
	local v14 = useRoactService(RoactServiceTags.RoactNetworking)
	local v15 = useSduiContext({
		appPage = AppPage.Home,
		dataUpdatedTimestamp = os.time()
	})
	local modalId = t1.modalId
	local modalType = t1.modalType

	React.useEffect(function() -- line: 31
		-- upvalues: reportModalImpression (copy), v14 (copy), modalId (copy), modalType (copy), sendModalImpressionEvent (copy)
		reportModalImpression(v14, modalId, modalType)
		sendModalImpressionEvent(modalId, modalType)
	end, {})

	return React.createElement(SduiComponent, {
		debugName = "SduiModal",
		componentConfig = t1.sduiComponentConfig,
		sduiContext = v15
	})
end)
