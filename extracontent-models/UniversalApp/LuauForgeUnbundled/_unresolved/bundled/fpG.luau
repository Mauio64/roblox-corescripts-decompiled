local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes

local module = require("@luauforge/bundled/fpH")
local module2 = require("@luauforge/bundled/fpJ")

return {
	Fetch = function(p2, p3, p4, p5)
		if p5 == searchTypes.Catalog then
			return module2.Fetch(p2, p3)
		end

		if
			p5 == searchTypes.Games
			or p5 == searchTypes.Auto
			or p5 == searchTypes.TopResults
			or p5 == searchTypes.Players
		then
			return module.Fetch(p2, p3, p4)
		end

		error(`Unrecognized search type for fetching autocomplete suggestions: {p5}`)
	end,
	GetFetchingStatus = function(p2, p3, p4)
		if p4 == searchTypes.Catalog then
			return module2.GetFetchingStatus(p2, p3)
		end

		if
			p4 == searchTypes.Games
			or p4 == searchTypes.Auto
			or p4 == searchTypes.TopResults
			or p4 == searchTypes.Players
		then
			return module.GetFetchingStatus(p2, p3)
		end

		error(`Unrecognized search type for fetching status for autocomplete suggestions: {p4}`)
	end
}
