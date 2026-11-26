require("@luauforge/bundled/hId")

local module = require("@luauforge/bundled/hHI")
local module2 = require("@luauforge/bundled/hIc")

local function SduiOpenSendRobuxAction(p2, p3, p4)
	module2().set(module.PageScopeFieldSendRobuxSheetOpen, true)
end

return SduiOpenSendRobuxAction
