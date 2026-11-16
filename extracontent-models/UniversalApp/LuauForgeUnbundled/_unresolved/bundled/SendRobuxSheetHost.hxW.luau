local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")
local module2 = require("@luauforge/bundled/hwG")
local useDispatch = require("@luauforge/bundled/hwu").Hooks.RoactRodux.useDispatch

local module3 = require("@luauforge/bundled/hwC")
local module4 = require("@luauforge/bundled/hwH")
local module5 = require("@luauforge/bundled/hxX")
require("@luauforge/bundled/hyc")
local module6 = require("@luauforge/bundled/hyl")
local module7 = require("@luauforge/bundled/hye")
local module8 = require("@luauforge/bundled/hwU")
local module9 = require("@luauforge/bundled/hwW")
local module10 = require("@luauforge/bundled/hwX")

local pageScopeFieldSendRobuxSheetOpen = module3.PageScopeFieldSendRobuxSheetOpen
local viewName = module9.ViewName
local eventType = module9.EventType
local viewMessage = module9.ViewMessage

local function SendRobuxSheetHost(p2)
	local v5 = module7()
	local v6 = useDispatch()

	local v7 = module8()
	local v8 = module2.useSignalState(v7.getSignal(pageScopeFieldSendRobuxSheetOpen)) == true

	React.useEffect(function()
		return function()
			v7.set(pageScopeFieldSendRobuxSheetOpen, nil)
		end
	end, { v7 })

	local purchaseFlowUuid = p2.purchaseFlowUuid

	React.useEffect(function()
		if v8 and purchaseFlowUuid then
			module10(purchaseFlowUuid).trackFlow(
				viewName.RobuxSendTransfers,
				eventType.ViewShown,
				viewMessage.TransferSendSheet
			)
		end
	end, { v8, purchaseFlowUuid })

	React.useEffect(function()
		if v8 then
			module4.trackCounter("TransferSendSheetView")
		end
	end, { v8 })

	local v9 = React.useCallback(function(p3, p4)
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
		return React.createElement(module5, { friends = v5, onClosed = v9 })
	end

	return nil
end

return SendRobuxSheetHost
