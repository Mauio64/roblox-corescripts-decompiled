local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local BuyRobuxFlowState = require(scriptParent.BuyRobuxFlowState)
local Constants = require(ParentParent.Generic.Constants)
local LoadingOverlay = require(ParentParent.Generic.LoadingOverlay)
local LoadingOverlayState = require(ParentParent.Generic.LoadingOverlayState)
local BuyRobuxPage = require(ParentParent.BuyRobux.BuyRobuxPage)
local PurchaseErrorPrompt = require(ParentParent.Generic.PurchaseErrorPrompt)
local U13ConfirmPrompt = require(ParentParent.Generic.U13ConfirmPrompt)
local getModalShownEventData = require(ParentParent.Utility.getModalShownEventData)
local getUserInputEventData = require(ParentParent.Utility.getUserInputEventData)
local VerifiedParentalConsentDialog = require(ParentParentParent.VerifiedParentalConsentDialog).VerifiedParentalConsentDialog
local v16 = Roact.Component:extend(script.Name)

function v16.init(p1) -- line: 62
	-- upvalues: HttpService (copy)
	p1.state = {
		analyticId = if not p1.props.analyticId then HttpService:GenerateGUID(false) else p1.props.analyticId
	}
end
function v16.didUpdate(t1: {[any]: any}, t2: {[any]: any}, _: {[any]: any}) -- line: 68
	local props = t1.props

	if t2.purchaseState ~= props.purchaseState then
		t1:reportModalShown()
		t1:dispatchAndRenderModal(props)
	end
end
function v16.dispatchAndRenderModal(t4: {[any]: any}, t5: {[any]: any}) -- line: 78
	-- upvalues: BuyRobuxFlowState (copy), Constants (copy), Roact (copy), PurchaseErrorPrompt (copy), U13ConfirmPrompt (copy), VerifiedParentalConsentDialog (copy)
	if t5.purchaseState == BuyRobuxFlowState.Error then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, {
			shouldAnimate = t5.shouldAnimate,
			shouldShow = t5.purchaseState == BuyRobuxFlowState.Error,
			renderChildren = function() -- line: 83
				-- upvalues: Roact (copy), PurchaseErrorPrompt (copy), t5 (copy), t4 (copy)
				return Roact.createElement(PurchaseErrorPrompt, {
					screenSize = t5.screenSize,
					errorType = t5.errorType,
					economicRestrictionError = t5.economicRestrictionError,
					doneControllerIcon = t5.acceptControllerIcon,
					doneActivated = function() -- line: 92
						-- upvalues: t4 (copy), t5 (copy)
						t4:reportUserInput("Done")
						t5.flowComplete()
						t5.dispatchCentralOverlay()
					end
				})
			end
		})

		return
	end

	if t5.purchaseState == BuyRobuxFlowState.PurchaseWarning then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, {
			shouldAnimate = t5.shouldAnimate,
			shouldShow = t5.purchaseState == BuyRobuxFlowState.PurchaseWarning,
			renderChildren = function() -- line: 107
				-- upvalues: Roact (copy), U13ConfirmPrompt (copy), t5 (copy), t4 (copy)
				return Roact.createElement(U13ConfirmPrompt, {
					screenSize = t5.screenSize,
					modalType = t5.u13ConfirmType,
					doneActivated = function() -- line: 113
						-- upvalues: t4 (copy), t5 (copy)
						t4:reportUserInput("Confirm")
						t5.acceptPurchaseWarning()
						t5.dispatchCentralOverlay()
					end,
					cancelActivated = function() -- line: 118
						-- upvalues: t4 (copy), t5 (copy)
						t4:reportUserInput("Cancel")
						t5.cancelPurchase()
						t5.dispatchCentralOverlay()
					end
				})
			end
		})

		return
	end

	if t5.purchaseState == BuyRobuxFlowState.PurchaseVPC then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, {
			shouldAnimate = t5.shouldAnimate,
			shouldShow = t5.purchaseState == BuyRobuxFlowState.PurchaseVPC,
			renderChildren = function() -- line: 133
				-- upvalues: Roact (copy), VerifiedParentalConsentDialog (copy), t5 (copy), t4 (copy)
				return Roact.createElement(VerifiedParentalConsentDialog, {
					isActionable = false,
					screenSize = t5.screenSize,
					modalType = t5.purchaseVPCType,
					onDismiss = function() -- line: 138
						-- upvalues: t4 (copy), t5 (copy)
						t4:reportUserInput("Close")
						t5.flowComplete()
						t5.dispatchCentralOverlay()
					end
				})
			end
		})
	end
end
function v16.reportModalShown(p2) -- line: 149
	-- upvalues: getModalShownEventData (copy), BuyRobuxFlowState (copy)
	local props = p2.props
	local state = p2.state

	if not p2.props.onAnalyticEvent then
		return
	end

	local v27 = getModalShownEventData(state.analyticId, "", "BuyRobux", BuyRobuxFlowState.toRawValue(props.purchaseState))

	props.onAnalyticEvent("UserPurchaseFlow", v27)
end
function v16.reportUserInput(t6: {[any]: any}, s1: string) -- line: 163
	-- upvalues: getUserInputEventData (copy), BuyRobuxFlowState (copy)
	local props = t6.props
	local state = t6.state

	if not t6.props.onAnalyticEvent then
		return
	end

	local v32 = getUserInputEventData(state.analyticId, "", "BuyRobux", BuyRobuxFlowState.toRawValue(props.purchaseState), s1)

	props.onAnalyticEvent("UserPurchaseFlow", v32)
end
function v16.purchaseStateToOverlayState(_, p4) -- line: 182
	-- upvalues: BuyRobuxFlowState (copy), LoadingOverlayState (copy)
	if p4 == BuyRobuxFlowState.Loading then
		return LoadingOverlayState.Loading
	end

	if p4 == BuyRobuxFlowState.RobuxPurchasePending then
		return LoadingOverlayState.PurchasingRobux
	end

	if p4 == BuyRobuxFlowState.RobuxGrantPending then
		return LoadingOverlayState.WaitingForRobux
	end

	if p4 == BuyRobuxFlowState.PurchaseWarning then
		return LoadingOverlayState.None
	end

	if p4 == BuyRobuxFlowState.None then
		return LoadingOverlayState.None
	end

	return nil
end
function v16.render(p5) -- line: 198
	-- upvalues: Roact (copy), BuyRobuxPage (copy), BuyRobuxFlowState (copy), LoadingOverlay (copy)
	local props = p5.props
	local state = p5.state
	local purchaseState = props.purchaseState
	local v39 = p5:purchaseStateToOverlayState(props.purchaseState)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		BuyRobuxFrame = Roact.createElement(BuyRobuxPage, {
			showCloseButton = props.showCloseButton,
			showBackground = props.showBackground,
			isConsoleSize = props.isConsoleSize,
			robuxBalance = props.robuxBalance,
			robuxPackages = props.robuxPackages,
			robuxPackageActivated = function(s2: string) -- line: 217
				-- upvalues: p5 (copy), props (copy)
				p5:reportUserInput("Confirm")
				props.purchaseRobux(s2)
			end,
			onPageClose = props.onPageClose,
			hasNativePurchaseSucceeded = purchaseState == BuyRobuxFlowState.Succeed,
			shouldAnimate = props.shouldAnimate,
			analyticId = state.analyticId,
			onAnalyticEvent = props.onAnalyticEvent
		}),
		LoadingOverlay = Roact.createElement(LoadingOverlay, {
			shouldAnimate = false,
			showOverlay = v39 ~= nil,
			loadingState = v39
		})
	})
end

return v16
