local itemDetailsSduiHost = require("@luauforge/bundled/dQp").ItemDetailsSduiHost

local sduiActionType = require("@luauforge/bundled/dQa").SduiActionType

local module = require("@luauforge/bundled/dQR")

local openCatalogItemOwnership = sduiActionType.OpenCatalogItemOwnership

local function SduiOpenCatalogItemOwnershipAction(p2, p3, p4, p5)
	local actionParams = module.readActionParams(openCatalogItemOwnership, p2, p4)

	if actionParams == nil then
		return
	end

	local catalogItem = module.readCatalogItem(openCatalogItemOwnership, actionParams, p4)

	if catalogItem == nil then
		return
	end

	local v5 = itemDetailsSduiHost.get(p4.configKey)
	local openCatalogItemOwnership2 = if v5 then v5.openCatalogItemOwnership else nil

	if openCatalogItemOwnership2 == nil then
		module.reportFailedToExecute(
			openCatalogItemOwnership,
			p4,
			"No Item Details page that offers this control is mounted for this configKey"
		)
	else
		openCatalogItemOwnership2({
			itemId = catalogItem.itemId,
			itemType = catalogItem.itemType,
			collectibleItemId = module.readOptionalId(actionParams.collectibleItemId)
		})
	end
end

return SduiOpenCatalogItemOwnershipAction
