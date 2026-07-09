local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Foundation = require(RobloxSubscriptionPurchaseAppParent.Foundation)
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local handleBackButtonAction = require(RobloxSubscriptionPurchaseApp.Actions.handleBackButtonAction)
local View = Foundation.View
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local Button = Foundation.Button
local getIconRichText = Foundation.Utility.getIconRichText
local Enums = Foundation.Enums
local IconName = Enums.IconName
local FillBehavior = Enums.FillBehavior
local ButtonVariant = Enums.ButtonVariant

require(RobloxSubscriptionPurchaseApp.types)

local RobloxSubscriptionPriceRow = require(script.Parent.RobloxSubscriptionPriceRow)
local RobloxSubscriptionFeatureList = require(script.Parent.RobloxSubscriptionFeatureList)
local LegalDisclosure = require(script.Parent.LegalDisclosure)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local performRobloxSubscriptionPurchase = require(RobloxSubscriptionPurchaseApp.Actions.performRobloxSubscriptionPurchase)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local useLocalization = require(RobloxSubscriptionPurchaseAppParent.Localization).Hooks.useLocalization
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)
local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local isRobloxSubscriptionProductFreeTrial = require(RobloxSubscriptionPurchaseApp.Utils.isRobloxSubscriptionProductFreeTrial)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local SignalsReact = require(RobloxSubscriptionPurchaseAppParent.SignalsReact)
local FFlagSupportFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportFreeTrial)
local FFlagSupportFreeTrialPriceRow = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportFreeTrialPriceRow)
local FFlagRobloxPlusFAEFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusFAEFreeTrial)
local t1 = {
	[PromptState.SubscriptionPurchaseInProgress] = true,
	[PromptState.SubscriptionStatusPolling] = true
}

local function useBlackbirdSheetSlots() -- line: 57
	-- upvalues: RobloxSubscriptionStore (copy), FFlagRobloxPlusFAEFreeTrial (copy), SignalsReact (copy), useLocalization (copy), isRobloxSubscriptionProductFreeTrial (copy), React (copy), FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), PromptState (copy), finalizeRobloxSubscriptionUpsellFlow (copy), completeRobloxSubscriptionUpsellFlow (copy), performRobloxSubscriptionPurchase (copy), t1 (copy), Sheet (copy), View (copy), FoundationText (copy), getIconRichText (copy), IconName (copy), handleBackButtonAction (copy), RobloxSubscriptionPriceRow (copy), FFlagSupportFreeTrialPriceRow (copy), RobloxSubscriptionFeatureList (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy), LegalDisclosure (copy), FFlagSupportFreeTrial (copy)
	local v35 = RobloxSubscriptionStore.get()
	local v36 = if not FFlagRobloxPlusFAEFreeTrial then nil else v35.getOnCtaOverride()
	local v37 = SignalsReact.useSignalState(v35.getPurchaseUIOptions)
	local v38 = SignalsReact.useSignalState(v35.getPromptState)
	local v39 = useLocalization({
		title = "Feature.RobloxSubscription.Title.GetBlackbird",
		buttonText = "Feature.RobloxSubscription.Action.Subscribe",
		getFreeTrialText = "Feature.RobloxSubscription.Action.TryItForFree"
	})
	local v40 = SignalsReact.useSignalState(v35.getRobloxSubscriptionProduct)
	local v41 = isRobloxSubscriptionProductFreeTrial(v40)
	local v42 = if not FFlagRobloxPlusFAEFreeTrial then nil else v37.description
	local v43 = if not v41 then v39.buttonText else v39.getFreeTrialText
	local v44 = v37.showLegalDisclosure == nil or v37.showLegalDisclosure
	local v45 = not not FFlagRobloxPlusFAEFreeTrial and (v37.noPurchaseMethodRequired ~= nil and v37.noPurchaseMethodRequired)
	local v46 = React.useCallback(function(p1) -- line: 90
		-- upvalues: FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy)
		if p1 then
			if FFlagEnableSubscriptionPurchaseFlowEventIngest then
				logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalShown")
			end

			logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalShownCounter)
		end
	end, {})

	local function onSubscribe() -- line: 101
		-- upvalues: FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), FFlagRobloxPlusFAEFreeTrial (copy), v36 (copy), v35 (copy), PromptState (copy), finalizeRobloxSubscriptionUpsellFlow (copy), completeRobloxSubscriptionUpsellFlow (copy), performRobloxSubscriptionPurchase (copy)
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellSubscribeClicked")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalBuyButtonClickedCounter)

		if FFlagRobloxPlusFAEFreeTrial and v36 then
			v35.setPromptState(PromptState.SubscriptionPurchaseRequested)
			v36(function() -- line: 113
				-- upvalues: v35 (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
				v35.setDidTryPurchasing(true)
				finalizeRobloxSubscriptionUpsellFlow(true)
			end, function() -- line: 116
				-- upvalues: completeRobloxSubscriptionUpsellFlow (copy)
				completeRobloxSubscriptionUpsellFlow()
			end)

			return
		end

		performRobloxSubscriptionPurchase()
	end

	local v48 = t1[v38] == true

	return {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, {
			View = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row gap-small auto-xy"
			}, {
				BackButton = if not v37.showBackButton then nil else React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "gap-small auto-xy text-heading-small text-align-x-center content-emphasis",
					RichText = true,
					Text = `{ getIconRichText(IconName.ChevronLargeLeft) }`,
					onActivated = handleBackButtonAction
				}),
				Title = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-heading-small text-align-x-center content-emphasis",
					RichText = true,
					Text = `{ getIconRichText(IconName.RobloxPlus) } { v37.title or v39.title }`
				})
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			ContentContainer = React.createElement(View, {
				tag = {
					["col size-full-0 auto-y"] = FFlagRobloxPlusFAEFreeTrial and v42 ~= nil,
					col = not (FFlagRobloxPlusFAEFreeTrial and v42 ~= nil)
				},
				Size = if not FFlagRobloxPlusFAEFreeTrial or v42 == nil then UDim2.new(1, 0, 0, 140) else nil
			}, {
				PriceRow = if not FFlagRobloxPlusFAEFreeTrial or v42 == nil then React.createElement(RobloxSubscriptionPriceRow, {
					layoutOrder = 1,
					isFreeTrial = if not FFlagSupportFreeTrialPriceRow then nil else v41
				}) else React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					Text = v42
				}),
				FeatureList = React.createElement(RobloxSubscriptionFeatureList, {
					layoutOrder = 2,
					noPurchaseMethodRequired = v45
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, {
			ActionsContainer = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row wrap align-x-center gap-medium size-full-0 auto-xy"
			}, {
				SubscribeButton = React.createElement(Button, {
					LayoutOrder = 1,
					ref = v46,
					text = if not FFlagRobloxPlusFAEFreeTrial or not v37.ctaText then v43 else v37.ctaText,
					onActivated = onSubscribe,
					fillBehavior = FillBehavior.Fill,
					variant = ButtonVariant.Emphasis,
					isLoading = v48
				}),
				LegalDisclosure = if not not FFlagRobloxPlusFAEFreeTrial and not v44 then nil else React.createElement(LegalDisclosure, {
					layoutOrder = 2,
					ctaText = if not FFlagRobloxPlusFAEFreeTrial or not v37.ctaText then v43 else v37.ctaText,
					isFreeTrial = if not FFlagSupportFreeTrial then nil else v41,
					shortenFreeTrialTerms = if not FFlagRobloxPlusFAEFreeTrial then nil else v45
				})
			})
		})
	}
end

return useBlackbirdSheetSlots
