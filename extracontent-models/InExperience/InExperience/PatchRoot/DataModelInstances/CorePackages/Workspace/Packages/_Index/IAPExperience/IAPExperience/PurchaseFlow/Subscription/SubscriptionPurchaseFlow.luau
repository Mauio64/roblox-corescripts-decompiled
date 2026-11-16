local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local UIBlox = require(parent3.UIBlox)
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth

local SubscriptionPurchaseFlowState = require(parent.SubscriptionPurchaseFlowState)

local Animator = require(parent2.Generic.Animator)
local PurchaseErrorPrompt = require(parent2.Generic.PurchaseErrorPrompt)

local SubscriptionPurchasePrompt = require(parent2.Subscription.SubscriptionPurchasePrompt)

local formatSubscriptionPurchaseEventData = require(parent2.Utility.formatSubscriptionPurchaseEventData)

local extended = Roact.Component:extend(script.Name)

local generic = parent2.Generic
local PurchaseFlowType = require(generic.PurchaseFlowType)

local VerifiedParentalConsentDialog = require(parent3.VerifiedParentalConsentDialog)
local verifiedParentalConsentDialog = VerifiedParentalConsentDialog.VerifiedParentalConsentDialog

function extended:init()
	self.state = {
		analyticId = HttpService:GenerateGUID(false)
	}
end

function extended:didUpdate(p, _)
	local props = self.props

	if p.purchaseState ~= props.purchaseState then
		self:reportPurchaseEvent("ViewShown")
	end
end

function extended:reportUserInput(p: string)
	self:reportPurchaseEvent("UserInput", p)
end

function extended:reportPurchaseEvent(p: string, p2: string?)
	local props = self.props

	if not props.onAnalyticEvent then
		return
	end

	local v = formatSubscriptionPurchaseEventData(
		self.state.analyticId,
		p,
		SubscriptionPurchaseFlowState.toRawValue(props.purchaseState),
		p2,
		props.subscriptionProviderId,
		props.subscriptionId,
		props.name,
		props.description,
		props.period,
		props.priceTier,
		props.displayPrice
	)

	props.onAnalyticEvent("SubscriptionPurchase", v)
end

function extended:render()
	local props = self.props
	local purchaseState = props.purchaseState

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	return Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		SubscriptionPurchasePromptAnimator = Roact.createElement(Animator, {
			shouldShow = purchaseState == SubscriptionPurchaseFlowState.PurchaseModal,
			shouldAnimate = true,
			animateDown = partialPageModalMiddleContentWidth == 492,
			renderChildren = function()
				local createElement = Roact.createElement
				local v = {
					name = props.name,
					subscriptionProviderName = props.subscriptionProviderName,
					displayPrice = props.displayPrice,
					period = props.period,
					disclaimerText = props.disclaimerText,
					description = props.description,
					itemIcon = props.itemIcon,
					disablePurchase = props.disablePurchase,
					disablePurchaseText = props.disablePurchaseText,
					shouldUseNewModalDesign = props.shouldUseNewModalDesign,
					isRobuxSubscription = props.isRobuxSubscription,
					creatorName = props.creatorName,
					creatorVerified = props.creatorVerified,
					primaryPaymentMethod = props.primaryPaymentMethod,
					secondaryPaymentMethod = props.secondaryPaymentMethod,
					isTestingMode = props.isTestingMode,
					screenSize = props.screenSize,
					purchaseSubscriptionActivated = function(p: string)
						self:reportUserInput("Subscribe")
						props.purchaseSubscription(p)

						if props.isTestingMode then
							props.flowComplete()
						end
					end,
					cancelPurchaseActivated = function()
						self:reportUserInput("Cancel")
						props.cancelPurchase()
					end,
					onReport = 0,
					onShare = 0
				}
				local onReport

				if props.shouldUseNewModalDesign then
					onReport = props.onReport
				end

				v.onReport = onReport
				local onShare

				if props.shouldUseNewModalDesign then
					onShare = props.onShare
				end

				v.onShare = onShare
				return createElement(SubscriptionPurchasePrompt, v)
			end
		}),
		PurchaseErrorPromptAnimator = Roact.createElement(Animator, {
			shouldShow = purchaseState == SubscriptionPurchaseFlowState.Error,
			shouldAnimate = true,
			renderChildren = function()
				return Roact.createElement(PurchaseErrorPrompt, {
					screenSize = props.screenSize,
					errorType = props.errorType,
					economicRestrictionError = props.economicRestrictionError,
					flowType = PurchaseFlowType.Subscription,
					doneControllerIcon = props.acceptControllerIcon,
					doneActivated = function()
						self:reportUserInput("Done")
						props.flowComplete()
					end
				})
			end
		}),
		PurchaseVPCPromptAnimator = Roact.createElement(Animator, {
			shouldShow = purchaseState == SubscriptionPurchaseFlowState.PurchaseVPCModal,
			shouldAnimate = true,
			renderChildren = function()
				return Roact.createElement(verifiedParentalConsentDialog, {
					screenSize = props.screenSize,
					isActionable = props.openSettingsPage ~= nil,
					modalType = props.purchaseVPCType,
					onAction = props.openSettingsPage and function()
						self:reportUserInput("Confirm")
						props.openSettingsPage()
						props.flowComplete()
					end,
					onDismiss = function()
						self:reportUserInput("Cancel")
						props.cancelPurchase()
					end
				})
			end
		})
	})
end

return extended
