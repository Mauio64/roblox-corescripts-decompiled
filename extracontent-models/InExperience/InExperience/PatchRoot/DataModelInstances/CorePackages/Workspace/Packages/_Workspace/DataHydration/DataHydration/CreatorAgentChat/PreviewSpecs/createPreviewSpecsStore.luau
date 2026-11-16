local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)
require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local experimentOverride = require(script.Parent.Parent.experimentOverride)
local v = FFlagBuildExperienceModelPickerData and experimentOverride.isEnabled()

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchPreviewSpecs = require(script.Parent.fetchPreviewSpecs)
require(script.Parent.PreviewSpecsTypes)

local function createPreviewSpecsStore(options)
	local v2 = options or {}
	local v3 = { network = v2.network, baseUrl = v2.baseUrl }

	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_: string, _)
			return fetchPreviewSpecs(v3)
		end
	})
	local v4

	if v then
		local count = 0
		local SignalsUtils = require(parent.SignalsUtils)
		v4 = SignalsUtils.createSessionScopedSignal(function()
			count += 1
			return `preview-specs:{count}`
		end)
	else
		v4 = function(_): string
			return "preview-specs"
		end
	end

	return {
		getCachedPreviewSpecs = function(p)
			return (dataResolver.getCachedItem(v4(p)))
		end,
		getAndFetchPreviewSpecs = function(p)
			return (dataResolver.getAndFetchItem(v4(p)))
		end,
		refreshPreviewSpecs = function()
			if not v then
				dataResolver.clear()
			end

			return (dataResolver.fetchItem(v4(false)))
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createPreviewSpecsStore
