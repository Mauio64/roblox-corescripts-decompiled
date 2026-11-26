local module = require("@luauforge/bundled/dTB")
local module2 = require("@luauforge/bundled/dTC")

local module3 = require("@luauforge/bundled/dTq")
local sduiActionType = module3.SduiActionType
local sduiErrorType = module3.SduiErrors.SduiErrorType

local function SduiSelectMarketplaceFavoritesCategoryAction(p2, p3, p4, p5)
	local actionParams = if p2 and p2.actionParams then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceFavoritesCategory,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local categoryId = actionParams.categoryId

	if typeof(categoryId) ~= "string" or categoryId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceFavoritesCategory,
				message = `Invalid or missing categoryId: {categoryId}`
			},
			p4.appPage
		)
		return
	end

	local defaultLeafId = module2.resolveDefaultLeafId(categoryId)
	module.setFromL1(categoryId, defaultLeafId)
end

return SduiSelectMarketplaceFavoritesCategoryAction
