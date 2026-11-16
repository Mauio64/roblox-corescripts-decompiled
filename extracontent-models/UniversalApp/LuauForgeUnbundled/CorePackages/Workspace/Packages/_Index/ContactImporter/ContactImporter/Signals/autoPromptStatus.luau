local status = nil
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/AppCommonLib").Signal.new()

return {
	getStatus = function()
		return status
	end,
	setStatus = function(p2)
		status = p2
		v5:fire(p2)
	end,
	statusChanged = v5
}
