local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local getPartialPageModalMiddleContentWidth = require(ParentParentParent.UIBlox).App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local PremiumUpsellFlowState = require(scriptParent.PremiumUpsellFlowState)
local Animator = require(ParentParent.Generic.Animator)
local Constants = require(ParentParent.Generic.Constants)
local PurchaseErrorPrompt = require(ParentParent.Generic.PurchaseErrorPrompt)
local PremiumUpsellPrompt = require(ParentParent.PremiumUpsell.PremiumUpsellPrompt)
local getModalShownEventData = require(ParentParent.Utility.getModalShownEventData)
local getUserInputEventData = require(ParentParent.Utility.getUserInputEventData)
local getEnableCentralOverlayForUpsellPrompt = require(ParentParent.Flags.getEnableCentralOverlayForUpsellPrompt)
local VerifiedParentalConsentDialog = require(ParentParentParent.VerifiedParentalConsentDialog).VerifiedParentalConsentDialog
local v17 = game:DefineFastFlag("CompleteFlowInStudioAccept", false)
local v18 = Roact.Component:extend(script.Name)

function v18.init(p1) -- line: 64
	-- upvalues: HttpService (copy)
	p1.state = {
		analyticId = HttpService:GenerateGUID(false)
	}

	function p1.closeModal() -- line: 69
		-- upvalues: p1 (copy)
		local props = p1.props

		p1:reportUserInput("Cancel")
		props.cancelPurchase()
		p1:closeCentralOverlay()
		p1:UnbindActions()
	end
end
function v18.didUpdate(t1: {[any]: any}, t2: {[any]: any}, _: {[any]: any}) -- line: 79
	local props = t1.props

	if t2.purchaseState ~= props.purchaseState then
		t1:reportModalShown()
		t1:dispatchCentralOverlayAndRenderModal(props)
	end
end
function v18.UnbindActions(p2) -- line: 88
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), ContextActionService (copy), Constants (copy)
	if getEnableCentralOverlayForUpsellPrompt() and p2.props.dispatchCentralOverlay then
		ContextActionService:UnbindAction(Constants.CLOSE_MODAL_ACTION)
	end
end
function v18.BindCancelAction(p3) -- line: 94
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), ContextActionService (copy), Constants (copy)
	if getEnableCentralOverlayForUpsellPrompt() and p3.props.dispatchCentralOverlay then
		ContextActionService:BindAction(Constants.CLOSE_MODAL_ACTION, p3.closeModal, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
	end
end
function v18.closeCentralOverlay(p4) -- line: 110
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy)
	local props = p4.props

	if getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay then
		props.dispatchCentralOverlay()
	end
end
function v18.constructPremiumUpsellPromptAnimatorObj(p5) -- line: 118
	-- upvalues: getPartialPageModalMiddleContentWidth (copy), PremiumUpsellFlowState (copy), Roact (copy), PremiumUpsellPrompt (copy), v17 (copy)
	local props = p5.props
	local v30 = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	return {
		shouldAnimate = true,
		shouldShow = props.purchaseState == PremiumUpsellFlowState.PurchaseModal,
		animateDown = v30 == 492,
		renderChildren = function() -- line: 127
			-- upvalues: Roact (copy), PremiumUpsellPrompt (copy), props (copy), p5 (copy), v17 (copy)
			return Roact.createElement(PremiumUpsellPrompt, {
				screenSize = props.screenSize,
				isCatalog = props.isCatalog,
				currencySymbol = props.currencySymbol,
				robuxPrice = props.robuxPrice,
				robuxAmount = props.robuxAmount,
				acceptControllerIcon = props.acceptControllerIcon,
				purchasePremiumActivated = function() -- line: 139
					-- upvalues: p5 (copy), props (copy), v17 (copy)
					p5:reportUserInput("Subscribe")
					props.purchasePremium()

					if v17 and game:GetService("RunService"):IsStudio() then
						props.flowComplete()
					end

					p5:closeCentralOverlay()
				end,
				cancelPurchaseActivated = function() -- line: 147
					-- upvalues: p5 (copy), props (copy)
					p5:reportUserInput("Cancel")
					props.cancelPurchase()
					p5:closeCentralOverlay()
				end
			})
		end
	}
end
function v18.constructPurchaseErrorPromptAnimatorObj(p6) -- line: 157
	-- upvalues: PremiumUpsellFlowState (copy), Roact (copy), PurchaseErrorPrompt (copy)
	local props = p6.props

	return {
		shouldAnimate = true,
		shouldShow = props.purchaseState == PremiumUpsellFlowState.Error,
		renderChildren = function() -- line: 163
			-- upvalues: Roact (copy), PurchaseErrorPrompt (copy), props (copy), p6 (copy)
			return Roact.createElement(PurchaseErrorPrompt, {
				screenSize = props.screenSize,
				errorType = props.errorType,
				economicRestrictionError = props.economicRestrictionError,
				doneControllerIcon = props.acceptControllerIcon,
				doneActivated = function() -- line: 172
					-- upvalues: p6 (copy), props (copy)
					p6:reportUserInput("Done")
					props.flowComplete()
					p6:closeCentralOverlay()
				end
			})
		end
	}
end
function v18.constructPurchaseVPCPromptAnimatorObj(p7) -- line: 182
	-- upvalues: PremiumUpsellFlowState (copy), Roact (copy), VerifiedParentalConsentDialog (copy)
	local props = p7.props

	p7:BindCancelAction()

	return {
		shouldAnimate = true,
		shouldShow = props.purchaseState == PremiumUpsellFlowState.PurchaseVPCModal,
		renderChildren = function() -- line: 190
			-- upvalues: Roact (copy), VerifiedParentalConsentDialog (copy), props (copy), p7 (copy)
			return Roact.createElement(VerifiedParentalConsentDialog, {
				isActionable = false,
				screenSize = props.screenSize,
				modalType = props.purchaseVPCType,
				onDismiss = function() -- line: 195
					-- upvalues: p7 (copy), props (copy)
					p7:reportUserInput("Cancel")
					props.cancelPurchase()
					p7:closeCentralOverlay()
				end
			})
		end
	}
end
function v18.dispatchCentralOverlayAndRenderModal(t4: {[any]: any}, t5: {[any]: any}) -- line: 205
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), PremiumUpsellFlowState (copy), Constants (copy)
	if not getEnableCentralOverlayForUpsellPrompt() or not t5.dispatchCentralOverlay then
		return
	end

	local purchaseState = t5.purchaseState

	if purchaseState == PremiumUpsellFlowState.PurchaseModal then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructPremiumUpsellPromptAnimatorObj())
	end

	if purchaseState == PremiumUpsellFlowState.Error then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructPurchaseErrorPromptAnimatorObj())
	end

	if purchaseState == PremiumUpsellFlowState.PurchaseVPCModal then
		t5.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, t4:constructPurchaseVPCPromptAnimatorObj())
	end
end
function v18.reportModalShown(p8) -- line: 236
	-- upvalues: getModalShownEventData (copy), PremiumUpsellFlowState (copy), HttpService (copy)
	local props = p8.props
	local state = p8.state

	if not p8.props.onAnalyticEvent then
		return
	end

	local v41 = getModalShownEventData(state.analyticId, props.eventPrefix, "PremiumUpsell", PremiumUpsellFlowState.toRawValue(props.purchaseState), HttpService:JSONEncode({
		universe_id = tostring(game.GameId)
	}))

	props.onAnalyticEvent("UserPurchaseFlow", v41)
end
function v18.reportUserInput(t6: {[any]: any}, s1: string) -- line: 257
	-- upvalues: getUserInputEventData (copy), PremiumUpsellFlowState (copy), HttpService (copy)
	local props = t6.props
	local state = t6.state

	if not t6.props.onAnalyticEvent then
		return
	end

	local v46 = getUserInputEventData(state.analyticId, props.eventPrefix, "PremiumUpsell", PremiumUpsellFlowState.toRawValue(props.purchaseState), s1, HttpService:JSONEncode({
		universe_id = tostring(game.GameId)
	}))

	props.onAnalyticEvent("UserPurchaseFlow", v46)
end
function v18.getChildrenElements(p9) -- line: 280
	-- upvalues: Roact (copy), Animator (copy)
	return {
		PremiumUpsellPromptAnimator = Roact.createElement(Animator, p9:constructPremiumUpsellPromptAnimatorObj()),
		PurchaseErrorPromptAnimator = Roact.createElement(Animator, p9:constructPurchaseErrorPromptAnimatorObj()),
		PurchaseVPCPromptAnimator = Roact.createElement(Animator, p9:constructPurchaseVPCPromptAnimatorObj())
	}
end
function v18.render(p10) -- line: 288
	-- upvalues: getEnableCentralOverlayForUpsellPrompt (copy), Roact (copy)
	local props = p10.props
	local t7 = {}

	if not getEnableCentralOverlayForUpsellPrompt() or not props.dispatchCentralOverlay then
		t7 = p10:getChildrenElements()
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, t7)
end

return v18
