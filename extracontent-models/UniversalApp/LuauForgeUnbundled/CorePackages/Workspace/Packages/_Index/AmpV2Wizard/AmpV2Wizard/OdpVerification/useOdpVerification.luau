local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/UniversalAppPolicy").useAppPolicy

local Context = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/Context")
local Types = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/Types")
local resolveVerificationPresentation = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/resolveVerificationPresentation")
local VerificationDiagnostics = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpVerification/VerificationDiagnostics")
local FFlagAmpV2WizardVerificationDiagnostics = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardVerificationDiagnostics")

local verificationPresentation = resolveVerificationPresentation.VerificationPresentation

local vendorFailure = Types.VendorFailure
local vendorOutcome = Types.VendorOutcome

local function useOdpVerification(data)
	local v5 = React.useContext(Context)

	local v6 = useAppPolicy(function(p2)
		return p2.getHasWebViewSupportForFAE()
	end)

	local ref = React.useRef(data.onSettled)
	ref.current = data.onSettled

	React.useEffect(function()
		local api = v5.api
		local personaInquiryService = v5.personaInquiryService
		local openWebView = v5.openWebView
		local externalBrowser = v5.externalBrowser

		local verificationPresentation2 = resolveVerificationPresentation.resolveVerificationPresentation(
			personaInquiryService.isAvailable(),
			v6 == true
		)

		local flag = false
		local v7 = false
		local v8 = nil
		local v9 = nil
		local v10 = "start_request"
		local v11 = nil
		local now = nil
		local v12 = nil
		local v13 = nil

		if FFlagAmpV2WizardVerificationDiagnostics then
			local success, result = pcall(
				VerificationDiagnostics.beginAttempt,
				data.sessionId,
				data.method,
				verificationPresentation2,
				data.flowId,
				data.analyticsSessionId
			)

			if success then
				v9 = result
			end
		end

		local function settle(p2, p3)
			if v7 or flag then
				return
			end

			v7 = true
			local v14 = { outcome = p2, failure = p3 }

			if FFlagAmpV2WizardVerificationDiagnostics and p2 == vendorOutcome.Failed and v9 then
				local success, result = pcall(VerificationDiagnostics.completeFailure, v9, v10, v11, now, v12, v13)

				if success then
					v14.diagnostic = result
				end
			end

			ref.current(v14)
		end

		local function startNative(sessionIdentifier)
			if FFlagAmpV2WizardVerificationDiagnostics then
				v11 = sessionIdentifier
				now = os.clock()
				v10 = "inquiry_invocation"
			end

			personaInquiryService.startInquiry(sessionIdentifier):andThen(function(p2)
				local v14

				if FFlagAmpV2WizardVerificationDiagnostics then
					if typeof(p2) == "table" then
						v14 = p2.resultType
						v13 = p2.debugMessage
					else
						v14 = p2
					end

					v12 = v14
					v10 = "native_result"
				else
					v14 = p2
				end

				if v14 == Enum.FacialAgeEstimationResultType.Complete then
					settle(vendorOutcome.Submitted)
				elseif v14 == Enum.FacialAgeEstimationResultType.Cancel then
					settle(vendorOutcome.Cancelled)
				else
					settle(vendorOutcome.Failed, vendorFailure.VendorError)
				end
			end):catch(function(p2)
				if FFlagAmpV2WizardVerificationDiagnostics then
					v10 = "inquiry_rejection"
					v13 = p2
				end

				settle(vendorOutcome.Failed, vendorFailure.VendorError)
			end)
		end

		api.startOdpVerification({
			sessionId = data.sessionId,
			verificationType = data.method
		}):andThen(function(p2)
			if flag then
				return
			end

			if FFlagAmpV2WizardVerificationDiagnostics then
				v10 = "start_response"
				v11 = p2.sessionIdentifier
			end

			if verificationPresentation2 == verificationPresentation.Native then
				if p2.sessionIdentifier ~= nil then
					startNative(p2.sessionIdentifier)
					return
				end

				if FFlagAmpV2WizardVerificationDiagnostics then
					v10 = "missing_inquiry_id"
				end

				settle(vendorOutcome.Failed, vendorFailure.StartFailed)
			elseif p2.verificationLink == nil then
				if FFlagAmpV2WizardVerificationDiagnostics then
					v10 = "missing_verification_link"
				end

				settle(vendorOutcome.Failed, vendorFailure.StartFailed)
			elseif verificationPresentation2 == verificationPresentation.InAppWebView then
				if FFlagAmpV2WizardVerificationDiagnostics then
					v10 = "webview_presentation"
				end

				v8 = openWebView(p2.verificationLink, "", function()
					settle(vendorOutcome.Submitted)
				end)
			else
				if FFlagAmpV2WizardVerificationDiagnostics then
					v10 = "external_presentation"
				end

				externalBrowser.open(p2.verificationLink)
				settle(vendorOutcome.Submitted)
			end
		end):catch(function(p2)
			if FFlagAmpV2WizardVerificationDiagnostics then
				v13 = p2
			end

			settle(vendorOutcome.Failed, vendorFailure.StartFailed)
		end)

		return function()
			flag = true

			if v8 then
				v8()
			end
		end
	end, { data.sessionId, data.method, v6 })
end

return useOdpVerification
