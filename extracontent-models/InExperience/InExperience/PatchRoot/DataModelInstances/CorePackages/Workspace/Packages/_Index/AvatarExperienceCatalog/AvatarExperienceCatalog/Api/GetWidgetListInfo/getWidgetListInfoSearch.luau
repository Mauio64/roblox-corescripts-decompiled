local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local normalizeWidgetListInfoResponseToWidgetListInfo = require(script.Parent.normalizeWidgetListInfoResponseToWidgetListInfo)
local constants = require(script.Parent.constants)
require(AvatarExperienceCatalog.Models.WidgetListInfo)
local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)

local function getWidgetListInfoSearch(callback, requestId: string, query: string)
	local queryString = Url:makeQueryString({ requestId = requestId, query = query })

	local v, v2 = callback(`{Url.APIS_URL}marketplace-widgets/v1/widgets/search?{queryString}`, "GET")

	return
		makeAXResponseHandler(v, normalizeWidgetListInfoResponseToWidgetListInfo, {
			modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
		}),
		v2
end

return getWidgetListInfoSearch
