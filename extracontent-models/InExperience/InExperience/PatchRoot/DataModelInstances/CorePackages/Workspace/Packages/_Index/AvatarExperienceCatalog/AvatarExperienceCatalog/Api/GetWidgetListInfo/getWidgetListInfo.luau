local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local normalizeWidgetListInfoResponseToWidgetListInfo = require(script.Parent.normalizeWidgetListInfoResponseToWidgetListInfo)
local constants = require(script.Parent.constants)
require(AvatarExperienceCatalog.Models.WidgetListInfo)
local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)
local WidgetListBreakPointSizeMap = require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointSizeMap)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local FFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi

local function getWidgetListInfo(callback, requestId: string, context: string?, p)
	local screenSize

	if FFlagAXPassScreenSizeToWidgetApi and p then
		screenSize = WidgetListBreakPointSizeMap[p]
	end

	local queryString = Url:makeQueryString({
		requestId = requestId,
		context = context,
		screenSize = screenSize
	})

	local v, v2 = callback(`{Url.APIS_URL}marketplace-widgets/v1/widgets?{queryString}`, "GET")

	return
		makeAXResponseHandler(v, normalizeWidgetListInfoResponseToWidgetListInfo, {
			modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
		}),
		v2
end

return getWidgetListInfo
