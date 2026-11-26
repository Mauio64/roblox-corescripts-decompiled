local module = require("@luauforge/bundled/dul")
local appPage = require("@luauforge/bundled/dup").AppPage
local mutedError = require("@luauforge/bundled/duw").mutedError

local strictInterface = module.strictInterface({
	sortPos = module.number,
	sortId = module.string,
	pos = module.number,
	queryText = module.string,
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
			"Missing interface for eventContext %s to type check querySuggestionClicked event parameters",
			p2
		))
	end

	object:sendEventDeferred(p2, "querySuggestionClicked", p3)
end
