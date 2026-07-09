local CorePackages = game:GetService("CorePackages")
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)

return {
	getEdpStoreKey = function(s1: string) -- line: 9
		-- upvalues: RobloxAppEnums (copy)
		return `{ RobloxAppEnums.AppPage.ExperienceDetail }_{ s1 }`
	end,
	getUnprocessedEdpStoreKey = function(s2: string) -- line: 4
		-- upvalues: RobloxAppEnums (copy)
		return `{ RobloxAppEnums.AppPage.ExperienceDetail }_{ s2 }_unprocessed`
	end,
	checkEdpDataStaleness = function(n1: number?, n2: number) -- line: 14
		local v7 = n2 * 1000

		if not n1 or n1 <= 0 then
			return true
		end

		return v7 < tick() * 1000 - n1
	end
}
