require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData
local experimentOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/experimentOverride")
local v5 = fFlagBuildExperienceModelPickerData and experimentOverride.isEnabled()

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchPreviewSpecs = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/PreviewSpecs/fetchPreviewSpecs")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/PreviewSpecs/PreviewSpecsTypes")

local function createPreviewSpecsStore(options)
	local v6 = options or {}
	local v7 = { network = v6.network, baseUrl = v6.baseUrl }

	local v9 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return fetchPreviewSpecs(v7)
		end
	})
	local v10

	if v5 then
		local count = 0
		v10 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SignalsUtils").createSessionScopedSignal(function()
			count += 1
			return `preview-specs:{count}`
		end)
	else
		v10 = function(p2): string
			return "preview-specs"
		end
	end

	return {
		getCachedPreviewSpecs = function(p2)
			return (v9.getCachedItem(v10(p2)))
		end,
		getAndFetchPreviewSpecs = function(p2)
			return (v9.getAndFetchItem(v10(p2)))
		end,
		refreshPreviewSpecs = function()
			if not v5 then
				v9.clear()
			end

			return (v9.fetchItem(v10(false)))
		end,
		clear = v9.clear,
		dispose = v9.dispose
	}
end

return createPreviewSpecsStore
