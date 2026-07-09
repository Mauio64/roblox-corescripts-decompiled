local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local normalizeWidgetListInfoResponseToWidgetListInfo = require(script.Parent.normalizeWidgetListInfoResponseToWidgetListInfo)
local constants = require(script.Parent.constants)

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)

local function getWidgetListInfoSearch(p1: ((...any) -> ...any), s1: string, s2: string) -- line: 16
	-- upvalues: Url (copy), makeAXResponseHandler (copy), normalizeWidgetListInfoResponseToWidgetListInfo (copy), constants (copy)
	local v11 = Url:makeQueryString({
		requestId = s1,
		query = s2
	})
	local v12, v13 = p1(`{ Url.APIS_URL }marketplace-widgets/v1/widgets/search?{ v11 }`, "GET")

	return makeAXResponseHandler(v12, normalizeWidgetListInfoResponseToWidgetListInfo, {
		modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
		latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
	}), v13
end

return getWidgetListInfoSearch
