local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").Enums.AvatarScreen

local fFlagAXFetchCatalogPageReturnsPromise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXFetchCatalogPageReturnsPromise

local getCatalogPageUrl = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogPageUrl")
local getCatalogConfigKey = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogConfigKey")
local normalizeScreenSizeForWire = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Utils.normalizeScreenSizeForWire

local function fetchCatalogPage(p2, p3, p4)
	local marketplace_catalog_page = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/ServiceContractsProto").apppageplatform.marketplacecatalog.marketplace_catalog_page

	local clone = table.clone(p2)
	clone.screenSize = normalizeScreenSizeForWire(p2.screenSize)

	local v5 = not (p4 == nil) and p4.forceRefresh == true
	local ifNeeded = getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = getCatalogPageUrl(),
		surfaceKey = avatarScreen.Catalog,
		configKey = getCatalogConfigKey(clone.context, clone.screenSize),
		loadTimer = p3,
		apiProto = marketplace_catalog_page.MarketplaceCatalogPageResponse,
		postConfig = {
			body = clone,
			contentType = sduiApiStorePostConfigContentType.Json
		}
	}, v5)

	if fFlagAXFetchCatalogPageReturnsPromise then
		return ifNeeded or Promise.resolve()
	end

	return nil
end

return fetchCatalogPage
