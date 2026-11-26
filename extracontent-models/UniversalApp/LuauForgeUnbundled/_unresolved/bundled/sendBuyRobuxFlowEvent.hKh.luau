local module = require("@luauforge/bundled/hIg")

local function sendBuyRobuxFlowEvent(p2, data)
	module.get(data.purchaseFlowUuid, p2).trackFlow(
		data.viewName,
		data.purchaseEventType,
		data.viewMessage,
		data.eventMetadata
	)
end

return sendBuyRobuxFlowEvent
