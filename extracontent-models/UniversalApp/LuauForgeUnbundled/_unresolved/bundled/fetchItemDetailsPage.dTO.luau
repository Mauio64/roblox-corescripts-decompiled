local module = require("@luauforge/bundled/dTM")
local sduiResponseType = module.SduiResponseType
local getSduiApiStore = module.getSduiApiStore
local sduiApiStorePostConfigContentType = module.SduiApiStorePostConfigContentType
local avatarScreen = require("@luauforge/bundled/dTL").Enums.AvatarScreen

local module2 = require("@luauforge/bundled/dTP")
local module3 = require("@luauforge/bundled/dTS")
local normalizeScreenSizeForWire = require("@luauforge/bundled/dTT").Utils.normalizeScreenSizeForWire

local function fetchItemDetailsPage(data, p2, p3)
	local marketplace_item_details_page = require("@luauforge/bundled/dTU").apppageplatform.marketplacecatalog.marketplace_item_details_page

	local clone = table.clone(data)
	clone.screenSize = normalizeScreenSizeForWire(data.screenSize)

	local v5 = p3 ~= nil and p3.forceRefresh == true
	getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = module2(),
		surfaceKey = avatarScreen.ItemDetails,
		configKey = module3(data.itemType, data.itemId, data.screenSize, data.entryContext),
		loadTimer = p2,
		apiProto = marketplace_item_details_page.MarketplaceItemDetailsPageResponse,
		postConfig = {
			body = clone,
			contentType = sduiApiStorePostConfigContentType.Json
		}
	}, v5)
end

return fetchItemDetailsPage
