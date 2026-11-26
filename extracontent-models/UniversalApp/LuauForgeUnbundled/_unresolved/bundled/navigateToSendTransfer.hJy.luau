local module = require("@luauforge/bundled/hII")
local module2 = require("@luauforge/bundled/hHP")

local appPage = require("@luauforge/bundled/hHo").AppPage

local module3 = require("@luauforge/bundled/hHB")
local module4 = require("@luauforge/bundled/hJo")

local function navigateToSendTransfer(p2, p3)
	local v5 = {
		name = appPage.TransferRobuxFlow,
		extraProps = {
			direction = "send",
			recipientUserId = p2,
			transferOrigination = module4.TransferOrigination
		}
	}

	if module then
		module2.trackCounter("SendTransferDeepLink")
	end

	module3.navigateDown(v5, p3)
end

return navigateToSendTransfer
