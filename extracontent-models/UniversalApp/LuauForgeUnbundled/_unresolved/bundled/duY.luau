local module = require("@luauforge/bundled/drj")
local appPage = require("@luauforge/bundled/drn").AppPage
local mutedError = require("@luauforge/bundled/dru").mutedError

local strictInterface = module.strictInterface({
	sortPos = module.number,
	sortId = module.string,
	absPositions = module.string,
	queryTexts = module.string,
	componentType = module.string
})

local strictInterfacesBySearchLandingPage = {
	[appPage.SearchLandingPage] = strictInterface
}

return function(object, p2, p3)
	local v5 = strictInterfacesBySearchLandingPage[p2]

	if v5 then
		local v6, v7 = v5(p3)

		if not v6 then
			mutedError(v7)
		end
	else
		mutedError(string.format(
			"Missing interface for eventContext %s to type check queryImpressions event parameters",
			p2
		))
	end

	object:sendEventDeferred(p2, "queryImpressions", p3)
end
