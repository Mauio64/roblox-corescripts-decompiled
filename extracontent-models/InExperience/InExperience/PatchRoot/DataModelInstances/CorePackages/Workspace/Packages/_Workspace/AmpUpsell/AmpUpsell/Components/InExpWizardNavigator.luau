local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local RoactNavigation = require(parent.RoactNavigation)
local React = require(parent.React)
local WizardContainer = require(AmpUpsell.Components.WizardContainer)
local Enums = require(AmpUpsell.Common.Enums)
local ActionTypeEnum = Enums.ActionTypeEnum

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local createLazyComponent = RoactUtils.Components.createLazyComponent
local FAEUpsellContainer = require(AmpUpsell.Components.Upsells.FacialAgeEstimation.FAEUpsellContainer)
local IDVUpsellContainer = require(AmpUpsell.Components.Upsells.IdentityVerification.IDVUpsellContainer)
local Cryo = require(parent.Cryo)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local WebViewServiceWrapper = require(AmpUpsell.Components.WebViewServiceWrapper)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local AccountSettingsUpsell = require(AmpUpsell.Components.Upsells.AccountSettingsUpsell)
local VPCUpsellContainer = require(AmpUpsell.Components.Upsells.ParentalRequest.VPCUpsellContainer)
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName

local _ = {
	Wizard = "Wizard",
	FAEUpsell = "FAEUpsell",
	IDVUpsell = "IDVUpsell",
	AccountSettingsUpsell = "AccountSettingsUpsell",
	SubscriptionUpsell = "SubscriptionUpsell",
	VPCUpsell = "VPCUpsell"
}

local function fn(options)
	local v = useNavigation()

	local openAccountSettingsUpsell = React.useCallback(function(options2)
		local function fn2(title)
			v.push(AppScreens.GenericWebPage, {
				detail = urlBuilder.static.settings.account(),
				extraProps = { title = title }
			})
		end

		local joined = Cryo.Dictionary.join(options2 or {}, { openAccountSettings = fn2 })
		v.push("AccountSettingsUpsell", { extraProps = joined })
	end, { v })

	local v2 = React.useCallback(function(extraProps)
		v.push("IDVUpsell", { extraProps = extraProps })
	end, { v })

	local openUpsells = {
		[ActionTypeEnum.AgeEstimation] = React.useCallback(function(extraProps)
			v.push("FAEUpsell", { extraProps = extraProps })
		end, { v }),
		[ActionTypeEnum.GovernmentId] = v2,
		[ActionTypeEnum.Subscription] = React.useCallback(function(extraProps)
			v.push("SubscriptionUpsell", { extraProps = extraProps })
		end, { v }),
		[ActionTypeEnum.ParentConsent] = React.useCallback(function(extraProps)
			v.push("VPCUpsell", { extraProps = extraProps })
		end, { v }),
		[ActionTypeEnum.ParentLink] = React.useCallback(function(extraProps)
			v.push("VPCUpsell", { extraProps = extraProps })
		end, { v })
	}

	local joined = Cryo.Dictionary.join(options or {}, {
		openUpsells = openUpsells,
		openAccountSettingsUpsell = openAccountSettingsUpsell
	})

	return React.createElement(WizardContainer, joined)
end

local robloxStackNavigator = RoactNavigation.createRobloxStackNavigator({
	{
		Wizard = {
			screen = function(p)
				local v = useNavigation().getParam("extraProps")

				if not v and p and p.screenProps then
					v = p.screenProps.extraProps
				end

				return React.createElement(fn, v)
			end,
			navigationOptions = { transparent = true, overlayEnabled = true }
		}
	},
	{
		FAEUpsell = {
			screen = createLazyComponent(function()
				return FAEUpsellContainer
			end),
			navigationOptions = { transparent = true, overlayEnabled = true }
		}
	},
	{
		IDVUpsell = {
			screen = createLazyComponent(function()
				return function()
					local param = useNavigation().getParam("extraProps")
					return React.createElement(IDVUpsellContainer, param)
				end
			end),
			navigationOptions = { transparent = true, overlayEnabled = true }
		}
	},
	{
		SubscriptionUpsell = {
			screen = function(p)
				local v = p.navigation.getParam("extraProps") or {}
				React.useEffect(function()
					local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(
						v.purchaseUIOptions,
						{
							onFlowComplete = function(p2)
								if p2 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
									if v.onSuccess then
										v.onSuccess()
									end
								elseif p2 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
									if v.onFailure then
										v.onFailure()
									elseif v.onCancel then
										v.onCancel()
									end
								elseif v.onCancel then
									v.onCancel()
								end
							end
						},
						nil,
						v.surfaceName or SurfaceName.Unspecified,
						v.surfaceContext or RobloxSubscriptionPurchaseApp.SurfaceContext.Unspecified,
						nil,
						v.analyticsContext
					)

					return function()
						if initiateRobloxSubscriptionPurchase then
							initiateRobloxSubscriptionPurchase()
						end
					end
				end, {
					v.analyticsContext,
					v.onCancel,
					v.onFailure,
					v.onSuccess,
					v.purchaseUIOptions,
					v.surfaceContext,
					v.surfaceName
				})

				return React.createElement(React.Fragment, {})
			end,
			navigationOptions = { transparent = true, overlayEnabled = false }
		}
	},
	{
		AccountSettingsUpsell = {
			screen = createLazyComponent(function()
				return function()
					local param = useNavigation().getParam("extraProps")
					return React.createElement(AccountSettingsUpsell, param)
				end
			end),
			navigationOptions = { transparent = true, overlayEnabled = true }
		}
	},
	{
		VPCUpsell = {
			screen = createLazyComponent(function()
				return function()
					local param = useNavigation().getParam("extraProps")
					return React.createElement(VPCUpsellContainer, param)
				end
			end),
			navigationOptions = { transparent = true, overlayEnabled = true }
		}
	},
	{
		[AppScreens.GenericWebPage] = {
			screen = function()
				local v = useNavigation()
				local param = v.getParam("detail")
				local param2 = v.getParam("extraProps")
				WebViewServiceWrapper.new({
					url = param,
					title = param2.title or "",
					closeCallback = function()
						v.pop()

						if param2.onClose then
							param2.onClose()
						end
					end
				}):open()
			end,
			navigationOptions = { transparent = true, overlayEnabled = true }
		}
	}
}, {
	initialRouteName = "Wizard",
	transitionConfig = function()
		return {
			transitionSpec = { frequency = 100000, dampingRatio = 1 }
		}
	end
})

return (RoactNavigation.createAppContainer(robloxStackNavigator))
