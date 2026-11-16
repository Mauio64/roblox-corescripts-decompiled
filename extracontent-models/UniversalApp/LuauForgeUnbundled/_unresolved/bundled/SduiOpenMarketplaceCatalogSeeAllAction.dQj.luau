local module = require("@luauforge/bundled/dPR")

local module2 = require("@luauforge/bundled/dQa")
local sduiActionType = module2.SduiActionType
local sduiErrorType = module2.SduiErrors.SduiErrorType

local function readOptionalString(value)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function SduiOpenMarketplaceCatalogSeeAllAction(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenMarketplaceCatalogSeeAll,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local sortId = actionParams.sortId

	if typeof(sortId) ~= "string" or sortId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenMarketplaceCatalogSeeAll,
				message = `Invalid or missing sortId: {sortId}`
			},
			p4.appPage
		)
		return
	end

	local requestFocusedSort = module.requestFocusedSort

	local title = actionParams.title

	if typeof(title) ~= "string" or title == "" then
		title = nil
	end

	local description = actionParams.description

	if typeof(description) ~= "string" or description == "" then
		description = nil
	end

	local tooltipText = actionParams.tooltipText

	if typeof(tooltipText) ~= "string" or tooltipText == "" then
		tooltipText = nil
	end

	requestFocusedSort({
		sortId = sortId,
		title = title,
		description = description,
		tooltipText = tooltipText
	})
end

return SduiOpenMarketplaceCatalogSeeAllAction
