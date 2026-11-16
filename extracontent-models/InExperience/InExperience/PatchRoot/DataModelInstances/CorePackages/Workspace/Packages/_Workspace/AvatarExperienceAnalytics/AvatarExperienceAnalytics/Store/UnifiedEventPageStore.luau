local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local NavigationRodux = require(parent.NavigationRodux)
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local sendAXCounterV2 = require(script.Parent.Parent.sendAXCounterV2)

local v = nil

local function fallbackPageName()
	local success, result = pcall(function()
		return GetLegacyNavigationStore(false).getCurrentLegacyRoute(false)
	end)

	if success and result ~= nil and #result ~= 0 then
		return result[#result].name
	end

	return nil
end

local UnifiedEventPageStore = {}
UnifiedEventPageStore.UNKNOWN = "Unknown"
UnifiedEventPageStore.UNREGISTERED = "Unregistered"

function UnifiedEventPageStore.setPageProvider(callback)
	v = callback
end

function UnifiedEventPageStore.getPageFields()
	local v2 = v

	if v2 ~= nil then
		local success, result, v3 = pcall(v2)

		if success then
			if result ~= nil then
				return {
					navigationPage = result,
					navigationOpaquePage = v3 or "Unknown"
				}
			end
		else
			sendAXCounterV2("UnifiedEventPageResolutionFailed", { Source = "provider" })
		end
	end

	local success, result = pcall(function()
		return GetLegacyNavigationStore(false).getCurrentLegacyRoute(false)
	end)
	local name

	if success and result ~= nil and #result ~= 0 then
		name = result[#result].name
	end

	if name == nil then
		return { navigationPage = "Unknown", navigationOpaquePage = "Unknown" }
	end

	return {
		navigationPage = name,
		navigationOpaquePage = v2 == nil and "Unregistered" or "Unknown"
	}
end

return UnifiedEventPageStore
