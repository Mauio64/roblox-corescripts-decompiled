local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local normalizeWidgetListInfoResponseToWidgetListInfo = require(script.Parent.normalizeWidgetListInfoResponseToWidgetListInfo)
local constants = require(script.Parent.constants)
require(AvatarExperienceCatalog.Models.WidgetListInfo)
local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)

require(parent.AvatarExperienceCommon)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike

local function getLooksFromWidgetListInfo(callback, requestId: string, query: string?, p, p2: string?)
	local context = not (p and p.LooksWidgetContextForOrganicContent) and "avatarTab"
		or p.LooksWidgetContextForOrganicContent
	context = FFlagAXAvatarTabLooksYouMayAlsoLike and p2 or context
	local queryString = Url:makeQueryString({
		query = query,
		context = context,
		requestId = requestId
	})

	local v, v2 = callback(`{Url.APIS_URL}marketplace-widgets/v1/widgets?{queryString}`, "GET")

	return
		makeAXResponseHandler(v, normalizeWidgetListInfoResponseToWidgetListInfo, {
			modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
			latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
		}),
		v2
end

return getLooksFromWidgetListInfo
