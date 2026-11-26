local appPage = require("@luauforge/bundled/hHo").AppPage

local module = require("@luauforge/bundled/hHB")

local function navigateToReceiveTransfer(p2, p3)
	local v5 = {
		name = appPage.TransferRobuxFlow,
		extraProps = { direction = "receive", transferId = `RXT-{p2}` }
	}

	module.navigateDown(v5, p3)
end

return navigateToReceiveTransfer
