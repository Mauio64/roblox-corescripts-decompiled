local module = require("@luauforge/bundled/hxv")
local module2 = require("@luauforge/bundled/hwH")

local appPage = require("@luauforge/bundled/hwj").AppPage

local module3 = require("@luauforge/bundled/hwv")
local module4 = require("@luauforge/bundled/hyb")

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
