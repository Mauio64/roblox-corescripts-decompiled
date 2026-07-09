local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local RobuxUpsellFlow = IAPExperience.PurchaseFlow.RobuxUpsellFlow
local RobuxUpsellFlowState = IAPExperience.PurchaseFlow.RobuxUpsellFlowState
local U13ConfirmType = IAPExperience.PurchaseFlow.U13ConfirmType
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType
local VPCModalType = require(Modules.LuaApp.Components.BuyRobux.Enum.VPCModalType)
local TwoStepSpendFrictionRequests = require(Modules.LuaApp.Http.Requests.TwoStepSpendFrictionRequests)
local ApiFetchIAPPurchaseWarning = require(Modules.LuaApp.Thunks.ApiFetchIAPPurchaseWarning)
local ApiPostAckPurchaseWarning = require(Modules.LuaApp.Thunks.ApiPostAckPurchaseWarning)
local Type = require(Modules.LuaApp.Enum.Challenge.Type)
local ActionType = require(Modules.LuaApp.Enum.Challenge.TwoStepVerification.ActionType)
local NativePurchaseStatus = require(Modules.LuaApp.Enum.NativePurchaseStatus)
local GetFFlagFixBuyRobuxNotChargedMessage = require(Modules.LuaApp.Flags.GetFFlagFixBuyRobuxNotChargedMessage)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local RobuxUpsellCounter = require(script.Parent.Enum.RobuxUpsellCounter)
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)
local CheckUserPurchaseSettingsFailureReason = IAPExperience.Enums.CheckUserPurchaseSettingsFailureReason
local mapCheckUserPurchaseSettingsFailureReasonToViolationType = IAPExperience.Utility.mapCheckUserPurchaseSettingsFailureReasonToViolationType
local GetFFlagLuaAppWaitBeforeTwoStepRenderDev = require(Modules.LuaApp.Flags.GetFFlagLuaAppWaitBeforeTwoStepRenderDev)
local GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev = require(Modules.LuaApp.Flags.GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev)
local GetFFlagOpenVngTosForVngRobuxUpsell = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagOpenVngTosForVngRobuxUpsell
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local v28 = Roact.PureComponent:extend(script.Name)
local PreparePaymentCheck = IAPExperience.PreparePaymentCheck
local GetEnableConsolePreparePaymentCheck = IAPExperience.GetEnableConsolePreparePaymentCheck
local UpsellSuggestionsAPIMaxPackages = require(CorePackages.Workspace.Packages.SharedFlags).UpsellSuggestionsAPIMaxPackages
local EconomicRestrictionsViolationType = IAPExperience.Enums.EconomicRestrictionsViolationType

function v28.init(p1) -- line: 118
	-- upvalues: PurchaseErrorType (copy), RetrievalStatus (copy), U13ConfirmType (copy), VPCModalType (copy), RobuxUpsellCounter (copy), GetEnableConsolePreparePaymentCheck (copy), PreparePaymentCheck (copy), Promise (copy), getPaymentPlatform (copy), PaymentPlatform (copy)
	p1.state = {
		robuxSuggestions = nil,
		robuxPackageSelection = nil,
		virtualItemBadgeType = nil,
		robuxProduct = nil,
		twoStepRequired = false,
		errorType = PurchaseErrorType.None,
		robuxProductFetchingStatus = RetrievalStatus.NotStarted,
		purchaseWarningType = U13ConfirmType.None,
		purchaseWarningFetchingStatus = RetrievalStatus.NotStarted,
		purchaseWarningPostStatus = RetrievalStatus.NotStarted,
		purchaseVPCErrorType = VPCModalType.toRawValue(VPCModalType.None),
		purchaseVPCErrorFetchingStatus = RetrievalStatus.NotStarted,
		itemPurchaseFetchingStatus = RetrievalStatus.NotStarted
	}

	function p1.getSelectedRobuxProduct() -- line: 139
		-- upvalues: p1 (copy)
		if p1.state.robuxSuggestions ~= nil and p1.state.robuxPackageSelection ~= nil then
			return p1.state.robuxSuggestions[p1.state.robuxPackageSelection]
		end

		return nil
	end
	function p1.failFlow(p2, p3, p4) -- line: 147
		-- upvalues: p1 (copy), RobuxUpsellCounter (copy), PurchaseErrorType (copy)
		if p4 ~= nil then
			p1.sendCounter(p4)
		else
			p1.sendCounter(RobuxUpsellCounter.UpsellFailed)
		end

		local t1 = {}

		if p3 ~= nil then
			t1 = p3
		end

		if p2 ~= nil then
			t1.errorType = p2
		else
			t1.errorType = PurchaseErrorType.Unknown
		end

		p1:setState(t1)
	end
	function p1.getRobuxUpsellProduct() -- line: 167
		-- upvalues: p1 (copy), RetrievalStatus (copy)
		task.spawn(function() -- line: 170
			-- upvalues: p1 (copy), RetrievalStatus (copy)
			p1:setState({
				robuxProductFetchingStatus = RetrievalStatus.Fetching
			})
			p1:dispatchFetchRobuxProduct():andThen(function() -- line: 172
				-- upvalues: p1 (copy), RetrievalStatus (copy)
				p1:setState({
					robuxProductFetchingStatus = RetrievalStatus.Done
				})
			end, function() -- line: 174
				-- upvalues: p1 (copy), RetrievalStatus (copy)
				p1:setState({
					robuxProductFetchingStatus = RetrievalStatus.Done
				})
			end)
		end)
	end
	function p1.attemptRobuxUpsell() -- line: 180
		-- upvalues: GetEnableConsolePreparePaymentCheck (copy), p1 (copy), PreparePaymentCheck (copy), RetrievalStatus (copy), Promise (copy)
		if GetEnableConsolePreparePaymentCheck() then
			local v76 = p1.getSelectedRobuxProduct()

			if not PreparePaymentCheck(v76.providerId) then
				p1.failFlow()

				return
			end
		end

		p1:setState({
			purchaseVPCErrorFetchingStatus = RetrievalStatus.Fetching
		})
		p1:dispatchCheckUserPurchaseSettings():andThen(function(p5) -- line: 189
			-- upvalues: p1 (copy), RetrievalStatus (copy), Promise (copy)
			p1:setState({
				purchaseVPCErrorFetchingStatus = RetrievalStatus.Done
			})

			if not p5 then
				return Promise.resolve()
			end

			p1:setState({
				purchaseWarningFetchingStatus = RetrievalStatus.Fetching
			})
			p1:dispatchFetchPurchaseWarning():andThen(function(b1: boolean) -- line: 197
				-- upvalues: p1 (copy), RetrievalStatus (copy)
				p1:setState({
					purchaseWarningFetchingStatus = RetrievalStatus.Done
				})

				if not b1 then
					p1:promptRobuxPurchase()
				end
			end):catch(function() -- line: 205
				-- upvalues: p1 (copy), RetrievalStatus (copy)
				p1.failFlow(nil, {
					purchaseWarningFetchingStatus = RetrievalStatus.Failed
				})
			end)
		end)
	end
	function p1.acceptPurchaseWarning() -- line: 211
		-- upvalues: p1 (copy), RetrievalStatus (copy)
		p1:setState({
			purchaseWarningPostStatus = RetrievalStatus.Done
		})
		p1:dispatchPostAckPurchaseWarning()
		p1:promptRobuxPurchase()
	end
	function p1.attemptPurchaseItem() -- line: 218
		-- upvalues: p1 (copy), RetrievalStatus (copy), RobuxUpsellCounter (copy)
		p1:setState({
			itemPurchaseFetchingStatus = RetrievalStatus.Fetching
		})
		p1:purchaseItem():andThen(function(p6) -- line: 220
			-- upvalues: p1 (copy), RetrievalStatus (copy)
			if p6 then
				p1:setState({
					itemPurchaseFetchingStatus = RetrievalStatus.Done
				})
			end
		end, function() -- line: 224
			-- upvalues: p1 (copy), RetrievalStatus (copy), RobuxUpsellCounter (copy)
			p1.failFlow(nil, {
				itemPurchaseFetchingStatus = RetrievalStatus.Failed
			}, RobuxUpsellCounter.UpsellFailedTwoStep)
		end)
	end
	function p1.showTwoStepRequiredPrompt() -- line: 233
		-- upvalues: p1 (copy)
		p1:setState({
			twoStepRequired = true
		})
	end
	function p1.openSecuritySettings() -- line: 237
		-- upvalues: p1 (copy)
		p1.props.openSecuritySettings()
	end
	function p1.openBuyRobux() -- line: 241
		-- upvalues: p1 (copy)
		p1.props.openBuyRobux()
	end
	function p1.cancelPurchase() -- line: 245
		-- upvalues: p1 (copy), RobuxUpsellCounter (copy)
		p1.sendCounter(RobuxUpsellCounter.UpsellCancelled)
		p1.props.endPurchase()
	end
	function p1.sendErrorEvent(t2: {[any]: any}) -- line: 250
		-- upvalues: p1 (copy)
		p1.props.sendAnalyticEvent(p1.props.eventPrefix .. "RobuxUpsell", "RobuxUpsellError", t2)
	end
	function p1.sendAnalyticEvent(s1: string, t3: {[any]: any}) -- line: 254
		-- upvalues: p1 (copy)
		p1.props.sendAnalyticEvent(p1.props.eventPrefix .. "RobuxUpsell", s1, t3)
	end
	function p1.sendCounter(p7) -- line: 258
		-- upvalues: RobuxUpsellCounter (copy), p1 (copy)
		local v81 = RobuxUpsellCounter.toRawValue(p7)

		p1.props.sendCounter(v81)

		local v82 = p1.getSelectedRobuxProduct()

		if v82 ~= nil and v82.robuxAmount ~= nil then
			p1.props.sendCounter(v81 .. tostring(v82.robuxAmount))
		end
	end
	function p1.isSettingsSupportedForPlatform() -- line: 267
		-- upvalues: getPaymentPlatform (copy), PaymentPlatform (copy)
		local v83 = getPaymentPlatform()

		return v83 == PaymentPlatform.Google or (v83 == PaymentPlatform.Apple or (v83 == PaymentPlatform.UWP or v83 == PaymentPlatform.Amazon))
	end
end
function v28.dispatchFetchRobuxProduct(p8) -- line: 277
	-- upvalues: Promise (copy)
	local v35, v36 = p8.props.fetchUpsellSuggestions()

	if v35 and v36 ~= nil then
		p8:setState({
			robuxPackageSelection = 1,
			robuxSuggestions = v36.products,
			virtualItemBadgeType = v36.virtualItemBadgeType
		})

		return Promise.resolve()
	end

	return Promise.reject()
end
function v28.dispatchFetchPurchaseWarning(p9) -- line: 290
	-- upvalues: ApiFetchIAPPurchaseWarning (copy), RobuxUpsellCounter (copy), U13ConfirmType (copy), Promise (copy)
	local props = p9.props
	local v39 = p9.getSelectedRobuxProduct()

	if v39 ~= nil then
		return props.dispatchFetchIAPPurchaseWarning(v39.providerId, v39.productId):andThen(function(p10) -- line: 298
			-- upvalues: ApiFetchIAPPurchaseWarning (copy), p9 (copy), RobuxUpsellCounter (copy), U13ConfirmType (copy), Promise (copy)
			local v85 = true

			if p10 == ApiFetchIAPPurchaseWarning.ResponseType.U13PaymentModal then
				p9.sendCounter(RobuxUpsellCounter.ShowU13PaymentModal)
				p9:setState({
					purchaseWarningType = U13ConfirmType.U13PaymentModal
				})
			elseif p10 == ApiFetchIAPPurchaseWarning.ResponseType.U13MonthlyThreshold1Modal then
				p9.sendCounter(RobuxUpsellCounter.ShowU13MonthlyThreshold1Modal)
				p9:setState({
					purchaseWarningType = U13ConfirmType.U13MonthlyThreshold1Modal
				})
			elseif p10 == ApiFetchIAPPurchaseWarning.ResponseType.U13MonthlyThreshold2Modal then
				p9.sendCounter(RobuxUpsellCounter.ShownU13MonthlyThreshold2Modal)
				p9:setState({
					purchaseWarningType = U13ConfirmType.U13MonthlyThreshold2Modal
				})
			elseif p10 == ApiFetchIAPPurchaseWarning.ResponseType.ParentalConsentWarningPaymentModal13To17 then
				p9.sendCounter(RobuxUpsellCounter.ShownParentalConsentWarningPaymentModal13To17)
				p9:setState({
					purchaseWarningType = U13ConfirmType.ParentalConsentWarningPaymentModal13To17
				})
			else
				v85 = false
			end

			return Promise.resolve(v85)
		end)
	end
end
function v28.dispatchPostAckPurchaseWarning(p11) -- line: 320
	-- upvalues: ApiPostAckPurchaseWarning (copy), U13ConfirmType (copy), RobuxUpsellCounter (copy)
	local props = p11.props
	local state = p11.state
	local None = ApiPostAckPurchaseWarning.UserActionType.None

	if state.purchaseWarningType == U13ConfirmType.U13PaymentModal then
		p11.sendCounter(RobuxUpsellCounter.ConfirmU13PaymentModal)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedU13PaymentModal
	elseif state.purchaseWarningType == U13ConfirmType.U13MonthlyThreshold1Modal then
		p11.sendCounter(RobuxUpsellCounter.ConfirmU13MonthlyThreshold1Modal)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedU13MonthlyThreshold1Modal
	elseif state.purchaseWarningType == U13ConfirmType.U13MonthlyThreshold2Modal then
		p11.sendCounter(RobuxUpsellCounter.ConfirmU13MonthlyThreshold2Modal)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedU13MonthlyThreshold2Modal
	elseif state.purchaseWarningType == U13ConfirmType.ParentalConsentWarningPaymentModal13To17 then
		p11.sendCounter(RobuxUpsellCounter.ConfirmParentalConsentWarningPaymentModal13To17)
		None = ApiPostAckPurchaseWarning.UserActionType.ConfirmedParentalConsentWarningPaymentModal13To17
	end

	return props.dispatchPostAckPurchaseWarning(None)
end
function v28.dispatchCheckUserPurchaseSettings(p12) -- line: 343
	-- upvalues: getPaymentPlatform (copy), PaymentPlatform (copy), Promise (copy), mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), CheckUserPurchaseSettingsFailureReason (copy), RobuxUpsellCounter (copy), VPCModalType (copy), PurchaseErrorType (copy), RetrievalStatus (copy)
	local props = p12.props

	if getPaymentPlatform() == PaymentPlatform.Web then
		return Promise.resolve(true)
	end

	return props.dispatchCheckUserPurchaseSettings():andThen(function(p13) -- line: 352
		-- upvalues: mapCheckUserPurchaseSettingsFailureReasonToViolationType (copy), EconomicRestrictionsViolationType (copy), Promise (copy), CheckUserPurchaseSettingsFailureReason (copy), p12 (copy), RobuxUpsellCounter (copy), VPCModalType (copy), PurchaseErrorType (copy)
		if p13 == nil then
			error("Result from check-user-purchase-settings is nil")
		end

		local v87 = mapCheckUserPurchaseSettingsFailureReasonToViolationType(p13.failureReason)
		local v88 = v87 ~= EconomicRestrictionsViolationType.None and p13.expirationTimeInMinutes ~= nil

		if (p13.isEligible == nil or p13.failureReason == nil) and not v88 then
			error("Invalid response from check-user-purchase-settings")
		end

		if p13.isEligible then
			return Promise.resolve(true)
		end

		if p13.failureReason == CheckUserPurchaseSettingsFailureReason.PurchaseNotEnabled then
			p12.sendCounter(RobuxUpsellCounter.ShowPurchaseNotEnabledModal)
			p12:setState({
				purchaseVPCErrorType = VPCModalType.toRawValue(VPCModalType.EnablePurchase)
			})

			return Promise.resolve(false)
		end

		if v88 then
			p12.sendCounter(RobuxUpsellCounter.ShowEconomicRestrictionModal)
			p12:setState({
				errorType = PurchaseErrorType.EconomicRestriction,
				economicRestrictionError = {
					timeoutMinutes = p13.expirationTimeInMinutes,
					violationType = v87
				}
			})

			return Promise.resolve(false)
		end

		error("User is not eligible for purchases with unknown failure reason")
	end):catch(function(_) -- line: 393
		-- upvalues: p12 (copy), RetrievalStatus (copy), Promise (copy)
		p12.failFlow(nil, {
			purchaseWarningFetchingStatus = RetrievalStatus.Failed
		})

		return Promise.resolve(false)
	end)
end
function v28.promptRobuxPurchase(p15) -- line: 399
	local props = p15.props
	local v48 = p15.getSelectedRobuxProduct()

	if v48 ~= nil then
		if props.analyticId then
			props.promptRobux(p15.props.networking, v48.providerId, v48.productId, props.analyticId)

			return
		end

		props.promptRobux(p15.props.networking, v48.providerId, v48.productId)
	end
end
function v28.purchaseItem(p16) -- line: 413
	-- upvalues: RobuxUpsellCounter (copy), Promise (copy)
	return p16.props.purchaseItem():andThen(function(p17) -- line: 416
		-- upvalues: p16 (copy), RobuxUpsellCounter (copy), Promise (copy)
		local purchased = p17.purchased
		local is2SVEnabled = p17.is2SVEnabled
		local challengeToken = p17.challengeToken

		if purchased then
			p16.sendCounter(RobuxUpsellCounter.UpsellSuccess)

			return Promise.resolve(true)
		end

		if is2SVEnabled == false then
			p16.sendCounter(RobuxUpsellCounter.ShownEnableTwoStepAuth)
			p16.showTwoStepRequiredPrompt()

			return Promise.resolve(true)
		end

		if challengeToken then
			p16.sendCounter(RobuxUpsellCounter.ShownTwoStepAuth)
			p16:renderTwoStepChallenge(challengeToken)

			return Promise.resolve(false)
		end

		p16.sendCounter(RobuxUpsellCounter.FailedShowTwoStepAuth)

		return Promise.reject()
	end, function() -- line: 436
		-- upvalues: p16 (copy), RobuxUpsellCounter (copy), Promise (copy)
		p16.sendCounter(RobuxUpsellCounter.FailedShowTwoStepAuthUnknown)

		return Promise.reject()
	end)
end
function v28.renderTwoStepChallenge(t4: {[any]: any}, n1: number) -- line: 442
	-- upvalues: GetFFlagLuaAppWaitBeforeTwoStepRenderDev (copy), GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev (copy), Type (copy), ActionType (copy), RobuxUpsellCounter (copy), TwoStepSpendFrictionRequests (copy)
	local props = t4.props
	local networking = props.networking
	local userId = props.userId

	if GetFFlagLuaAppWaitBeforeTwoStepRenderDev() then
		wait(GetFIntLuaAppWaitBeforeTwoStepRenderTimeSecondsDev())
	end

	props.renderChallenge({
		forceWebViewVisible = true,
		challengeType = Type.TwoStepVerification,
		challengeParameters = {
			actionType = ActionType.RobuxSpend,
			challengeId = n1,
			userId = userId,
			onChallengeCompleted = function(p18) -- line: 458
				-- upvalues: t4 (copy), RobuxUpsellCounter (copy), TwoStepSpendFrictionRequests (copy), networking (copy), n1 (copy)
				t4.sendCounter(RobuxUpsellCounter.CompletedTwoStepAuth)

				local verificationToken = p18.verificationToken

				return TwoStepSpendFrictionRequests.redeem(networking, tostring(n1), verificationToken):andThen(function(_) -- line: 462
					-- upvalues: t4 (copy)
					t4.attemptPurchaseItem()
				end, function(_) -- line: 464
					-- upvalues: t4 (copy)
					t4.failFlow()
				end)
			end,
			onChallengeInvalidated = function(_) -- line: 468
				-- upvalues: t4 (copy), RobuxUpsellCounter (copy)
				t4.sendCounter(RobuxUpsellCounter.InvalidatedTwoStepAuth)
				t4.failFlow()
			end
		},
		onChallengeAbandoned = function() -- line: 473
			-- upvalues: t4 (copy), RobuxUpsellCounter (copy)
			t4.sendCounter(RobuxUpsellCounter.AbandonedTwoStepAuth)
			t4.failFlow()
		end,
		onChallengeLoadFailed = function() -- line: 477
			-- upvalues: t4 (copy), RobuxUpsellCounter (copy)
			t4.sendCounter(RobuxUpsellCounter.LoadFailedTwoStepAuth)
			t4.failFlow()
		end
	}, false)
end
function v28.didMount(p22) -- line: 487
	-- upvalues: RetrievalStatus (copy), RobuxUpsellCounter (copy)
	if p22.state.robuxProductFetchingStatus == RetrievalStatus.NotStarted then
		p22.sendCounter(RobuxUpsellCounter.UpsellShown)
		p22.getRobuxUpsellProduct()
	end
end
function v28.didUpdate(t5: {[any]: any}, t6: {[any]: any}, t7: {[any]: any}) -- line: 494
	-- upvalues: RetrievalStatus (copy), RobuxUpsellCounter (copy), NativePurchaseStatus (copy), GetFFlagFixBuyRobuxNotChargedMessage (copy)
	local state = t5.state
	local props = t5.props

	if t7.robuxProductFetchingStatus ~= state.robuxProductFetchingStatus and state.robuxProductFetchingStatus == RetrievalStatus.Done then
		if t5.getSelectedRobuxProduct() ~= nil then
			t5.sendCounter(RobuxUpsellCounter.UpsellModalShown)
		else
			t5.sendCounter(RobuxUpsellCounter.UpsellGenericModalShown)
		end
	end

	if props.iapPurchase ~= t6.iapPurchase then
		if props.iapPurchase.purchaseStatus == NativePurchaseStatus.Success and state.itemPurchaseFetchingStatus == RetrievalStatus.NotStarted then
			t5.attemptPurchaseItem()
		end

		if t6.iapPurchase.purchaseStatus ~= props.iapPurchase.purchaseStatus and (props.iapPurchase.purchaseStatus == NativePurchaseStatus.Failed or GetFFlagFixBuyRobuxNotChargedMessage() and props.iapPurchase.purchaseStatus == NativePurchaseStatus.RobuxPollingFailedAfterNativePurchase) then
			t5.sendCounter(RobuxUpsellCounter.UpsellFailedNativePurchase)
		end
	end
end
function v28.getFlowState(p23) -- line: 535
	-- upvalues: VPCModalType (copy), RobuxUpsellFlowState (copy), PurchaseErrorType (copy), RetrievalStatus (copy), U13ConfirmType (copy), NativePurchaseStatus (copy), GetFFlagFixBuyRobuxNotChargedMessage (copy)
	local state = p23.state
	local props = p23.props

	if state.purchaseVPCErrorType ~= nil and state.purchaseVPCErrorType ~= VPCModalType.toRawValue(VPCModalType.None) then
		return RobuxUpsellFlowState.PurchaseVPCModal
	end

	if state.errorType ~= PurchaseErrorType.None then
		return RobuxUpsellFlowState.Error
	end

	if state.robuxProductFetchingStatus ~= RetrievalStatus.Done then
		return RobuxUpsellFlowState.Loading
	end

	if state.purchaseWarningFetchingStatus == RetrievalStatus.NotStarted and state.purchaseVPCErrorFetchingStatus == RetrievalStatus.NotStarted then
		if p23.getSelectedRobuxProduct() ~= nil then
			return RobuxUpsellFlowState.PurchaseModal
		end

		return RobuxUpsellFlowState.GenericPurchaseModal
	end

	if state.purchaseWarningFetchingStatus ~= RetrievalStatus.Done and state.purchaseVPCErrorFetchingStatus ~= RetrievalStatus.Done then
		return RobuxUpsellFlowState.Loading
	end

	if state.purchaseWarningType ~= U13ConfirmType.None and state.purchaseWarningPostStatus == RetrievalStatus.NotStarted then
		return RobuxUpsellFlowState.PurchaseWarning
	end

	if props.iapPurchase.nativeProductId == nil or props.iapPurchase.purchaseStatus == NativePurchaseStatus.Pending then
		return RobuxUpsellFlowState.RobuxPurchasePending
	end

	if props.iapPurchase.purchaseStatus == NativePurchaseStatus.Polling then
		return RobuxUpsellFlowState.RobuxGrantPending
	end

	if props.iapPurchase.purchaseStatus == NativePurchaseStatus.Failed or GetFFlagFixBuyRobuxNotChargedMessage() and props.iapPurchase.purchaseStatus == NativePurchaseStatus.RobuxPollingFailedAfterNativePurchase then
		return RobuxUpsellFlowState.Error
	end

	if state.itemPurchaseFetchingStatus == RetrievalStatus.NotStarted or state.itemPurchaseFetchingStatus == RetrievalStatus.Fetching then
		return RobuxUpsellFlowState.ItemPurchasePending
	end

	if state.twoStepRequired then
		return RobuxUpsellFlowState.TwoStepRequired
	end

	if state.itemPurchaseFetchingStatus == RetrievalStatus.Done then
		return RobuxUpsellFlowState.Success
	end

	return RobuxUpsellFlowState.Error
end
function v28.getErrorType(p24) -- line: 625
	-- upvalues: NativePurchaseStatus (copy), GetFFlagFixBuyRobuxNotChargedMessage (copy), PurchaseErrorType (copy)
	local state = p24.state
	local props = p24.props

	if props.iapPurchase and (props.iapPurchase.purchaseStatus == NativePurchaseStatus.Failed or GetFFlagFixBuyRobuxNotChargedMessage() and props.iapPurchase.purchaseStatus == NativePurchaseStatus.RobuxPollingFailedAfterNativePurchase) then
		return PurchaseErrorType.FailedGrantUnknown
	end

	return state.errorType
end
function v28.render(p25) -- line: 645
	-- upvalues: Roact (copy), RobuxUpsellFlow (copy), UpsellSuggestionsAPIMaxPackages (copy), GetFFlagOpenVngTosForVngRobuxUpsell (copy), getAppFeaturePolicies (copy)
	local props = p25.props
	local state = p25.state
	local v70 = p25.getSelectedRobuxProduct()
	local v71 = p25:getFlowState()

	return Roact.createElement(RobuxUpsellFlow, {
		screenSize = props.screenSize,
		itemProductId = props.itemProductId,
		itemIcon = props.itemIcon,
		itemName = props.itemName,
		itemRobuxCost = props.priceInRobux,
		iapRobuxAmount = v70 and v70.robuxAmount or nil,
		iapRobuxAmountBeforeBonus = if not v70 then nil else v70.robuxAmountBeforeBonus,
		iapCostStr = if not v70 then nil else v70.price,
		beforeRobuxBalance = props.beforeRobuxBalance,
		useUpsellSuggestions = UpsellSuggestionsAPIMaxPackages > 1,
		upsellSuggestions = state.robuxSuggestions,
		selectedUpsellIndex = state.robuxPackageSelection,
		virtualItemBadgeType = state.virtualItemBadgeType,
		onUpsellSuggestionsSelected = function(n2: number) -- line: 670
			-- upvalues: p25 (copy)
			p25:setState({
				robuxPackageSelection = n2
			})
		end,
		purchaseState = v71,
		errorType = p25:getErrorType(),
		economicRestrictionError = state.economicRestrictionError,
		u13ConfirmType = state.purchaseWarningType,
		purchaseVPCType = state.purchaseVPCErrorType,
		acceptControllerIcon = nil,
		cancelControllerIcon = nil,
		purchaseRobux = p25.attemptRobuxUpsell,
		acceptPurchaseWarning = p25.acceptPurchaseWarning,
		cancelPurchase = p25.cancelPurchase,
		openSecuritySettings = p25.openSecuritySettings,
		openBuyRobux = p25.openBuyRobux,
		showTermsOfUse = p25.props.openTermsOfUse,
		equipItem = props.equipItem,
		flowComplete = props.endPurchase,
		openSettingsPage = if not p25.isSettingsSupportedForPlatform() then nil else props.openSettingsPage,
		onAnalyticEvent = p25.sendAnalyticEvent,
		eventPrefix = props.eventPrefix,
		analyticId = props.analyticId,
		dispatchCentralOverlay = props.dispatchCentralOverlay,
		isVng = GetFFlagOpenVngTosForVngRobuxUpsell() and getAppFeaturePolicies().getShowVNGTosForRobuxUpsell()
	})
end

return v28
