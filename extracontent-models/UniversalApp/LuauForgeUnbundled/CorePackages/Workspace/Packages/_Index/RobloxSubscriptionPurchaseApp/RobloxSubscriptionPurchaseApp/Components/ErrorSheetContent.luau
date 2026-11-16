local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local ErrorReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").Hooks.useLocalization
local completeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/completeRobloxSubscriptionUpsellFlow")

local sheet = Foundation.Sheet
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local button = Foundation.Button
local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local fillBehavior = Foundation.Enums.FillBehavior
local buttonVariant = Foundation.Enums.ButtonVariant

local function mapErrorReasonToCopy(p2, data)
	local v6 = ({
		[ErrorReason.GenericError] = { data.GenericErrorTitle, data.GenericErrorBody },
		[ErrorReason.AlreadySubscribed] = { data.AlreadySubscribedTitle, data.AlreadySubscribedBody },
		[ErrorReason.UnsupportedPlatform] = { data.UnsupportedPlatformTitle, data.UnsupportedPlatformBody },
		[ErrorReason.ReferralIneligible] = { data.GenericErrorTitle, data.ReferralIneligibleBody },
		[ErrorReason.ReferralSelfReferral] = { data.GenericErrorTitle, data.ReferralSelfReferralBody }
	})[p2]

	if v6 then
		return { title = v6[1], body = v6[2] }
	end

	return { title = data.GenericErrorTitle, body = data.GenericErrorBody }
end

local function useErrorSheetSlots()
	local v5 = RobloxSubscriptionStore.get()
	local v6 = SignalsReact.useSignalState(v5.getErrorReason)
	local v7 = useTokens()
	local v8 = useLocalization({
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

	local v9 = React.useMemo(function()
		return mapErrorReasonToCopy(v6, v8)
	end, { v6, v8 })

	local v10 = React.useCallback(function()
		completeRobloxSubscriptionUpsellFlow()
	end, {})

	return React.useMemo(function()
		return {
			Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
				TitleRow = React.createElement(view, {
					LayoutOrder = 1,
					tag = "auto-xy gap-small row"
				}, {
					Title = React.createElement(text, {
						Text = v9.title,
						tag = "auto-xy text-heading-small content-emphasis text-align-x-center"
					})
				})
			}),
			Content = React.createElement(sheet.Content, { LayoutOrder = 2 }, {
				Body = React.createElement(
					view,
					{
						tag = "col size-full-0 auto-y align-x-center gap-medium padding-x-large"
					},
					{
						CenterIcon = React.createElement(icon, {
							LayoutOrder = 1,
							name = iconName.TriangleExclamation,
							size = v7.Size.Size_1200
						}),
						BodyText = React.createElement(text, {
							LayoutOrder = 2,
							Text = v9.body,
							tag = "size-full-0 auto-y text-body-medium content-default text-align-x-center text-wrap"
						})
					}
				)
			}),
			Actions = React.createElement(sheet.Actions, { LayoutOrder = 3 }, {
				React.createElement(
					view,
					{
						LayoutOrder = 1,
						tag = "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium"
					},
					{ React.createElement(button, {
							LayoutOrder = 1,
							text = v8.okButton,
							onActivated = v10,
							fillBehavior = fillBehavior.Fill,
							variant = buttonVariant.Emphasis
						}) }
				)
			})
		}
	end, { v9, v8.okButton, v10 })
end

return useErrorSheetSlots
