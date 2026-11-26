local module = require("@luauforge/bundled/hHu")
local module2 = require("@luauforge/bundled/hHO")
local useDispatch = require("@luauforge/bundled/hHA").Hooks.RoactRodux.useDispatch

local module3 = require("@luauforge/bundled/hHI")
local module4 = require("@luauforge/bundled/hHP")
local module5 = require("@luauforge/bundled/hJk")
require("@luauforge/bundled/hJp")
local module6 = require("@luauforge/bundled/hJy")
local module7 = require("@luauforge/bundled/hJr")
local module8 = require("@luauforge/bundled/hIc")
local module9 = require("@luauforge/bundled/hIe")
local module10 = require("@luauforge/bundled/hIf")

local pageScopeFieldSendRobuxSheetOpen = module3.PageScopeFieldSendRobuxSheetOpen
local viewName = module9.ViewName
local eventType = module9.EventType
local viewMessage = module9.ViewMessage

local function SendRobuxSheetHost(p2)
	local v5 = module7()
	local v6 = useDispatch()

	local v7 = module8()
	local v8 = module2.useSignalState(v7.getSignal(pageScopeFieldSendRobuxSheetOpen)) == true

	module.useEffect(function()
		return function()
			v7.set(pageScopeFieldSendRobuxSheetOpen, nil)
		end
	end, { v7 })

	local purchaseFlowUuid = p2.purchaseFlowUuid

	module.useEffect(function()
		if v8 and purchaseFlowUuid then
			module10(purchaseFlowUuid).trackFlow(
				viewName.RobuxSendTransfers,
				eventType.ViewShown,
				viewMessage.TransferSendSheet
			)
		end
	end, { v8, purchaseFlowUuid })

	module.useEffect(function()
		if v8 then
			module4.trackCounter("TransferSendSheetView")
		end
	end, { v8 })

	local v9 = module.useCallback(function(p3, p4)
		v7.set(pageScopeFieldSendRobuxSheetOpen, nil)

		if p3 then
			if purchaseFlowUuid then
				module10(purchaseFlowUuid).trackFlow(
					viewName.RobuxSendTransfers,
					eventType.UserInput,
					viewMessage.TransferSendUserSelected
				)
			end

			if p4 then
				module4.trackCounter("TransferSendUserSelected", { source = p4 })
			end

			module6(p3, v6)
		end
	end, { v7, v6, purchaseFlowUuid })

	if v8 then
		return module.createElement(module5, { friends = v5, onClosed = v9 })
	end

	return nil
end

return SendRobuxSheetHost
