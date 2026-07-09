local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local makeActionCreator = require(Parent.Rodux).makeActionCreator
local mutedError = require(Parent.Loggers).mutedError

return makeActionCreator(script.Name, function(p1) -- line: 8
	-- upvalues: AppPage (copy), mutedError (copy)
	if AppPage[p1] == nil then
		mutedError("SetPageSessionTimestamp action expects page to be a valid page type, %s is not in AppPage", p1)
	end

	return {
		page = p1,
		timestamp = tick()
	}
end)
