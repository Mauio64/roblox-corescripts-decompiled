local ServerDrivenUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerDrivenUi")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppEnums")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local reportModalImpression = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportModalImpression")
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactServiceTags")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppHooks").useRoactService

local appPage = RobloxAppEnums.AppPage
local useSduiContext = ServerDrivenUi.useSduiContext
local sduiComponent = ServerDrivenUi.SduiComponent

return React.memo(function(props)
	local v5 = useRoactService(RoactServiceTags.RoactNetworking)
	local v6 = useSduiContext({
		appPage = appPage.Home,
		dataUpdatedTimestamp = os.time()
	})

	local modalId = props.modalId
	local modalType = props.modalType

	React.useEffect(function()
		reportModalImpression(v5, modalId, modalType)
		sendModalImpressionEvent(modalId, modalType)
	end, {})

	return React.createElement(sduiComponent, {
		debugName = "SduiModal",
		componentConfig = props.sduiComponentConfig,
		sduiContext = v6
	})
end)
