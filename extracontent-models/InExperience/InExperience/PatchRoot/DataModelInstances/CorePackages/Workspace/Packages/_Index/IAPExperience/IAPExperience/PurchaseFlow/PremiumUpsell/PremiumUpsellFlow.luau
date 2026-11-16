local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local UIBlox = require(parent3.UIBlox)
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth

local PremiumUpsellFlowState = require(parent.PremiumUpsellFlowState)

local Animator = require(parent2.Generic.Animator)
local Constants = require(parent2.Generic.Constants)

local PurchaseErrorPrompt = require(parent2.Generic.PurchaseErrorPrompt)
local PremiumUpsellPrompt = require(parent2.PremiumUpsell.PremiumUpsellPrompt)

local getModalShownEventData = require(parent2.Utility.getModalShownEventData)
local getUserInputEventData = require(parent2.Utility.getUserInputEventData)

local getEnableCentralOverlayForUpsellPrompt = require(parent2.Flags.getEnableCentralOverlayForUpsellPrompt)

local VerifiedParentalConsentDialog = require(parent3.VerifiedParentalConsentDialog)
local verifiedParentalConsentDialog = VerifiedParentalConsentDialog.VerifiedParentalConsentDialog

local defineFastFlag = game:DefineFastFlag("CompleteFlowInStudioAccept", false)

local extended = Roact.Component:extend(script.Name)

function extended:init()
	self.state = {
		analyticId = HttpService:GenerateGUID(false)
	}

	function self.closeModal()
		local props = self.props
		self:reportUserInput("Cancel")
		props.cancelPurchase()
		self:closeCentralOverlay()

		self:UnbindActions()
	end
end

function extended:didUpdate(p, _)
	local props = self.props

	if p.purchaseState ~= props.purchaseState then
		self:reportModalShown()
		self:dispatchCentralOverlayAndRenderModal(props)
	end
end

function extended:UnbindActions()
	if getEnableCentralOverlayForUpsellPrompt() and self.props.dispatchCentralOverlay then
		ContextActionService:UnbindAction(Constants.CLOSE_MODAL_ACTION)
	end
end

function extended:BindCancelAction()
	if getEnableCentralOverlayForUpsellPrompt() and self.props.dispatchCentralOverlay then
		ContextActionService:BindAction(
			Constants.CLOSE_MODAL_ACTION,
			self.closeModal,
			false,
			Enum.KeyCode.ButtonB,
			Enum.KeyCode.Escape
		)
	end
end

function extended:closeCentralOverlay()
	local props = self.props

	if getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay then
		props.dispatchCentralOverlay()
	end
end

function extended:constructPremiumUpsellPromptAnimatorObj()
	local props = self.props

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	return {
		shouldShow = props.purchaseState == PremiumUpsellFlowState.PurchaseModal,
		shouldAnimate = true,
		animateDown = partialPageModalMiddleContentWidth == 492,
		renderChildren = function()
			return Roact.createElement(PremiumUpsellPrompt, {
				screenSize = props.screenSize,
				isCatalog = props.isCatalog,
				currencySymbol = props.currencySymbol,
				robuxPrice = props.robuxPrice,
				robuxAmount = props.robuxAmount,
				acceptControllerIcon = props.acceptControllerIcon,
				purchasePremiumActivated = function()
					self:reportUserInput("Subscribe")
					props.purchasePremium()

					if defineFastFlag then
						local RunService = game:GetService("RunService")

						if RunService:IsStudio() then
							props.flowComplete()
						end
					end

					self:closeCentralOverlay()
				end,
				cancelPurchaseActivated = function()
					self:reportUserInput("Cancel")
					props.cancelPurchase()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:constructPurchaseErrorPromptAnimatorObj()
	local props = self.props

	return {
		shouldShow = props.purchaseState == PremiumUpsellFlowState.Error,
		shouldAnimate = true,
		renderChildren = function()
			return Roact.createElement(PurchaseErrorPrompt, {
				screenSize = props.screenSize,
				errorType = props.errorType,
				economicRestrictionError = props.economicRestrictionError,
				doneControllerIcon = props.acceptControllerIcon,
				doneActivated = function()
					self:reportUserInput("Done")
					props.flowComplete()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:constructPurchaseVPCPromptAnimatorObj()
	local props = self.props

	self:BindCancelAction()

	return {
		shouldShow = props.purchaseState == PremiumUpsellFlowState.PurchaseVPCModal,
		shouldAnimate = true,
		renderChildren = function()
			return Roact.createElement(verifiedParentalConsentDialog, {
				screenSize = props.screenSize,
				isActionable = false,
				modalType = props.purchaseVPCType,
				onDismiss = function()
					self:reportUserInput("Cancel")
					props.cancelPurchase()
					self:closeCentralOverlay()
				end
			})
		end
	}
end

function extended:dispatchCentralOverlayAndRenderModal(p)
	if not (getEnableCentralOverlayForUpsellPrompt() and p.dispatchCentralOverlay) then
		return
	end

	local purchaseState = p.purchaseState

	if purchaseState == PremiumUpsellFlowState.PurchaseModal then
		p.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructPremiumUpsellPromptAnimatorObj()
		)
	end

	if purchaseState == PremiumUpsellFlowState.Error then
		p.dispatchCentralOverlay(
			Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR,
			self:constructPurchaseErrorPromptAnimatorObj()
		)
	end

	if purchaseState == PremiumUpsellFlowState.PurchaseVPCModal then
		p.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, self:constructPurchaseVPCPromptAnimatorObj())
	end
end

function extended:reportModalShown()
	local props = self.props
	local state = self.state

	if not self.props.onAnalyticEvent then
		return
	end

	local modalShownEventData = getModalShownEventData(
		state.analyticId,
		props.eventPrefix,
		"PremiumUpsell",
		PremiumUpsellFlowState.toRawValue(props.purchaseState),
		HttpService:JSONEncode({ universe_id = tostring(game.GameId) })
	)

	props.onAnalyticEvent("UserPurchaseFlow", modalShownEventData)
end

function extended:reportUserInput(p: string)
	local props = self.props
	local state = self.state

	if not self.props.onAnalyticEvent then
		return
	end

	local userInputEventData = getUserInputEventData(
		state.analyticId,
		props.eventPrefix,
		"PremiumUpsell",
		PremiumUpsellFlowState.toRawValue(props.purchaseState),
		p,
		HttpService:JSONEncode({ universe_id = tostring(game.GameId) })
	)

	props.onAnalyticEvent("UserPurchaseFlow", userInputEventData)
end

function extended:getChildrenElements()
	return {
		PremiumUpsellPromptAnimator = Roact.createElement(Animator, self:constructPremiumUpsellPromptAnimatorObj()),
		PurchaseErrorPromptAnimator = Roact.createElement(Animator, self:constructPurchaseErrorPromptAnimatorObj()),
		PurchaseVPCPromptAnimator = Roact.createElement(Animator, self:constructPurchaseVPCPromptAnimatorObj())
	}
end

function extended:render()
	local props = self.props

	local v = getEnableCentralOverlayForUpsellPrompt() and props.dispatchCentralOverlay and {}
		or self:getChildrenElements()

	return Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, v)
end

return extended
