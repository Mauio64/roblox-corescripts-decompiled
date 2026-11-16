local module = require("@luauforge/bundled/hwQ")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")
local module3 = require("@luauforge/bundled/hwG")

local module4 = require("@luauforge/bundled/hwC")
local module5 = require("@luauforge/bundled/hwH")
local module6 = require("@luauforge/bundled/hxe")

local module7 = require("@luauforge/bundled/hxm")

local module8 = require("@luauforge/bundled/hxR")

local module9 = require("@luauforge/bundled/hxT")
local module10 = require("@luauforge/bundled/hxV")
local module11 = require("@luauforge/bundled/hxK")
require("@luauforge/bundled/hxt")
local module12 = require("@luauforge/bundled/hwU")

local pageScopeFieldPurchaseDialog = module4.PageScopeFieldPurchaseDialog

local function PurchaseWarningsHost()
	local v5 = module12()
	local v6 = module3.useSignalState(v5.getSignal(pageScopeFieldPurchaseDialog))

	React.useEffect(function()
		return function()
			v5.set(pageScopeFieldPurchaseDialog, nil)
		end
	end, { v5 })

	local v7 = React.useCallback(function()
		v5.set(pageScopeFieldPurchaseDialog, nil)
	end, { v5 })

	local v8 = React.useCallback(function()
		module5.trackCounter("FirstTimePurchaseConsentDismiss")
		v5.set(pageScopeFieldPurchaseDialog, nil)
	end, { v5 })

	local v9 = React.useCallback(function()
		if v6 == nil or v6.kind == "disabled" or v6.kind == "redirectError" then
			return
		end

		v5.set(pageScopeFieldPurchaseDialog, nil)

		if v6.kind ~= "consent" then
			module10(v6.action):andThen(function()
				module5.trackCounter("PurchaseWarningAcknowledged")
			end, function(p2)
				module5.trackError("PurchaseWarningAcknowledgeFailed", nil, p2)
			end):andThen(v6.continuePurchase)
			return
		end

		module5.trackCounter("FirstTimePurchaseConsentConfirmed")
		local localPlayerUserId = module.DataHydrationUtils.getLocalPlayerUserId()

		if localPlayerUserId ~= nil then
			module11.markAcknowledged(localPlayerUserId)
		end

		v6.continuePurchase()
	end, { v5, v6 })

	if v6 == nil then
		return nil
	end

	if v6.kind == "consent" then
		return React.createElement(module6, { onConfirm = v9, onCancel = v8 })
	end

	if v6.kind == "warning" then
		return React.createElement(module8, {
			action = v6.action,
			onConfirm = v9,
			onCancel = v7
		})
	end

	if v6.kind == "redirectError" then
		return React.createElement(module9, { onClose = v7 })
	end

	if v6.kind == "disabled" then
		return React.createElement(module7, {
			action = v6.action,
			onClose = v7,
			tracking = v6.tracking
		})
	end

	return nil
end

return PurchaseWarningsHost
