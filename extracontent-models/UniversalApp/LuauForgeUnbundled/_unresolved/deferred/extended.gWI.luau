local CorePackages = game:GetService("CorePackages")

local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/deferred/gWJ")
local module2 = require("@luauforge/deferred/gWM")

local module3 = require("@luauforge/deferred/gKv")
local buyRobuxFlow = module3.PurchaseFlow.BuyRobuxFlow
local buyRobuxFlowState = module3.PurchaseFlow.BuyRobuxFlowState
local u13ConfirmType = module3.PurchaseFlow.U13ConfirmType
local purchaseErrorType = module3.PurchaseFlow.PurchaseErrorType
local checkUserPurchaseSettingsFailureReason = module3.Enums.CheckUserPurchaseSettingsFailureReason
local economicRestrictionsViolationType = module3.Enums.EconomicRestrictionsViolationType

local mapCheckUserPurchaseSettingsFailureReasonToViolationType = module3.Utility.mapCheckUserPurchaseSettingsFailureReasonToViolationType

local module4 = require("@luauforge/bundled/gIg")
local module5 = require("@luauforge/bundled/dAB")
require("@luauforge/deferred/gWx")
local module6 = require("@luauforge/bundled/gIo")

local module7 = require("@luauforge/deferred/gWO")
local module8 = require("@luauforge/deferred/gVz")

local extended = Roact.PureComponent:extend("BuyRobuxOverlay")
local tenFootInterface = isTenFootInterface()

local preparePaymentCheck = module3.PreparePaymentCheck
local getEnableConsolePreparePaymentCheck = module3.GetEnableConsolePreparePaymentCheck

function extended:init()
	self.selectedRobuxPackage = nil

	self.resetState = self.props.resetState or {
		purchaseWarningType = u13ConfirmType.None,
		purchaseWarningFetchingStatus = module5.NotStarted,
		purchaseWarningPostStatus = module5.NotStarted,
		purchaseVPCErrorType = module8.toRawValue(module8.None),
		purchaseVPCErrorFetchingStatus = module5.NotStarted,
		purchasePreCheckStatus = module5.NotStarted,
		purchaseErrorType = purchaseErrorType.FailedRobuxPurchase,
		economicRestrictionError = nil
	}

	self.state = {
		purchaseWarningType = self.resetState.purchaseWarningType,
		purchaseWarningFetchingStatus = self.resetState.purchaseWarningFetchingStatus,
		purchaseWarningPostStatus = self.resetState.purchaseWarningPostStatus,
		purchaseVPCErrorType = self.resetState.purchaseVPCErrorType,
		purchaseVPCErrorFetchingStatus = self.resetState.purchaseVPCErrorFetchingStatus,
		purchasePreCheckStatus = self.resetState.purchasePreCheckStatus,
		purchaseErrorType = self.resetState.purchaseErrorType,
		economicRestrictionError = self.resetState.economicRestrictionError
	}

	function self.failFlow(p2, p3)
		if p3 == nil then
			self.sendCounter(module7.PurchaseFailed)
		else
			self.sendCounter(p3)
		end
	end

	function self.purchaseRobux(selectedRobuxPackage)
		self:setState(self.resetState)
		self.props.endPurchase()

		if getEnableConsolePreparePaymentCheck() and not preparePaymentCheck(selectedRobuxPackage) then
			self:setState({ purchasePreCheckStatus = module5.Failed }, nil)
			return
		end

		self.selectedRobuxPackage = selectedRobuxPackage

		self:setState({ purchaseVPCErrorFetchingStatus = module5.Fetching })
		self:dispatchCheckUserPurchaseSettings():andThen(function(p2)
			if not p2 then
				return Promise.resolve()
			end

			self:setState({ purchaseVPCErrorFetchingStatus = module5.Done })
			self:setState({ purchaseWarningFetchingStatus = module5.Fetching })
			self:dispatchFetchPurchaseWarning():andThen(function(p3)
				self:setState({ purchaseWarningFetchingStatus = module5.Done })

				if not p3 then
					self:promptRobuxPurchase()
				end
			end):catch(function()
				self.failFlow({ purchaseWarningFetchingStatus = module5.Failed }, nil)
			end)
		end)
	end

	function self.acceptPurchaseWarning()
		self:setState({ purchaseWarningPostStatus = module5.Done })
		self:dispatchPostAckPurchaseWarning()
		self:promptRobuxPurchase()
	end

	function self.cancelPurchase()
		self.sendCounter(module7.PurchaseCanceled)
		self.endPurchase()
	end

	function self.endPurchase()
		self.selectedRobuxPackage = nil
		self:setState(self.resetState)
		self.props.endPurchase()
	end

	function self.sendAnalyticEvent(p2, p3)
		self.props.sendAnalyticEvent(self.props.eventPrefix .. "BuyRobux", p2, p3)
	end

	function self.sendCounter(p2)
		self.props.sendCounter(module7.toRawValue(p2))
	end

	function self.getProductId(p2)
		for k, robuxPackage in self.props.robuxPackages do
			if p2 == robuxPackage.packageId then
				return robuxPackage.productId
			end
		end

		return nil
	end
end

function extended:dispatchFetchPurchaseWarning()
	return self.props.dispatchFetchIAPPurchaseWarning(
		self.selectedRobuxPackage,
		self.getProductId(self.selectedRobuxPackage)
	):andThen(function(p2)
		local v5 = true

		if p2 == module.ResponseType.U13PaymentModal then
			self.sendCounter(module7.ShowU13PaymentModal)
			self:setState({ purchaseWarningType = u13ConfirmType.U13PaymentModal })
		elseif p2 == module.ResponseType.U13MonthlyThreshold1Modal then
			self.sendCounter(module7.ShowU13MonthlyThreshold1Modal)
			self:setState({
				purchaseWarningType = u13ConfirmType.U13MonthlyThreshold1Modal
			})
		elseif p2 == module.ResponseType.U13MonthlyThreshold2Modal then
			self.sendCounter(module7.ShownU13MonthlyThreshold2Modal)
			self:setState({
				purchaseWarningType = u13ConfirmType.U13MonthlyThreshold2Modal
			})
		elseif p2 == module.ResponseType.ParentalConsentWarningPaymentModal13To17 then
			self.sendCounter(module7.ShownParentalConsentWarningPaymentModal13To17)
			self:setState({
				purchaseWarningType = u13ConfirmType.ParentalConsentWarningPaymentModal13To17
			})
		else
			v5 = false
		end

		return Promise.resolve(v5)
	end)
end

function extended.dispatchCheckUserPurchaseSettings(object)
	return object.props.dispatchCheckUserPurchaseSettings():andThen(function(data)
		if data == nil then
			error("Result from check-user-purchase-settings is nil")
		end

		local v5 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(data.failureReason)
		local v6 = data.isEligible == nil or data.failureReason == nil

		local v7 = v5 ~= economicRestrictionsViolationType.None and data.expirationTimeInMinutes ~= nil

		if v6 and not v7 then
			error("Invalid response from check-user-purchase-settings")
		end

		if data.isEligible then
			return Promise.resolve(true)
		end

		if data.failureReason == checkUserPurchaseSettingsFailureReason.PurchaseNotEnabled then
			object.sendCounter(module7.ShowPurchaseNotEnabledModal)
			object:setState({
				purchaseVPCErrorType = module8.toRawValue(module8.EnablePurchase)
			})
		else
			if not v7 then
				error("User is not eligible for purchases with unknown failure reason")
				return
			end

			object.sendCounter(module7.ShowEconomicRestrictionModal)
			object:setState({
				purchaseErrorType = purchaseErrorType.EconomicRestriction,
				economicRestrictionError = {
					timeoutMinutes = data.expirationTimeInMinutes,
					violationType = v5
				}
			})
		end

		return Promise.resolve(false)
	end):catch(function(p2)
		object:setState({ purchaseVPCErrorFetchingStatus = module5.Failed })
		return Promise.resolve(false)
	end)
end

function extended.dispatchPostAckPurchaseWarning(data)
	local props = data.props
	local state = data.state

	local v5 = module2.UserActionType.None

	if state.purchaseWarningType == u13ConfirmType.U13PaymentModal then
		data.sendCounter(module7.ConfirmU13PaymentModal)
		v5 = module2.UserActionType.ConfirmedU13PaymentModal
	elseif state.purchaseWarningType == u13ConfirmType.U13MonthlyThreshold1Modal then
		data.sendCounter(module7.ConfirmU13MonthlyThreshold1Modal)
		v5 = module2.UserActionType.ConfirmedU13MonthlyThreshold1Modal
	elseif state.purchaseWarningType == u13ConfirmType.U13MonthlyThreshold2Modal then
		data.sendCounter(module7.ConfirmU13MonthlyThreshold2Modal)
		v5 = module2.UserActionType.ConfirmedU13MonthlyThreshold2Modal
	elseif state.purchaseWarningType == u13ConfirmType.ParentalConsentWarningPaymentModal13To17 then
		data.sendCounter(module7.ConfirmParentalConsentWarningPaymentModal13To17)
		v5 = module2.UserActionType.ConfirmedParentalConsentWarningPaymentModal13To17
	end

	return props.dispatchPostAckPurchaseWarning(v5)
end

function extended:promptRobuxPurchase()
	self.props.promptRobux(
		self.props.networking,
		self.selectedRobuxPackage,
		self.getProductId(self.selectedRobuxPackage)
	)
end

function extended:getFlowState()
	local state = self.state
	local props = self.props

	if
		state.purchaseVPCErrorType ~= nil
		and state.purchaseVPCErrorType ~= module8.toRawValue(module8.None)
	then
		return buyRobuxFlowState.PurchaseVPC
	end

	if not (state.purchaseVPCErrorFetchingStatus ~= module5.Failed and state.purchaseErrorType ~= purchaseErrorType.EconomicRestriction and state.purchasePreCheckStatus ~= module5.Failed) then
		return buyRobuxFlowState.Error
	end

	if not (props.iapProductsFetchingStatus == module5.Done and props.nativeProductsFetchingStatus == module5.Done) then
		return buyRobuxFlowState.Loading
	end

	if
		state.purchaseWarningFetchingStatus == module5.NotStarted
		or state.purchaseVPCErrorFetchingStatus == module5.NotStarted
	then
		return buyRobuxFlowState.BuyRobux
	end

	if
		state.purchaseWarningFetchingStatus ~= module5.Done
		and state.purchaseVPCErrorFetchingStatus ~= module5.Done
	then
		return buyRobuxFlowState.Loading
	end

	if
		state.purchaseWarningType ~= u13ConfirmType.None
		and state.purchaseWarningPostStatus == module5.NotStarted
	then
		return buyRobuxFlowState.PurchaseWarning
	end

	if props.iapPurchase.nativeProductId == nil or props.iapPurchase.purchaseStatus == module4.Pending then
		return buyRobuxFlowState.RobuxPurchasePending
	end

	if props.iapPurchase.purchaseStatus == module4.Polling then
		return buyRobuxFlowState.RobuxGrantPending
	end

	if
		props.iapPurchase.purchaseStatus == module4.Failed
		or module6() and props.iapPurchase.purchaseStatus == module4.RobuxPollingFailedAfterNativePurchase
	then
		return buyRobuxFlowState.Error
	end

	if props.iapPurchase.purchaseStatus == module4.Success then
		return buyRobuxFlowState.Succeed
	end

	return buyRobuxFlowState.BuyRobux
end

function extended:getErrorType()
	local props = self.props
	local state = self.state

	if
		props.iapPurchase
		and props.iapPurchase.purchaseStatus == module4.RobuxPollingFailedAfterNativePurchase
	then
		return purchaseErrorType.FailedGrant
	end

	return state.purchaseErrorType
end

function extended:render()
	local props2 = self.props
	local state = self.state

	local createElement = Roact.createElement
	local v6 = {
		screenSize = props2.screenSize,
		isConsoleSize = tenFootInterface,
		showBackground = not tenFootInterface,
		showCloseButton = not tenFootInterface,
		shouldAnimate = true,
		analyticId = props2.analyticId,
		robuxBalance = props2.robuxBalance,
		robuxPackages = props2.robuxPackages,
		purchaseState = self:getFlowState(),
		purchaseVPCType = state.purchaseVPCErrorType,
		errorType = 0,
		economicRestrictionError = 0,
		u13ConfirmType = 0,
		purchaseRobux = 0,
		acceptPurchaseWarning = 0,
		cancelPurchase = 0,
		flowComplete = 0,
		onAnalyticEvent = 0,
		eventPrefix = 0,
		onPageClose = 0,
		dispatchCentralOverlay = 0
	}
	local v7 = if module6() then self:getErrorType() else state.purchaseErrorType
	v6.errorType = v7
	v6.economicRestrictionError = state.economicRestrictionError
	v6.u13ConfirmType = self.state.purchaseWarningType

	v6.purchaseRobux = self.purchaseRobux
	v6.acceptPurchaseWarning = self.acceptPurchaseWarning
	v6.cancelPurchase = self.cancelPurchase
	v6.flowComplete = self.endPurchase

	v6.onAnalyticEvent = self.sendAnalyticEvent
	v6.eventPrefix = props2.eventPrefix

	v6.onPageClose = props2.onPageClose
	v6.dispatchCentralOverlay = props2.dispatchCentralOverlay
	return createElement(buyRobuxFlow, v6)
end

return extended
