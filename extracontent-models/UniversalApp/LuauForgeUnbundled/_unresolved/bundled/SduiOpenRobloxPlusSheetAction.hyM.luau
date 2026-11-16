local appPage = require("@luauforge/bundled/hwj").AppPage
require("@luauforge/bundled/hwV")

local module = require("@luauforge/bundled/hwv")

local function SduiOpenRobloxPlusSheetAction(p2, p3, p4)
	module.navigateDown({ name = appPage.Blackbird }, p4.dependencies.dispatch)
end

return SduiOpenRobloxPlusSheetAction
