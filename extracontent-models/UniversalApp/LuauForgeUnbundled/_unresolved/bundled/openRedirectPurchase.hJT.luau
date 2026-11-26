local module = require("@luauforge/bundled/hHY")
local module2 = require("@luauforge/bundled/hIP")
local module3 = require("@luauforge/bundled/hId")
local sduiErrorType = module3.SduiErrors.SduiErrorType

local module4 = require("@luauforge/bundled/hIg")
local module5 = require("@luauforge/bundled/hHI")
local module6 = require("@luauforge/bundled/hHP")
local module7 = require("@luauforge/bundled/hJU")
local module8 = require("@luauforge/bundled/hIJ")
local module9 = require("@luauforge/bundled/hIK")
require("@luauforge/bundled/hIi")
local module10 = require("@luauforge/bundled/hJV")
local module11 = require("@luauforge/bundled/hIc")
local module12 = require("@luauforge/bundled/hJS")
local module13 = require("@luauforge/bundled/hJW")

local function openRedirectPurchase(p2, p3, p4, p5)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	local v5 = module9()

	local function fail(p6)
		p4.dependencies.logger.reportError(
			sduiErrorType.FailedToOpenLink,
			{ name = "BuyRobuxRedirectPurchase", message = p6 },
			p4.appPage
		)

		if v5() then
			module11().set(module5.PageScopeFieldPurchaseDialog, {
				kind = "redirectError"
			})
		end
	end

	local actionTelemetryFieldValue = module3.getActionTelemetryFieldValue(
		p2,
		p3,
		module5.PurchaseFlowUuidField,
		nil
	)

	local v6 = module8()

	if v6 == nil then
		return
	end

	local v7

	if typeof(actionTelemetryFieldValue) == "string" and actionTelemetryFieldValue ~= "" then
		v7 = module4.get(actionTelemetryFieldValue, p4.dependencies.eventIngest)

		if p5.kind == "package" then
			module13.trackRedirectClickTime(v7)
		end
	end

	local localPlayerUserId = module.DataHydrationUtils.getLocalPlayerUserId()
	local v8 = module12()

	if localPlayerUserId == nil or v8 == nil then
		module6.trackCounter("PurchaseRedirectUrlEmpty")
		v6()
		fail(localPlayerUserId == nil and "No signed-in user" or "No payment session")
	else
		module13.trackRedirectClick(v7, p5)
		module6.trackCounter("MobileRedirectUrlGenerationStarted")
		module10():catch(function(p6)
			module6.trackError("MobileRedirectUrlGenerationFailed", nil, p6)
			return module2.reject(p6)
		end):andThen(function(p6)
			if not v5() then
				return nil
			end

			local v9 = module7({
				ticket = p6,
				paymentSessionId = v8,
				purchaseFlowUuid = actionTelemetryFieldValue,
				userId = localPlayerUserId,
				product = p5,
				startTimeMs = unixTimestampMillis
			})

			return module2.resolve(p4.dependencies.linkingProtocol:openURL(v9)):andThen(function(p7)
				if p7 == false then
					return module2.reject("The browser didn't open the link")
				end

				return nil
			end)
		end):catch(function(p6)
			local v11 = if typeof(p6) == "table" then p6.errorMessage else tostring(p6)
			fail(`Redirect purchase failed: {v11}`)
		end):finally(v6)
	end
end

return openRedirectPurchase
