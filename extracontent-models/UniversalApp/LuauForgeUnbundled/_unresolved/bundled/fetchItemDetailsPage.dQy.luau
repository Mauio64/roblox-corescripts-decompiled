local module = require("@luauforge/bundled/dQw")
local sduiResponseType = module.SduiResponseType
local getSduiApiStore = module.getSduiApiStore
local sduiApiStorePostConfigContentType = module.SduiApiStorePostConfigContentType
local avatarScreen = require("@luauforge/bundled/dQv").Enums.AvatarScreen

local module2 = require("@luauforge/bundled/dQz")
local module3 = require("@luauforge/bundled/dQC")
local normalizeScreenSizeForWire = require("@luauforge/bundled/dQD").Utils.normalizeScreenSizeForWire

local function fetchItemDetailsPage(data, p2, p3)
	local marketplace_item_details_page = require("@luauforge/bundled/dQE").apppageplatform.marketplacecatalog.marketplace_item_details_page

	local marketplaceItemDetailsPageRequest = marketplace_item_details_page.MarketplaceItemDetailsPageRequest
	local v5 = marketplaceItemDetailsPageRequest.new({
		item_id = data.itemId,
		item_type = data.itemType,
		screen_size = normalizeScreenSizeForWire(data.screenSize),
		entry_context = data.entryContext
	})

	local v6 = p3 ~= nil and p3.forceRefresh == true
	getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.ProtobufJson,
		url = module2(),
		surfaceKey = avatarScreen.ItemDetails,
		configKey = module3(data.itemType, data.itemId, data.screenSize, data.entryContext),
		loadTimer = p2,
		apiProto = marketplace_item_details_page.MarketplaceItemDetailsPageResponse,
		postConfig = {
			body = v5,
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = marketplaceItemDetailsPageRequest
		}
	}, v6)
end

return fetchItemDetailsPage
