local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")

local view = Foundation.View
local loading = Foundation.Loading
local iconSize = Foundation.Enums.IconSize

local function SchoolsLoadingShell(p2)
	return module.createElement(
		view,
		{ tag = "col align-x-center align-y-center size-full", testId = p2.testId },
		{
			Spinner = module.createElement(loading, { size = iconSize.Large })
		}
	)
end

return SchoolsLoadingShell
