local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Promise = require(parent.Promise)
require(parent.LuauPolyfill)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXFetchCatalogPageReturnsPromise = AvatarExperienceFlags.FFlagAXFetchCatalogPageReturnsPromise

local getCatalogPageUrl = require(script.Parent.Utils.getCatalogPageUrl)
local getCatalogConfigKey = require(script.Parent.Utils.getCatalogConfigKey)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local normalizeScreenSizeForWire = AvatarExperienceCommon.Utils.normalizeScreenSizeForWire

local function fetchCatalogPage(p, loadTimer, p2)
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local marketplace_catalog_page = ServiceContractsProto.apppageplatform.marketplacecatalog.marketplace_catalog_page

	local clone = table.clone(p)
	clone.screenSize = normalizeScreenSizeForWire(p.screenSize)
	local v

	if p2 == nil then
		v = false
	else
		v = p2.forceRefresh == true
	end

	local ifNeeded = getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = getCatalogPageUrl(),
		surfaceKey = AvatarScreen.Catalog,
		configKey = getCatalogConfigKey(clone.context, clone.screenSize),
		loadTimer = loadTimer,
		apiProto = marketplace_catalog_page.MarketplaceCatalogPageResponse,
		postConfig = { body = clone, contentType = SduiApiStorePostConfigContentType.Json }
	}, v)

	if FFlagAXFetchCatalogPageReturnsPromise then
		return ifNeeded or Promise.resolve()
	end

	return nil
end

return fetchCatalogPage
