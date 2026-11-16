local module = require("@luauforge/bundled/dQl")

local module2 = require("@luauforge/bundled/dQa")
local sduiActionType = module2.SduiActionType
local sduiErrorType = module2.SduiErrors.SduiErrorType

local function SduiSelectMarketplaceFavoritesSubcategoryAction(p2, p3, p4, p5)
	local actionParams = if p2 and p2.actionParams then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceFavoritesSubcategory,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local subcategoryId = actionParams.subcategoryId

	if typeof(subcategoryId) == "string" and subcategoryId ~= "" then
		module.setFromL2(subcategoryId)
	else
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SelectMarketplaceFavoritesSubcategory,
				message = `Invalid or missing subcategoryId: {subcategoryId}`
			},
			p4.appPage
		)
	end
end

return SduiSelectMarketplaceFavoritesSubcategoryAction
