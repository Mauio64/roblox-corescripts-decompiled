local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local normalizeWidgetListInfoResponseToWidgetListInfo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/normalizeWidgetListInfoResponseToWidgetListInfo")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/constants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")
local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")

local function getWidgetListInfoSearch(callback, p2, p3)
	local queryString = url:makeQueryString({ requestId = p2, query = p3 })

	local v5, v6 = callback(`{url.APIS_URL}marketplace-widgets/v1/widgets/search?{queryString}`, "GET")

	return
		makeAXResponseHandler(v5, normalizeWidgetListInfoResponseToWidgetListInfo, {
			modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
		}),
		v6
end

return getWidgetListInfoSearch
