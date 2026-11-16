local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PageSessionRodux/RobloxAppEnums").AppPage
local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/PageSessionRodux/Rodux").makeActionCreator
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PageSessionRodux/Loggers").mutedError

return makeActionCreator("SetPageSessionTimestamp", function(p2)
	if appPage[p2] == nil then
		mutedError(
			"SetPageSessionTimestamp action expects page to be a valid page type, %s is not in AppPage",
			p2
		)
	end

	return { page = p2, timestamp = tick() }
end)
