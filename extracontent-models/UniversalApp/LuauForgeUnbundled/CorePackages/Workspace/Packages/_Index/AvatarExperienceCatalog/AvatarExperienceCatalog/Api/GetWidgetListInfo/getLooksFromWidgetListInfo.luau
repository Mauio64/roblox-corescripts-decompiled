local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local normalizeWidgetListInfoResponseToWidgetListInfo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/normalizeWidgetListInfoResponseToWidgetListInfo")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetWidgetListInfo/constants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")
local makeAXResponseHandler = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/makeAXResponseHandler")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")

local fFlagAXAvatarTabLooksYouMayAlsoLike = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXAvatarTabLooksYouMayAlsoLike

local function getLooksFromWidgetListInfo(callback, p2, p3, p4, p5)
	local v5 = not (p4 and p4.LooksWidgetContextForOrganicContent) and "avatarTab"
		or p4.LooksWidgetContextForOrganicContent
	v5 = fFlagAXAvatarTabLooksYouMayAlsoLike and p5 or v5
	local queryString = url:makeQueryString({ query = p3, context = v5, requestId = p2 })

	local v6, v7 = callback(`{url.APIS_URL}marketplace-widgets/v1/widgets?{queryString}`, "GET")

	return
		makeAXResponseHandler(v6, normalizeWidgetListInfoResponseToWidgetListInfo, {
			modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
		}),
		v7
end

return getLooksFromWidgetListInfo
