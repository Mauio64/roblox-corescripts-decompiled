local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local normalizeWidgetListInfoResponseToWidgetListInfo = require(script.Parent.normalizeWidgetListInfoResponseToWidgetListInfo)
local constants = require(script.Parent.constants)

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)

local WidgetListBreakPointSizeMap = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointSizeMap)
local FFlagAXPassScreenSizeToWidgetApi = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXPassScreenSizeToWidgetApi

local function getWidgetListInfo(p1: ((...any) -> ...any), s1: string, s2: string?, p2) -- line: 22
	-- upvalues: Url (copy), FFlagAXPassScreenSizeToWidgetApi (copy), WidgetListBreakPointSizeMap (copy), makeAXResponseHandler (copy), normalizeWidgetListInfoResponseToWidgetListInfo (copy), constants (copy)
	local v14 = Url:makeQueryString({
		requestId = s1,
		context = s2,
		screenSize = if not FFlagAXPassScreenSizeToWidgetApi or not p2 then nil else WidgetListBreakPointSizeMap[p2]
	})
	local v15, v16 = p1(`{ Url.APIS_URL }marketplace-widgets/v1/widgets?{ v14 }`, "GET")

	return makeAXResponseHandler(v15, normalizeWidgetListInfoResponseToWidgetListInfo, {
		modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
		latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
	}), v16
end

return getWidgetListInfo
