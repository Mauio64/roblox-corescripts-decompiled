local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Promise = require(Parent.Promise)

require(Parent.LuauPolyfill)

local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local AvatarScreen = require(Parent.AvatarExperienceNavigation).Enums.AvatarScreen
local FFlagAXFetchCatalogPageReturnsPromise = require(Parent.AvatarExperienceFlags).FFlagAXFetchCatalogPageReturnsPromise
local getCatalogPageUrl = require(script.Parent.Utils.getCatalogPageUrl)
local getCatalogConfigKey = require(script.Parent.Utils.getCatalogConfigKey)
local normalizeScreenSizeForWire = require(script.Parent.Utils.normalizeScreenSizeForWire)

local function fetchCatalogPage(t1: {[any]: any}, p1, t2: {[any]: any}?) -- line: 36
	-- upvalues: Parent (copy), normalizeScreenSizeForWire (copy), getSduiApiStore (copy), SduiResponseType (copy), getCatalogPageUrl (copy), AvatarScreen (copy), getCatalogConfigKey (copy), SduiApiStorePostConfigContentType (copy), FFlagAXFetchCatalogPageReturnsPromise (copy), Promise (copy)
	local marketplace_catalog_page = require(Parent.ServiceContractsProto).apppageplatform.marketplacecatalog.marketplace_catalog_page
	local v17 = table.clone(t1)

	v17.screenSize = normalizeScreenSizeForWire(t1.screenSize)

	local v18 = t2 ~= nil and t2.forceRefresh == true
	local v19 = getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = getCatalogPageUrl(),
		surfaceKey = AvatarScreen.Catalog,
		configKey = getCatalogConfigKey(v17.context, v17.screenSize),
		loadTimer = p1,
		apiProto = marketplace_catalog_page.MarketplaceCatalogPageResponse,
		postConfig = {
			body = v17,
			contentType = SduiApiStorePostConfigContentType.Json
		}
	}, v18)

	if FFlagAXFetchCatalogPageReturnsPromise then
		return v19 or Promise.resolve()
	end

	return nil
end

return fetchCatalogPage
