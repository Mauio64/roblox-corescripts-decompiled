local appPage = require("@luauforge/bundled/hHo").AppPage
require("@luauforge/bundled/hId")

local module = require("@luauforge/bundled/hHB")

local function SduiOpenRobloxPlusSheetAction(p2, p3, p4)
	module.navigateDown({ name = appPage.Blackbird }, p4.dependencies.dispatch)
end

return SduiOpenRobloxPlusSheetAction
