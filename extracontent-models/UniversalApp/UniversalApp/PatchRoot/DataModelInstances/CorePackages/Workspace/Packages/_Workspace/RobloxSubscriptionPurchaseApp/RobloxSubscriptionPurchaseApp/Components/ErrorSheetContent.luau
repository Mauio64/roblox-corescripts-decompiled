local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Foundation = require(RobloxSubscriptionPurchaseAppParent.Foundation)
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local SignalsReact = require(RobloxSubscriptionPurchaseAppParent.SignalsReact)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local useLocalization = require(RobloxSubscriptionPurchaseAppParent.Localization).Hooks.useLocalization
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local Sheet = Foundation.Sheet
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Button = Foundation.Button
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local FillBehavior = Foundation.Enums.FillBehavior
local ButtonVariant = Foundation.Enums.ButtonVariant

local function mapErrorReasonToCopy(p1, t1: {[any]: any}) -- line: 32
	-- upvalues: ErrorReason (copy)
	local v23 = ({
		[ErrorReason.GenericError] = {
			t1.GenericErrorTitle,
			t1.GenericErrorBody
		},
		[ErrorReason.AlreadySubscribed] = {
			t1.AlreadySubscribedTitle,
			t1.AlreadySubscribedBody
		},
		[ErrorReason.UnsupportedPlatform] = {
			t1.UnsupportedPlatformTitle,
			t1.UnsupportedPlatformBody
		}
	})[p1]

	if v23 then
		return {
			title = v23[1],
			body = v23[2]
		}
	end

	return {
		title = t1.GenericErrorTitle,
		body = t1.GenericErrorBody
	}
end
local function useErrorSheetSlots() -- line: 59
	-- upvalues: RobloxSubscriptionStore (copy), SignalsReact (copy), useTokens (copy), useLocalization (copy), React (copy), mapErrorReasonToCopy (copy), completeRobloxSubscriptionUpsellFlow (copy), Sheet (copy), View (copy), FoundationText (copy), Icon (copy), IconName (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy)
	local v24 = RobloxSubscriptionStore.get()
	local v25 = SignalsReact.useSignalState(v24.getErrorReason)
	local v26 = useTokens()
	local v27 = useLocalization({
		okButton = "Features.Transfers.Action.Ok",
		GenericErrorTitle = "Feature.RobloxSubscription.Title.GenericError",
		GenericErrorBody = "Feature.RobloxSubscription.Body.GenericError",
		AlreadySubscribedTitle = "Feature.RobloxSubscription.Title.AlreadySubscribed",
		AlreadySubscribedBody = "Feature.RobloxSubscription.Body.AlreadySubscribed",
		UnsupportedPlatformTitle = "Feature.RobloxSubscription.Title.UnsupportedPlatform",
		UnsupportedPlatformBody = "Feature.RobloxSubscription.Body.UnsupportedPlatform"
	})
	local v28 = React.useMemo(function() -- line: 73
		-- upvalues: mapErrorReasonToCopy (copy), v25 (copy), v27 (copy)
		return (mapErrorReasonToCopy(v25, v27))
	end, {
		v25,
		v27
	})
	local v29 = React.useCallback(function() -- line: 77
		-- upvalues: completeRobloxSubscriptionUpsellFlow (copy)
		completeRobloxSubscriptionUpsellFlow()
	end, {})

	return React.useMemo(function() -- line: 81
		-- upvalues: React (copy), Sheet (copy), View (copy), FoundationText (copy), v28 (copy), Icon (copy), IconName (copy), v26 (copy), Button (copy), v27 (copy), v29 (copy), FillBehavior (copy), ButtonVariant (copy)
		return {
			Header = React.createElement(Sheet.Header, {
				hasCloseAffordance = true
			}, {
				TitleRow = React.createElement(View, {
					LayoutOrder = 1,
					tag = "auto-xy gap-small row"
				}, {
					Title = React.createElement(FoundationText, {
						tag = "auto-xy text-heading-small content-emphasis text-align-x-center",
						Text = v28.title
					})
				})
			}),
			Content = React.createElement(Sheet.Content, {
				LayoutOrder = 2
			}, {
				Body = React.createElement(View, {
					tag = "col size-full-0 auto-y align-x-center gap-medium padding-x-large"
				}, {
					CenterIcon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = IconName.TriangleExclamation,
						size = v26.Size.Size_1200
					}),
					BodyText = React.createElement(FoundationText, {
						LayoutOrder = 2,
						tag = "size-full-0 auto-y text-body-medium content-default text-align-x-center text-wrap",
						Text = v28.body
					})
				})
			}),
			Actions = React.createElement(Sheet.Actions, {
				LayoutOrder = 3
			}, { React.createElement(View, {
				LayoutOrder = 1,
				tag = "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium"
			}, { React.createElement(Button, {
				LayoutOrder = 1,
				text = v27.okButton,
				onActivated = v29,
				fillBehavior = FillBehavior.Fill,
				variant = ButtonVariant.Emphasis
			}) }) })
		}
	end, {
		v28,
		v27.okButton,
		v29
	})
end

return useErrorSheetSlots
