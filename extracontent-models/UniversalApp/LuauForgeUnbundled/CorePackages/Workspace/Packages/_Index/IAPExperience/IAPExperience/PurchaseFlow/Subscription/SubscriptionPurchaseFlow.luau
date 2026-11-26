local HttpService = game:GetService("HttpService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local getPartialPageModalMiddleContentWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox").App.Dialog.Modal.getPartialPageModalMiddleContentWidth

local SubscriptionPurchaseFlowState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/Subscription/SubscriptionPurchaseFlowState")

local Animator = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Animator")
local PurchaseErrorPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PurchaseErrorPrompt")

local SubscriptionPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Subscription/SubscriptionPurchasePrompt")

local formatSubscriptionPurchaseEventData = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatSubscriptionPurchaseEventData")

local extended = Roact.Component:extend("SubscriptionPurchaseFlow")

local PurchaseFlowType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PurchaseFlowType")

local verifiedParentalConsentDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/VerifiedParentalConsentDialog").VerifiedParentalConsentDialog

function extended:init()
	self.state = {
		analyticId = HttpService:GenerateGUID(false)
	}
end

function extended:didUpdate(p2, p3)
	local props = self.props

	if p2.purchaseState ~= props.purchaseState then
		self:reportPurchaseEvent("ViewShown")
	end
end

function extended:reportUserInput(p2)
	self:reportPurchaseEvent("UserInput", p2)
end

function extended:reportPurchaseEvent(p3, p4)
	local props = self.props

	if not props.onAnalyticEvent then
		return
	end

	local v5 = formatSubscriptionPurchaseEventData(
		self.state.analyticId,
		p3,
		SubscriptionPurchaseFlowState.toRawValue(props.purchaseState),
		p4,
		props.subscriptionProviderId,
		props.subscriptionId,
		props.name,
		props.description,
		props.period,
		props.priceTier,
		props.displayPrice
	)

	props.onAnalyticEvent("SubscriptionPurchase", v5)
end

function extended:render()
	local props = self.props
	local purchaseState = props.purchaseState

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		SubscriptionPurchasePromptAnimator = Roact.createElement(Animator, {
			shouldShow = purchaseState == SubscriptionPurchaseFlowState.PurchaseModal,
			shouldAnimate = true,
			animateDown = partialPageModalMiddleContentWidth == 492,
			renderChildren = function()
				local createElement = Roact.createElement
				local v6 = {
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
					purchaseSubscriptionActivated = function(p2)
						self:reportUserInput("Subscribe")
						props.purchaseSubscription(p2)

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
				local v7 = if props.shouldUseNewModalDesign then props.onReport else nil
				v6.onReport = v7
				local v8 = if props.shouldUseNewModalDesign then props.onShare else nil
				v6.onShare = v8
				return createElement(SubscriptionPurchasePrompt, v6)
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
