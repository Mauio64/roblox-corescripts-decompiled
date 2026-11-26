local module = require("@luauforge/bundled/hHu")
local module2 = require("@luauforge/bundled/hHO")
local useDispatch = require("@luauforge/bundled/hHA").Hooks.RoactRodux.useDispatch

local module3 = require("@luauforge/bundled/hHI")
local module4 = require("@luauforge/bundled/hHP")

local module5 = require("@luauforge/bundled/hHR")
local module6 = require("@luauforge/bundled/hHW")
local module7 = require("@luauforge/bundled/hIb")
local module8 = require("@luauforge/bundled/hIc")
local module9 = require("@luauforge/bundled/hIe")
local module10 = require("@luauforge/bundled/hIf")

local pageScopeFieldPendingTransfersSheetOpen = module3.PageScopeFieldPendingTransfersSheetOpen
local viewName = module9.ViewName
local eventType = module9.EventType
local viewMessage = module9.ViewMessage

local function PendingTransfersSheetHost(p2)
	local v5 = useDispatch()
	local v6 = module8()
	local v7 = module2.useSignalState(v6.getSignal(pageScopeFieldPendingTransfersSheetOpen)) == true

	module.useEffect(function()
		return function()
			v6.set(pageScopeFieldPendingTransfersSheetOpen, false)
		end
	end, { v6 })

	local v8 = module.useMemo(function()
		if v7 then
			return (module6())
		end

		return nil
	end, { v7 })

	local purchaseFlowUuid = p2.purchaseFlowUuid

	module.useEffect(function()
		if v7 and purchaseFlowUuid then
			module10(purchaseFlowUuid).trackFlow(
				viewName.RobuxPendingTransfers,
				eventType.ViewShown,
				viewMessage.TransferPendingSheet
			)
		end
	end, { v7, purchaseFlowUuid })

	module.useEffect(function()
		if v7 then
			module4.trackCounter("TransferPendingSheetView")
		end
	end, { v7 })

	local v9 = module.useCallback(function(p3)
		v6.set(pageScopeFieldPendingTransfersSheetOpen, false)

		if p3 then
			if purchaseFlowUuid then
				module10(purchaseFlowUuid).trackFlow(
					viewName.RobuxPendingTransfers,
					eventType.UserInput,
					viewMessage.TransferPendingAcceptClick
				)
			end

			module4.trackCounter("TransferPendingAcceptClick")
			module7(p3, v5)
		end
	end, { v6, v5, purchaseFlowUuid })

	if v7 and v8 ~= nil then
		return module.createElement(module5, { pendingTransfers = v8, onClosed = v9 })
	end

	return nil
end

return PendingTransfersSheetHost
