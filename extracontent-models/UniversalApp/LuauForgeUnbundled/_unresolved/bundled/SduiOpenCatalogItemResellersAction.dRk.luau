local itemDetailsSduiHost = require("@luauforge/bundled/dQp").ItemDetailsSduiHost

local sduiActionType = require("@luauforge/bundled/dQa").SduiActionType

local module = require("@luauforge/bundled/dQR")

local openCatalogItemResellers = sduiActionType.OpenCatalogItemResellers

local function SduiOpenCatalogItemResellersAction(p2, p3, p4, p5)
	local actionParams = module.readActionParams(openCatalogItemResellers, p2, p4)

	if actionParams == nil then
		return
	end

	local catalogItem = module.readCatalogItem(openCatalogItemResellers, actionParams, p4)

	if catalogItem == nil then
		return
	end

	local v5 = itemDetailsSduiHost.get(p4.configKey)
	local openCatalogItemResellers2 = if v5 then v5.openCatalogItemResellers else nil

	if openCatalogItemResellers2 == nil then
		module.reportFailedToExecute(
			openCatalogItemResellers,
			p4,
			"No Item Details page that offers this control is mounted for this configKey"
		)
	else
		openCatalogItemResellers2({
			itemId = catalogItem.itemId,
			itemType = catalogItem.itemType,
			collectibleItemId = module.readOptionalId(actionParams.collectibleItemId)
		})
	end
end

return SduiOpenCatalogItemResellersAction
