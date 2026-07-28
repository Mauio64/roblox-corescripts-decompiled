require(script.Parent.Parent.Parent.Parent.proto)

local marketplace_catalog_page = require(script.marketplace_catalog_page)
local marketplace_offer_modal_page = require(script.marketplace_offer_modal_page)

return {
	marketplace_catalog_page = marketplace_catalog_page,
	marketplace_offer_modal_page = marketplace_offer_modal_page
}
