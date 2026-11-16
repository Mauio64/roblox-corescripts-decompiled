local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)

local Sheet = Foundation.Sheet
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Button = Foundation.Button
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local FillBehavior = Foundation.Enums.FillBehavior
local ButtonVariant = Foundation.Enums.ButtonVariant

local function mapErrorReasonToCopy(p, data)
	local v = ({
		[ErrorReason.GenericError] = { data.GenericErrorTitle, data.GenericErrorBody },
		[ErrorReason.AlreadySubscribed] = { data.AlreadySubscribedTitle, data.AlreadySubscribedBody },
		[ErrorReason.UnsupportedPlatform] = { data.UnsupportedPlatformTitle, data.UnsupportedPlatformBody },
		[ErrorReason.ReferralIneligible] = { data.GenericErrorTitle, data.ReferralIneligibleBody },
		[ErrorReason.ReferralSelfReferral] = { data.GenericErrorTitle, data.ReferralSelfReferralBody }
	})[p]

	if v then
		return { title = v[1], body = v[2] }
	end

	return { title = data.GenericErrorTitle, body = data.GenericErrorBody }
end

local function useErrorSheetSlots()
	local v = RobloxSubscriptionStore.get()
	local v2 = SignalsReact.useSignalState(v.getErrorReason)
	local v3 = useTokens()
	local v4 = useLocalization({
		okButton = "Features.Transfers.Action.Ok",
		GenericErrorTitle = "Feature.RobloxSubscription.Title.GenericError",
		GenericErrorBody = "Feature.RobloxSubscription.Body.GenericError",
		AlreadySubscribedTitle = "Feature.RobloxSubscription.Title.AlreadySubscribed",
		AlreadySubscribedBody = "Feature.RobloxSubscription.Body.AlreadySubscribed",
		UnsupportedPlatformTitle = "Feature.RobloxSubscription.Title.UnsupportedPlatform",
		UnsupportedPlatformBody = "Feature.RobloxSubscription.Body.UnsupportedPlatform",
		ReferralIneligibleBody = "Feature.RobloxSubscription.Description.NoLongerValidReferralGenericError",
		ReferralSelfReferralBody = "Feature.RobloxSubscription.Message.AlreadySubscribed"
	})

	local v5 = React.useMemo(function()
		return mapErrorReasonToCopy(v2, v4)
	end, { v2, v4 })

	local onActivated = React.useCallback(function()
		completeRobloxSubscriptionUpsellFlow()
	end, {})

	return React.useMemo(function()
		return {
			Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
				TitleRow = React.createElement(View, {
					LayoutOrder = 1,
					tag = "auto-xy gap-small row"
				}, {
					Title = React.createElement(Text, {
						Text = v5.title,
						tag = "auto-xy text-heading-small content-emphasis text-align-x-center"
					})
				})
			}),
			Content = React.createElement(Sheet.Content, { LayoutOrder = 2 }, {
				Body = React.createElement(
					View,
					{ tag = "col size-full-0 auto-y align-x-center gap-medium padding-x-large" },
					{
						CenterIcon = React.createElement(Icon, {
							LayoutOrder = 1,
							name = IconName.TriangleExclamation,
							size = v3.Size.Size_1200
						}),
						BodyText = React.createElement(Text, {
							LayoutOrder = 2,
							Text = v5.body,
							tag = "size-full-0 auto-y text-body-medium content-default text-align-x-center text-wrap"
						})
					}
				)
			}),
			Actions = React.createElement(Sheet.Actions, { LayoutOrder = 3 }, {
				React.createElement(
					View,
					{
						LayoutOrder = 1,
						tag = "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium"
					},
					{ React.createElement(Button, {
							LayoutOrder = 1,
							text = v4.okButton,
							onActivated = onActivated,
							fillBehavior = FillBehavior.Fill,
							variant = ButtonVariant.Emphasis
						}) }
				)
			})
		}
	end, { v5, v4.okButton, onActivated })
end

return useErrorSheetSlots
