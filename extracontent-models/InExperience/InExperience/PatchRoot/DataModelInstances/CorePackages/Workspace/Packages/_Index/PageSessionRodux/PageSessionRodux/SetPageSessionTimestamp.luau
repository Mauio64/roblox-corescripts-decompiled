local parent = script:FindFirstAncestor("PageSessionRodux").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

return makeActionCreator(script.Name, function(page)
	if AppPage[page] == nil then
		mutedError("SetPageSessionTimestamp action expects page to be a valid page type, %s is not in AppPage", page)
	end

	return { page = page, timestamp = tick() }
end)
