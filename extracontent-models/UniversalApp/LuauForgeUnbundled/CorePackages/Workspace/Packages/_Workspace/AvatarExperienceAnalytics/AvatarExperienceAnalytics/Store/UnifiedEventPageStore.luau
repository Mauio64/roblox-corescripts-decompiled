local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/NavigationRodux").GetLegacyNavigationStore
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2")

local v5 = nil

local function fallbackPageName()
	local success, result = pcall(function()
		return getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
	end)

	if success and result ~= nil and #result ~= 0 then
		return result[#result].name
	end

	return nil
end

return {
	UNKNOWN = "Unknown",
	UNREGISTERED = "Unregistered",
	setPageProvider = function(p2)
		v5 = p2
	end,
	getPageFields = function()
		local v6 = v5

		if v6 ~= nil then
			local success, result, v7 = pcall(v6)

			if success then
				if result ~= nil then
					return {
						navigationPage = result,
						navigationOpaquePage = v7 or "Unknown"
					}
				end
			else
				sendAXCounterV2("UnifiedEventPageResolutionFailed", { Source = "provider" })
			end
		end

		local success, result = pcall(function()
			return getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
		end)

		local name = if success and result ~= nil and #result ~= 0 then result[#result].name else nil

		if name == nil then
			return { navigationPage = "Unknown", navigationOpaquePage = "Unknown" }
		end

		return {
			navigationPage = name,
			navigationOpaquePage = v6 == nil and "Unregistered" or "Unknown"
		}
	end
}
