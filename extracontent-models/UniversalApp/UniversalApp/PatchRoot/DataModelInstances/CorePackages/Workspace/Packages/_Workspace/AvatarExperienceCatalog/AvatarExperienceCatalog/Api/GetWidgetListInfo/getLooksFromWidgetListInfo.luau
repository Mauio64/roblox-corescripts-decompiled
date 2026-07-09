local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local normalizeWidgetListInfoResponseToWidgetListInfo = require(script.Parent.normalizeWidgetListInfoResponseToWidgetListInfo)
local constants = require(script.Parent.constants)

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local makeAXResponseHandler = require(AvatarExperienceCatalog.Utils.makeAXResponseHandler)

require(AvatarExperienceCatalogParent.AvatarExperienceCommon)

local FFlagAXAvatarTabLooksYouMayAlsoLike = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXAvatarTabLooksYouMayAlsoLike

local function getLooksFromWidgetListInfo(p1: ((...any) -> ...any), s1: string, s2: string?, p2, s3: string?) -- line: 22
	-- upvalues: FFlagAXAvatarTabLooksYouMayAlsoLike (copy), Url (copy), makeAXResponseHandler (copy), normalizeWidgetListInfoResponseToWidgetListInfo (copy), constants (copy)
	local s4 = "avatarTab"

	if p2 and p2.LooksWidgetContextForOrganicContent then
		s4 = p2.LooksWidgetContextForOrganicContent
	end

	if FFlagAXAvatarTabLooksYouMayAlsoLike and s3 then
		s4 = s3
	end

	local v15 = Url:makeQueryString({
		query = s2,
		context = s4,
		requestId = s1
	})
	local v16, v17 = p1(`{ Url.APIS_URL }marketplace-widgets/v1/widgets?{ v15 }`, "GET")

	return makeAXResponseHandler(v16, normalizeWidgetListInfoResponseToWidgetListInfo, {
		modelMismatchCounter = constants.FETCH_WIDGET_INFO_MODEL_MISMATCH_COUNTER_NAME,
		latencyCounter = constants.FETCH_WIDGET_INFO_LATENCY_COUNTER_NAME
	}), v17
end

return getLooksFromWidgetListInfo
