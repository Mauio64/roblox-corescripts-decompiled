require("@luauforge/bundled/hwV")

local module = require("@luauforge/bundled/hwC")
local module2 = require("@luauforge/bundled/hwU")

local function SduiOpenSendRobuxAction(p2, p3, p4)
	module2().set(module.PageScopeFieldSendRobuxSheetOpen, true)
end

return SduiOpenSendRobuxAction
