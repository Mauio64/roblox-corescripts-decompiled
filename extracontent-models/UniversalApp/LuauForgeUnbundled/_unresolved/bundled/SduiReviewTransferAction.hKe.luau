local module = require("@luauforge/bundled/hId")
local sduiActionType = module.SduiActionType
local sduiErrorType = module.SduiErrors.SduiErrorType

local module2 = require("@luauforge/bundled/hHI")
local module3 = require("@luauforge/bundled/hHW")
local module4 = require("@luauforge/bundled/hIc")

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
