local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local t = require(Parent.t)
local AppPage = require(Parent.RobloxAppEnums).AppPage
local mutedError = require(Parent.Loggers).mutedError
local v5 = t.strictInterface({
	sortPos = t.number,
	sortId = t.string,
	absPositions = t.string,
	queryTexts = t.string,
	componentType = t.string
})
local t1 = {
	[AppPage.SearchLandingPage] = v5
}

return function(p1, p2, p3) -- line: 20
	-- upvalues: t1 (copy), mutedError (copy)
	local v10 = t1[p2]

	if v10 then
		local v11, v12 = v10(p3)

		if not v11 then
			mutedError(v12)
		end
	else
		mutedError(string.format("Missing interface for eventContext %s to type check queryImpressions event parameters", p2))
	end

	p1:sendEventDeferred(p2, "queryImpressions", p3)
end
