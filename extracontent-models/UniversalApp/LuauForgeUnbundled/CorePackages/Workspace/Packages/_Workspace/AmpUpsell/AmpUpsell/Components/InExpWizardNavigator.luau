local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactNavigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local WizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/WizardContainer")
local actionTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums").ActionTypeEnum

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Navigation").useNavigation
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Components.createLazyComponent
local FAEUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FAEUpsellContainer")
local IDVUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/IDVUpsellContainer")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Cryo")
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
local WebViewServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/WebViewServiceWrapper")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UrlBuilder").UrlBuilder
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/AccountSettingsUpsell")
local VPCUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/ParentalRequest/VPCUpsellContainer")
local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RobloxSubscriptionPurchaseApp")
local robloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName

local v5 = {
	Wizard = "Wizard",
	FAEUpsell = "FAEUpsell",
	IDVUpsell = "IDVUpsell",
	AccountSettingsUpsell = "AccountSettingsUpsell",
	SubscriptionUpsell = "SubscriptionUpsell",
	VPCUpsell = "VPCUpsell"
}

local function fn(options)
	local v6 = useNavigation()

	local v7 = React.useCallback(function(options2)
		local function fn2(p2)
			v6.push(AppScreens.GenericWebPage, {
				detail = urlBuilder.static.settings.account(),
				extraProps = { title = p2 }
			})
		end

		local joined = Cryo.Dictionary.join(options2 or {}, {
			openAccountSettings = fn2
		})
		v6.push("AccountSettingsUpsell", { extraProps = joined })
	end, { v6 })

	local v8 = React.useCallback(function(p2)
		v6.push("IDVUpsell", { extraProps = p2 })
	end, { v6 })

	local v9 = {
		[actionTypeEnum.AgeEstimation] = React.useCallback(function(p2)
			v6.push("FAEUpsell", { extraProps = p2 })
		end, { v6 }),
		[actionTypeEnum.GovernmentId] = v8,
		[actionTypeEnum.Subscription] = React.useCallback(function(p2)
			v6.push("SubscriptionUpsell", { extraProps = p2 })
		end, { v6 }),
		[actionTypeEnum.ParentConsent] = React.useCallback(function(p2)
			v6.push("VPCUpsell", { extraProps = p2 })
		end, { v6 }),
		[actionTypeEnum.ParentLink] = React.useCallback(function(p2)
			v6.push("VPCUpsell", { extraProps = p2 })
		end, { v6 })
	}

	local joined = Cryo.Dictionary.join(options or {}, {
		openUpsells = v9,
		openAccountSettingsUpsell = v7
	})

	return React.createElement(WizardContainer, joined)
end

local robloxStackNavigator = RoactNavigation.createRobloxStackNavigator({
	{
		Wizard = {
			screen = function(p2)
				local v11 = useNavigation().getParam("extraProps")

				if not v11 and p2 and p2.screenProps then
					v11 = p2.screenProps.extraProps
				end

				return React.createElement(fn, v11)
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
			screen = function(p2)
				local v11 = p2.navigation.getParam("extraProps") or {}
				React.useEffect(function()
					local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(
						v11.purchaseUIOptions,
						{
							onFlowComplete = function(p3)
								if p3 == robloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
									if v11.onSuccess then
										v11.onSuccess()
									end
								elseif p3 == robloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
									if v11.onFailure then
										v11.onFailure()
									elseif v11.onCancel then
										v11.onCancel()
									end
								elseif v11.onCancel then
									v11.onCancel()
								end
							end
						},
						nil,
						v11.surfaceName or surfaceName.Unspecified,
						v11.surfaceContext or RobloxSubscriptionPurchaseApp.SurfaceContext.Unspecified,
						nil,
						v11.analyticsContext
					)

					return function()
						if initiateRobloxSubscriptionPurchase then
							initiateRobloxSubscriptionPurchase()
						end
					end
				end, {
					v11.analyticsContext,
					v11.onCancel,
					v11.onFailure,
					v11.onSuccess,
					v11.purchaseUIOptions,
					v11.surfaceContext,
					v11.surfaceName
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
					return React.createElement(module9, param)
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
				local v11 = useNavigation()
				local param = v11.getParam("detail")
				local param2 = v11.getParam("extraProps")
				WebViewServiceWrapper.new({
					url = param,
					title = param2.title or "",
					closeCallback = function()
						v11.pop()

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
