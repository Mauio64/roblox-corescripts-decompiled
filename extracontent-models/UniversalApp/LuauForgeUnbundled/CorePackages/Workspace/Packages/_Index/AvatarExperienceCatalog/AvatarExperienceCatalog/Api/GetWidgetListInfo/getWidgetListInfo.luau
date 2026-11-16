local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local normalizeWidgetListInfoResponseToWidgetListInfo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/normalizeWidgetListInfoResponseToWidgetListInfo")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/constants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")
local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")
local WidgetListBreakPointSizeMap = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointSizeMap")
local fFlagAXPassScreenSizeToWidgetApi = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXPassScreenSizeToWidgetApi

local function getWidgetListInfo(callback, p2, p3, p4)
	local v7 = if fFlagAXPassScreenSizeToWidgetApi and p4 then WidgetListBreakPointSizeMap[p4] else nil
	local queryString = url:makeQueryString({
		requestId = p2,
		context = p3,
		screenSize = v7
	})

	local v8, v9 = callback(`{url.APIS_URL}marketplace-widgets/v1/widgets?{queryString}`, "GET")

	return
		makeAXResponseHandler(v8, normalizeWidgetListInfoResponseToWidgetListInfo, {
			modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
		}),
		v9
end

return getWidgetListInfo
