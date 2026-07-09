local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)
local ApiFetchIAPPurchaseWarning = require(Modules.LuaApp.Thunks.ApiFetchIAPPurchaseWarning)
local ApiPostAckPurchaseWarning = require(Modules.LuaApp.Thunks.ApiPostAckPurchaseWarning)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local BuyRobuxFlow = IAPExperience.PurchaseFlow.BuyRobuxFlow
local BuyRobuxFlowState = IAPExperience.PurchaseFlow.BuyRobuxFlowState
local U13ConfirmType = IAPExperience.PurchaseFlow.U13ConfirmType
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType
local CheckUserPurchaseSettingsFailureReason = IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason
local EconomicRestrictionsViolationType = IAPExperience.Enums.EconomicRestrictionsViolationType
local mapCheckUserPurchaseSettingsFailureReasonToViolationType = IAPExperience.Utility.mapCheckUserPurchaseSettingsFailureReasonToViolationType
local NativePurchaseStatus = require(Modules.LuaApp.Enum.NativePurchaseStatus)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)

require(script.Parent.RobuxPackage)

local GetFFlagFixBuyRobuxNotChargedMessage = require(Modules.LuaApp.Flags.GetFFlagFixBuyRobuxNotChargedMessage)
local BuyRobuxCounter = require(script.Parent.Enum.BuyRobuxCounter)
local VPCModalType = require(script.Parent.Enum.VPCModalType)
local v21 = Roact.PureComponent:extend(script.Name)
local v22 = GuiService:IsTenFootInterface()
local PreparePaymentCheck = IAPExperience.PreparePaymentCheck
local GetEnableConsolePreparePaymentCheck = IAPExperience.GetEnableConsolePreparePaymentCheck

function v21.init(p1) -- line: 82
	-- upvalues: U13ConfirmType (copy), RetrievalStatus (copy), VPCModalType (copy), PurchaseErrorType (copy), BuyRobuxCounter (copy), GetEnableConsolePreparePaymentCheck (copy), PreparePaymentCheck (copy), Promise (copy)
	p1.selectedRobuxPackage = nil
	p1.resetState = p1.props.resetState or {
		economicRestrictionError = nil,
		purchaseWarningType = U13ConfirmType.None,
		purchaseWarningFetchingStatus = RetrievalStatus.NotStarted,
		purchaseWarningPostStatus = RetrievalStatus.NotStarted,
		purchaseVPCErrorType = VPCModalType.toRawValue(VPCModalType.None),
		purchaseVPCErrorFetchingStatus = RetrievalStatus.NotStarted,
		purchasePreCheckStatus = RetrievalStatus.NotStarted,
		purchaseErrorType = PurchaseErrorType.FailedRobuxPurchase
	}
	p1.state = {
		purchaseWarningType = p1.resetState.purchaseWarningType,
		purchaseWarningFetchingStatus = p1.resetState.purchaseWarningFetchingStatus,
		purchaseWarningPostStatus = p1.resetState.purchaseWarningPostStatus,
		purchaseVPCErrorType = p1.resetState.purchaseVPCErrorType,
		purchaseVPCErrorFetchingStatus = p1.resetState.purchaseVPCErrorFetchingStatus,
		purchasePreCheckStatus = p1.resetState.purchasePreCheckStatus,
		purchaseErrorType = p1.resetState.purchaseErrorType,
		economicRestrictionError = p1.resetState.economicRestrictionError
	}

	function p1.failFlow(_, p3) -- line: 108
		-- upvalues: p1 (copy), BuyRobuxCounter (copy)
		if p3 ~= nil then
			p1.sendCounter(p3)

			return
		end

		p1.sendCounter(BuyRobuxCounter.PurchaseFailed)
	end
	function p1.purchaseRobux(s1: string) -- line: 116
		-- upvalues: p1 (copy), GetEnableConsolePreparePaymentCheck (copy), PreparePaymentCheck (copy), RetrievalStatus (copy), Promise (copy)
		p1:setState(p1.resetState)
		p1.props.endPurchase()

		if GetEnableConsolePreparePaymentCheck() and not PreparePaymentCheck(s1) then
			p1:setState({
				purchasePreCheckStatus = RetrievalStatus.Failed
			}, nil)

			return
		end

		p1.selectedRobuxPackage = s1
		p1:setState({
			purchaseVPCErrorFetchingStatus = RetrievalStatus.Fetching
		})
		p1:dispatchCheckUserPurchaseSettings():andThen(function(p4) -- line: 130
			-- upvalues: Promise (copy), p1 (copy), RetrievalStatus (copy)
			if not p4 then
				return Promise.resolve()
			end

			p1:setState({
				purchaseVPCErrorFetchingStatus = RetrievalStatus.Done
			})
			p1:setState({
				purchaseWarningFetchingStatus = RetrievalStatus.Fetching
			})
			p1:dispatchFetchPurchaseWarning():andThen(function(b1: boolean) -- line: 137
				-- upvalues: p1 (copy), RetrievalStatus (copy)
				p1:setState({
					purchaseWarningFetchingStatus = RetrievalStatus.Done
				})

				if not b1 then
					p1:promptRobuxPurchase()
				end
			end):catch(function() -- line: 145
				-- upvalues: p1 (copy), RetrievalStatus (copy)
				p1.failFlow({
					purchaseWarningFetchingStatus = RetrievalStatus.Failed
				}, nil)
			end)
		end)
	end
	function p1.acceptPurchaseWarning() -- line: 151
		-- upvalues: p1 (copy), RetrievalStatus (copy)
		p1:setState({
			purchaseWarningPostStatus = RetrievalStatus.Done
		})
		p1:dispatchPostAckPurchaseWarning()
		p1:promptRobuxPurchase()
	end
	function p1.cancelPurchase() -- line: 158
		-- upvalues: p1 (copy), BuyRobuxCounter (copy)
		p1.sendCounter(BuyRobuxCounter.PurchaseCanceled)
		p1.endPurchase()
	end
	function p1.endPurchase() -- line: 163
		-- upvalues: p1 (copy)
		p1.selectedRobuxPackage = nil
		p1:setState(p1.resetState)
		p1.props.endPurchase()
	end
	function p1.sendAnalyticEvent(s2: string, t1: {[any]: any}) -- line: 169
		-- upvalues: p1 (copy)
		p1.props.sendAnalyticEvent(p1.props.eventPrefix .. "BuyRobux", s2, t1)
	end
	function p1.sendCounter(p5) -- line: 173
		-- upvalues: p1 (copy), BuyRobuxCounter (copy)
		p1.props.sendCounter(BuyRobuxCounter.toRawValue(p5))
	end
	function p1.getProductId(p6) -- line: 177
		-- upvalues: p1 (copy)
		for _, v50 in p1.props.robuxPackages do
			if p6 == v50.packageId then
				return v50.productId
			end
		end

		return nil
	end
end
function v21.dispatchFetchPurchaseWarning(p7) -- line: 187
	-- upvalues: ApiFetchIAPPurchaseWarning (copy), BuyRobuxCounter (copy), U13ConfirmType (copy), Promise (copy)
	return p7.props.dispatchFetchIAPPurchaseWarning(p7.selectedRobuxPackage, p7.getProductId(p7.selectedRobuxPackage)):andThen(function(p8) -- line: 192
		-- upvalues: ApiFetchIAPPurchaseWarning (copy), p7 (copy), BuyRobuxCounter (copy), U13ConfirmType (copy), Promise (copy)
		local v52 = true

		if p8 == ApiFetchIAPPurchaseWarning.ResponseType.U13PaymentModal then
			p7.sendCounter(BuyRobuxCounter.ShowU13PaymentModal)
			p7:setState({
				purchaseWarningType = U13ConfirmType.U13PaymentModal
			})
		elseif p8 == ApiFetchIAPPurchaseWarning.ResponseType.U13MonthlyThreshold1Modal then
			p7.sendCounter(BuyRobuxCounter.ShowU13MonthlyThreshold1Modal)
			p7:setState({
				purchaseWarningType = U13ConfirmType.U13MonthlyThreshold1Modal
			})
		elseif p8 == ApiFetchIAPPurchaseWarning.ResponseType.U13MonthlyThreshold2Modal then
			p7.sendCounter(BuyRobuxCounter.ShownU13MonthlyThreshold2Modal)
			p7:setState({
				purchaseWarningType = U13ConfirmType.U13MonthlyThreshold2Modal
			})
		elseif p8 == ApiFetchIAPPurchaseWarning.ResponseType.ParentalConsentWarningPaymentModal13To17 then
			p7.sendCounter(BuyRobuxCounter.ShownParentalConsentWarningPaymentModal13To17)
			p7:setState({
				purchaseWarningType = U13ConfirmType.ParentalConsentWarningPaymentModal13To17
			})
		else
			v52 = false
		end

		return Promise.resolve(v52)
	end)
end
function v21.dispatchCheckUserPurchaseSettings(p9) -- line: 213
	-- upvalues: mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), Promise (copy), CheckUserPurchaseSettingsFailureReason (copy), BuyRobuxCounter (copy), VPCModalType (copy), PurchaseErrorType (copy), RetrievalStatus (copy)
	return p9.props.dispatchCheckUserPurchaseSettings():andThen(function(p10) -- line: 218
		-- upvalues: mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), Promise (copy), CheckUserPurchaseSettingsFailureReason (copy), p9 (copy), BuyRobuxCounter (copy), VPCModalType (copy), PurchaseErrorType (copy)
		if p10 == nil then
			error("Result from check-user-purchase-settings is nil")
		end

		local v54 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(p10.failureReason)
		local v55 = p10.isEligible == nil or p10.failureReason == nil
		local v56 = v54 ~= EconomicRestrictionsViolationType.None and p10.expirationTimeInMinutes ~= nil

		if v55 and not v56 then
			error("Invalid response from check-user-purchase-settings")
		end

		if p10.isEligible then
			return Promise.resolve(true)
		end

		if p10.failureReason == CheckUserPurchaseSettingsFailureReason.PurchaseNotEnabled then
			p9.sendCounter(BuyRobuxCounter.ShowPurchaseNotEnabledModal)
			p9:setState({
				purchaseVPCErrorType = VPCModalType.toRawValue(VPCModalType.EnablePurchase)
			})

			return Promise.resolve(false)
		end

		if v56 then
			p9.sendCounter(BuyRobuxCounter.ShowEconomicRestrictionModal)
			p9:setState({
				purchaseErrorType = PurchaseErrorType.EconomicRestriction,
				economicRestrictionError = {
					timeoutMinutes = p10.expirationTimeInMinutes,
					violationType = v54
				}
			})

			return Promise.resolve(false)
		end

		error("User is not eligible for purchases with unknown failure reason")
	end):catch(function(_) -- line: 261
		-- upvalues: p9 (copy), RetrievalStatus (copy), Promise (copy)
		p9:setState({
			purchaseVPCErrorFetchingStatus = RetrievalStatus.Failed
		})

		return Promise.resolve(false)
	end)
end
function v21.dispatchPostAckPurchaseWarning(p12) -- line: 267
	-- upvalues: ApiPostAckPurchaseWarning (copy), U13ConfirmType (copy), BuyRobuxCounter (copy)
	local props = p12.props
	local state = p12.state
	local None = ApiPostAckPurchaseWarning.UserActionType.None

	if state.purchaseWarningType == U13ConfirmType.U13PaymentModal then
		p12.sendCounter(BuyRobuxCounter.ConfirmU13PaymentModal)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedU13PaymentModal
	elseif state.purchaseWarningType == U13ConfirmType.U13MonthlyThreshold1Modal then
		p12.sendCounter(BuyRobuxCounter.ConfirmU13MonthlyThreshold1Modal)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedU13MonthlyThreshold1Modal
	elseif state.purchaseWarningType == U13ConfirmType.U13MonthlyThreshold2Modal then
		p12.sendCounter(BuyRobuxCounter.ConfirmU13MonthlyThreshold2Modal)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedU13MonthlyThreshold2Modal
	elseif state.purchaseWarningType == U13ConfirmType.ParentalConsentWarningPaymentModal13To17 then
		p12.sendCounter(BuyRobuxCounter.ConfirmParentalConsentWarningPaymentModal13To17)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedParentalConsentWarningPaymentModal13To17
	end

	return props.dispatchPostAckPurchaseWarning(None)
end
function v21.promptRobuxPurchase(p13) -- line: 290
	p13.props.promptRobux(p13.props.networking, p13.selectedRobuxPackage, p13.getProductId(p13.selectedRobuxPackage))
end
function v21.getFlowState(p14) -- line: 296
	-- upvalues: VPCModalType (copy), BuyRobuxFlowState (copy), RetrievalStatus (copy), PurchaseErrorType (copy), U13ConfirmType (copy), NativePurchaseStatus (copy), GetFFlagFixBuyRobuxNotChargedMessage (copy)
	local state = p14.state
	local props = p14.props

	if state.purchaseVPCErrorType ~= nil and state.purchaseVPCErrorType ~= VPCModalType.toRawValue(VPCModalType.None) then
		return BuyRobuxFlowState.PurchaseVPC
	end

	if state.purchaseVPCErrorFetchingStatus == RetrievalStatus.Failed then
		return BuyRobuxFlowState.Error
	end

	if state.purchaseErrorType == PurchaseErrorType.EconomicRestriction then
		return BuyRobuxFlowState.Error
	end

	if state.purchasePreCheckStatus == RetrievalStatus.Failed then
		return BuyRobuxFlowState.Error
	end

	if props.iapProductsFetchingStatus ~= RetrievalStatus.Done then
		return BuyRobuxFlowState.Loading
	end

	if props.nativeProductsFetchingStatus ~= RetrievalStatus.Done then
		return BuyRobuxFlowState.Loading
	end

	if state.purchaseWarningFetchingStatus == RetrievalStatus.NotStarted or state.purchaseVPCErrorFetchingStatus == RetrievalStatus.NotStarted then
		return BuyRobuxFlowState.BuyRobux
	end

	if state.purchaseWarningFetchingStatus ~= RetrievalStatus.Done and state.purchaseVPCErrorFetchingStatus ~= RetrievalStatus.Done then
		return BuyRobuxFlowState.Loading
	end

	if state.purchaseWarningType ~= U13ConfirmType.None and state.purchaseWarningPostStatus == RetrievalStatus.NotStarted then
		return BuyRobuxFlowState.PurchaseWarning
	end

	if props.iapPurchase.nativeProductId == nil or props.iapPurchase.purchaseStatus == NativePurchaseStatus.Pending then
		return BuyRobuxFlowState.RobuxPurchasePending
	end

	if props.iapPurchase.purchaseStatus == NativePurchaseStatus.Polling then
		return BuyRobuxFlowState.RobuxGrantPending
	end

	if props.iapPurchase.purchaseStatus == NativePurchaseStatus.Failed or GetFFlagFixBuyRobuxNotChargedMessage() and props.iapPurchase.purchaseStatus == NativePurchaseStatus.RobuxPollingFailedAfterNativePurchase then
		return BuyRobuxFlowState.Error
	end

	if props.iapPurchase.purchaseStatus == NativePurchaseStatus.Success then
		return BuyRobuxFlowState.Succeed
	end

	return BuyRobuxFlowState.BuyRobux
end
function v21.getErrorType(p15) -- line: 380
	-- upvalues: NativePurchaseStatus (copy), PurchaseErrorType (copy)
	local props = p15.props
	local state = p15.state

	if props.iapPurchase and props.iapPurchase.purchaseStatus == NativePurchaseStatus.RobuxPollingFailedAfterNativePurchase then
		return PurchaseErrorType.FailedGrant
	end

	return state.purchaseErrorType
end
function v21.render(p16) -- line: 394
	-- upvalues: Roact (copy), BuyRobuxFlow (copy), v22 (copy), GetFFlagFixBuyRobuxNotChargedMessage (copy)
	local props = p16.props
	local state = p16.state

	return Roact.createElement(BuyRobuxFlow, {
		shouldAnimate = true,
		screenSize = props.screenSize,
		isConsoleSize = v22,
		showBackground = not v22,
		showCloseButton = not v22,
		analyticId = props.analyticId,
		robuxBalance = props.robuxBalance,
		robuxPackages = props.robuxPackages,
		purchaseState = p16:getFlowState(),
		purchaseVPCType = state.purchaseVPCErrorType,
		errorType = if not GetFFlagFixBuyRobuxNotChargedMessage() then state.purchaseErrorType else p16:getErrorType(),
		economicRestrictionError = state.economicRestrictionError,
		u13ConfirmType = p16.state.purchaseWarningType,
		purchaseRobux = p16.purchaseRobux,
		acceptPurchaseWarning = p16.acceptPurchaseWarning,
		cancelPurchase = p16.cancelPurchase,
		flowComplete = p16.endPurchase,
		onAnalyticEvent = p16.sendAnalyticEvent,
		eventPrefix = props.eventPrefix,
		onPageClose = props.onPageClose,
		dispatchCentralOverlay = props.dispatchCentralOverlay
	})
end

return v21
