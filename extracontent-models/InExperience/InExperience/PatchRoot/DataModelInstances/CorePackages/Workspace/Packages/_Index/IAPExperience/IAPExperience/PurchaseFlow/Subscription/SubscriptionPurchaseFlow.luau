local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local getPartialPageModalMiddleContentWidth = require(ParentParentParent.UIBlox).App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local SubscriptionPurchaseFlowState = require(scriptParent.SubscriptionPurchaseFlowState)
local Animator = require(ParentParent.Generic.Animator)
local PurchaseErrorPrompt = require(ParentParent.Generic.PurchaseErrorPrompt)
local SubscriptionPurchasePrompt = require(ParentParent.Subscription.SubscriptionPurchasePrompt)
local getEnableDisableSubPurchase = require(ParentParent.Flags.getEnableDisableSubPurchase)
local formatSubscriptionPurchaseEventData = require(ParentParent.Utility.formatSubscriptionPurchaseEventData)
local v13 = Roact.Component:extend(script.Name)
local Generic = ParentParent.Generic
local PurchaseFlowType = require(Generic.PurchaseFlowType)
local VerifiedParentalConsentDialog = require(ParentParentParent.VerifiedParentalConsentDialog).VerifiedParentalConsentDialog

function v13.init(p1) -- line: 79
	-- upvalues: HttpService (copy)
	p1.state = {
		analyticId = HttpService:GenerateGUID(false)
	}
end
function v13.didUpdate(t1: {[any]: any}, t2: {[any]: any}, _: {[any]: any}) -- line: 85
	local props = t1.props

	if t2.purchaseState ~= props.purchaseState then
		t1:reportPurchaseEvent("ViewShown")
	end
end
function v13.reportUserInput(t4: {[any]: any}, s1: string) -- line: 93
	t4:reportPurchaseEvent("UserInput", s1)
end
function v13.reportPurchaseEvent(t5: {[any]: any}, s2: string, s3: string?) -- line: 97
	-- upvalues: formatSubscriptionPurchaseEventData (copy), SubscriptionPurchaseFlowState (copy)
	local props = t5.props

	if not props.onAnalyticEvent then
		return
	end

	local v28 = formatSubscriptionPurchaseEventData(t5.state.analyticId, s2, SubscriptionPurchaseFlowState.toRawValue(props.purchaseState), s3, props.subscriptionProviderId, props.subscriptionId, props.name, props.description, props.period, props.priceTier, props.displayPrice)

	props.onAnalyticEvent("SubscriptionPurchase", v28)
end
function v13.render(p2) -- line: 121
	-- upvalues: getPartialPageModalMiddleContentWidth (copy), Roact (copy), Animator (copy), SubscriptionPurchaseFlowState (copy), SubscriptionPurchasePrompt (copy), getEnableDisableSubPurchase (copy), PurchaseErrorPrompt (copy), PurchaseFlowType (copy), VerifiedParentalConsentDialog (copy)
	local props = p2.props
	local purchaseState = props.purchaseState
	local v32 = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		SubscriptionPurchasePromptAnimator = Roact.createElement(Animator, {
			shouldAnimate = true,
			shouldShow = purchaseState == SubscriptionPurchaseFlowState.PurchaseModal,
			animateDown = v32 == 492,
			renderChildren = function() -- line: 135
				-- upvalues: Roact (copy), SubscriptionPurchasePrompt (copy), props (copy), getEnableDisableSubPurchase (copy), p2 (copy)
				return Roact.createElement(SubscriptionPurchasePrompt, {
					name = props.name,
					subscriptionProviderName = props.subscriptionProviderName,
					displayPrice = props.displayPrice,
					period = props.period,
					disclaimerText = props.disclaimerText,
					description = props.description,
					itemIcon = props.itemIcon,
					disablePurchase = if not getEnableDisableSubPurchase() and not props.shouldUseNewModalDesign then nil else props.disablePurchase,
					disablePurchaseText = if not getEnableDisableSubPurchase() and not props.shouldUseNewModalDesign then nil else props.disablePurchaseText,
					shouldUseNewModalDesign = props.shouldUseNewModalDesign,
					isRobuxSubscription = props.isRobuxSubscription,
					creatorName = props.creatorName,
					creatorVerified = props.creatorVerified,
					primaryPaymentMethod = props.primaryPaymentMethod,
					secondaryPaymentMethod = props.secondaryPaymentMethod,
					isTestingMode = props.isTestingMode,
					screenSize = props.screenSize,
					purchaseSubscriptionActivated = function(s4: string) -- line: 161
						-- upvalues: p2 (copy), props (copy)
						p2:reportUserInput("Subscribe")
						props.purchaseSubscription(s4)

						if props.isTestingMode then
							props.flowComplete()
						end
					end,
					cancelPurchaseActivated = function() -- line: 168
						-- upvalues: p2 (copy), props (copy)
						p2:reportUserInput("Cancel")
						props.cancelPurchase()
					end,
					onReport = if not props.shouldUseNewModalDesign then nil else props.onReport,
					onShare = if not props.shouldUseNewModalDesign then nil else props.onShare
				})
			end
		}),
		PurchaseErrorPromptAnimator = Roact.createElement(Animator, {
			shouldAnimate = true,
			shouldShow = purchaseState == SubscriptionPurchaseFlowState.Error,
			renderChildren = function() -- line: 180
				-- upvalues: Roact (copy), PurchaseErrorPrompt (copy), props (copy), PurchaseFlowType (copy), p2 (copy)
				return Roact.createElement(PurchaseErrorPrompt, {
					screenSize = props.screenSize,
					errorType = props.errorType,
					economicRestrictionError = props.economicRestrictionError,
					flowType = PurchaseFlowType.Subscription,
					doneControllerIcon = props.acceptControllerIcon,
					doneActivated = function() -- line: 189
						-- upvalues: p2 (copy), props (copy)
						p2:reportUserInput("Done")
						props.flowComplete()
					end
				})
			end
		}),
		PurchaseVPCPromptAnimator = Roact.createElement(Animator, {
			shouldAnimate = true,
			shouldShow = purchaseState == SubscriptionPurchaseFlowState.PurchaseVPCModal,
			renderChildren = function() -- line: 199
				-- upvalues: Roact (copy), VerifiedParentalConsentDialog (copy), props (copy), p2 (copy)
				return Roact.createElement(VerifiedParentalConsentDialog, {
					screenSize = props.screenSize,
					isActionable = props.openSettingsPage ~= nil,
					modalType = props.purchaseVPCType,
					onAction = props.openSettingsPage and function() -- line: 204
						-- upvalues: p2 (copy), props (copy)
						p2:reportUserInput("Confirm")
						props.openSettingsPage()
						props.flowComplete()
					end,
					onDismiss = function() -- line: 209
						-- upvalues: p2 (copy), props (copy)
						p2:reportUserInput("Cancel")
						props.cancelPurchase()
					end
				})
			end
		})
	})
end

return v13
