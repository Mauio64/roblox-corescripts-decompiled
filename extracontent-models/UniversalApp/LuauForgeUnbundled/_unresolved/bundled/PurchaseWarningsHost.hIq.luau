local module = require("@luauforge/bundled/hHY")
local module2 = require("@luauforge/bundled/hHu")
local module3 = require("@luauforge/bundled/hHO")

local module4 = require("@luauforge/bundled/hHI")
local module5 = require("@luauforge/bundled/hHP")
local module6 = require("@luauforge/bundled/hHL")
local module7 = require("@luauforge/bundled/hIr")

local module8 = require("@luauforge/bundled/hIz")

local module9 = require("@luauforge/bundled/hJe")

local module10 = require("@luauforge/bundled/hJg")
local module11 = require("@luauforge/bundled/hJi")
local module12 = require("@luauforge/bundled/hIJ")
local module13 = require("@luauforge/bundled/hIX")
require("@luauforge/bundled/hIG")
local module14 = require("@luauforge/bundled/hIc")

local pageScopeFieldPurchaseDialog = module4.PageScopeFieldPurchaseDialog

local function PurchaseWarningsHost()
	local v5 = module14()
	local v6 = module3.useSignalState(v5.getSignal(pageScopeFieldPurchaseDialog))

	module2.useEffect(function()
		return function()
			v5.set(pageScopeFieldPurchaseDialog, nil)
		end
	end, { v5 })

	local v7 = module2.useCallback(function()
		v5.set(pageScopeFieldPurchaseDialog, nil)
	end, { v5 })

	local v8 = module2.useCallback(function()
		module5.trackCounter("FirstTimePurchaseConsentDismiss")
		v5.set(pageScopeFieldPurchaseDialog, nil)
	end, { v5 })

	local v9 = module2.useCallback(function()
		if v6 == nil or v6.kind == "disabled" or v6.kind == "redirectError" then
			return
		end

		v5.set(pageScopeFieldPurchaseDialog, nil)

		if v6.kind == "consent" then
			module5.trackCounter("FirstTimePurchaseConsentConfirmed")
			local localPlayerUserId = module.DataHydrationUtils.getLocalPlayerUserId()

			if localPlayerUserId ~= nil then
				module13.markAcknowledged(localPlayerUserId)
			end

			v6.continuePurchase()
		else
			local v10 = v6.continuePurchase
			local fn

			if module6 then
				local v11 = module12()

				if v11 then
					v10 = function()
						v11()
						v6.continuePurchase()
					end

					fn = function(p2)
						v11()
					end
				end
			end

			module11(v6.action):andThen(function()
				module5.trackCounter("PurchaseWarningAcknowledged")
			end, function(p2)
				module5.trackError("PurchaseWarningAcknowledgeFailed", nil, p2)
			end):andThen(v10, fn)
		end
	end, { v5, v6 })

	if v6 == nil then
		return nil
	end

	if v6.kind == "consent" then
		return module2.createElement(module7, { onConfirm = v9, onCancel = v8 })
	end

	if v6.kind == "warning" then
		return module2.createElement(module9, {
			action = v6.action,
			onConfirm = v9,
			onCancel = v7
		})
	end

	if v6.kind == "redirectError" then
		return module2.createElement(module10, { onClose = v7 })
	end

	if v6.kind == "disabled" then
		return module2.createElement(module8, {
			action = v6.action,
			onClose = v7,
			tracking = v6.tracking
		})
	end

	return nil
end

return PurchaseWarningsHost
