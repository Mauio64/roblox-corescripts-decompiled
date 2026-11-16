local module = require("@luauforge/bundled/hwV")
local sduiActionType = module.SduiActionType
local sduiErrorType = module.SduiErrors.SduiErrorType

local module2 = require("@luauforge/bundled/hwC")
local module3 = require("@luauforge/bundled/hwO")
local module4 = require("@luauforge/bundled/hwU")

local function SduiReviewTransferAction(p2, p3, p4)
	if #module3().transfers == 0 then
		p4.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = sduiActionType.ReviewTransfer,
				message = "The page has no pending transfers"
			},
			p4.appPage
		)
	else
		module4().set(module2.PageScopeFieldPendingTransfersSheetOpen, true)
	end
end

return SduiReviewTransferAction
