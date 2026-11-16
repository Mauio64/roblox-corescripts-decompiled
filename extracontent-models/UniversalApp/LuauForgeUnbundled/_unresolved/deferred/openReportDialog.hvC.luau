local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local function openReportDialog(p2)
	return function(object)
		local v5 = { name = module.ReportDialog, reportData = p2 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(module2(v5))
		end
	end
end

return openReportDialog
