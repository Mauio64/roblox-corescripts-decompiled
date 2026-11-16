local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")

return {
	getEdpStoreKey = function(p2)
		return `{module.AppPage.ExperienceDetail}_{p2}`
	end,
	getUnprocessedEdpStoreKey = function(p2)
		return `{module.AppPage.ExperienceDetail}_{p2}_unprocessed`
	end,
	checkEdpDataStaleness = function(p2, p3): boolean
		local v5 = p3 * 1000

		if p2 and not (p2 <= 0) then
			return v5 < tick() * 1000 - p2
		end

		return true
	end
}
