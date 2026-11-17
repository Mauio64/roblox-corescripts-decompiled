local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local Context = require(AmpV2Wizard.OdpVerification.Context)
local Types = require(AmpV2Wizard.OdpVerification.Types)
local resolveVerificationPresentation = require(AmpV2Wizard.OdpVerification.resolveVerificationPresentation)
local VerificationDiagnostics = require(AmpV2Wizard.OdpVerification.VerificationDiagnostics)
local FFlagAmpV2WizardVerificationDiagnostics = require(AmpV2Wizard.FFlagAmpV2WizardVerificationDiagnostics)

local verificationPresentation = resolveVerificationPresentation.VerificationPresentation

local VendorFailure = Types.VendorFailure
local VendorOutcome = Types.VendorOutcome

local function useOdpVerification(data)
	local v = React.useContext(Context)

	local v2 = useAppPolicy(function(p)
		return p.getHasWebViewSupportForFAE()
	end)

	local ref = React.useRef(data.onSettled)
	ref.current = data.onSettled

	React.useEffect(function()
		local api = v.api
		local personaInquiryService = v.personaInquiryService
		local openWebView = v.openWebView
		local externalBrowser = v.externalBrowser

		local verificationPresentation2 = resolveVerificationPresentation.resolveVerificationPresentation(
			personaInquiryService.isAvailable(),
			v2 == true
		)

		local flag = false
		local v3 = false
		local v4 = nil
		local v5 = nil
		local v6 = "start_request"
		local v7 = nil
		local now = nil
		local v8 = nil
		local v9 = nil

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
				v5 = result
			end
		end

		local function settle(outcome, failure)
			if v3 or flag then
				return
			end

			v3 = true
			local v10 = { outcome = outcome, failure = failure }

			if FFlagAmpV2WizardVerificationDiagnostics and outcome == VendorOutcome.Failed and v5 then
				local success, result = pcall(VerificationDiagnostics.completeFailure, v5, v6, v7, now, v8, v9)

				if success then
					v10.diagnostic = result
				end
			end

			ref.current(v10)
		end

		local function startNative(sessionIdentifier: string)
			if FFlagAmpV2WizardVerificationDiagnostics then
				v7 = sessionIdentifier
				now = os.clock()
				v6 = "inquiry_invocation"
			end

			personaInquiryService.startInquiry(sessionIdentifier):andThen(function(p)
				local v10

				if FFlagAmpV2WizardVerificationDiagnostics then
					if typeof(p) == "table" then
						v10 = p.resultType
						v9 = p.debugMessage
					else
						v10 = p
					end

					v8 = v10
					v6 = "native_result"
				else
					v10 = p
				end

				if v10 == Enum.FacialAgeEstimationResultType.Complete then
					settle(VendorOutcome.Submitted)
				elseif v10 == Enum.FacialAgeEstimationResultType.Cancel then
					settle(VendorOutcome.Cancelled)
				else
					settle(VendorOutcome.Failed, VendorFailure.VendorError)
				end
			end):catch(function(p)
				if FFlagAmpV2WizardVerificationDiagnostics then
					v6 = "inquiry_rejection"
					v9 = p
				end

				settle(VendorOutcome.Failed, VendorFailure.VendorError)
			end)
		end

		api.startOdpVerification({ sessionId = data.sessionId, verificationType = data.method }):andThen(function(p)
			if flag then
				return
			end

			if FFlagAmpV2WizardVerificationDiagnostics then
				v6 = "start_response"
				v7 = p.sessionIdentifier
			end

			if verificationPresentation2 == verificationPresentation.Native then
				if p.sessionIdentifier ~= nil then
					startNative(p.sessionIdentifier)
					return
				end

				if FFlagAmpV2WizardVerificationDiagnostics then
					v6 = "missing_inquiry_id"
				end

				settle(VendorOutcome.Failed, VendorFailure.StartFailed)
			elseif p.verificationLink == nil then
				if FFlagAmpV2WizardVerificationDiagnostics then
					v6 = "missing_verification_link"
				end

				settle(VendorOutcome.Failed, VendorFailure.StartFailed)
			elseif verificationPresentation2 == verificationPresentation.InAppWebView then
				if FFlagAmpV2WizardVerificationDiagnostics then
					v6 = "webview_presentation"
				end

				v4 = openWebView(p.verificationLink, "", function()
					settle(VendorOutcome.Submitted)
				end)
			else
				if FFlagAmpV2WizardVerificationDiagnostics then
					v6 = "external_presentation"
				end

				externalBrowser.open(p.verificationLink)
				settle(VendorOutcome.Submitted)
			end
		end):catch(function(p)
			if FFlagAmpV2WizardVerificationDiagnostics then
				v9 = p
			end

			settle(VendorOutcome.Failed, VendorFailure.StartFailed)
		end)

		return function()
			flag = true

			if v4 then
				v4()
			end
		end
	end, { data.sessionId, data.method, v2 })
end

return useOdpVerification
