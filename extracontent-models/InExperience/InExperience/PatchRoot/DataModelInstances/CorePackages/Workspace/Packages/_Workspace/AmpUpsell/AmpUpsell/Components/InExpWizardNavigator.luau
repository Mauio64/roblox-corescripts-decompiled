local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local RoactNavigation = require(AmpUpsellParent.RoactNavigation)
local React = require(AmpUpsellParent.React)
local WizardContainer = require(AmpUpsell.Components.WizardContainer)
local ActionTypeEnum = require(AmpUpsell.Common.Enums).ActionTypeEnum
local useNavigation = require(AmpUpsellParent.Navigation).useNavigation
local createLazyComponent = require(AmpUpsellParent.RoactUtils).Components.createLazyComponent
local FAEUpsellContainer = require(AmpUpsell.Components.Upsells.FacialAgeEstimation.FAEUpsellContainer)
local IDVUpsellContainer = require(AmpUpsell.Components.Upsells.IdentityVerification.IDVUpsellContainer)
local Cryo = require(AmpUpsellParent.Cryo)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local WebViewServiceWrapper = require(AmpUpsell.Components.WebViewServiceWrapper)
local UrlBuilder = require(AmpUpsellParent.UrlBuilder).UrlBuilder
local AccountSettingsUpsell = require(AmpUpsell.Components.Upsells.AccountSettingsUpsell)
local VPCUpsellContainer = require(AmpUpsell.Components.Upsells.ParentalRequest.VPCUpsellContainer)
local RobloxSubscriptionPurchaseApp = require(AmpUpsellParent.RobloxSubscriptionPurchaseApp)
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

local function v21(p1) -- line: 45
	-- upvalues: useNavigation (copy), React (copy), AppScreens (copy), UrlBuilder (copy), Cryo (copy), ActionTypeEnum (copy), WizardContainer (copy)
	local v24 = useNavigation()
	local v25 = React.useCallback(function(p2) -- line: 48
		-- upvalues: v24 (copy), AppScreens (copy), UrlBuilder (copy), Cryo (copy)
		local v37 = Cryo.Dictionary.join(p2 or {}, {
			openAccountSettings = function(p3) -- line: 49
				-- upvalues: v24 (copy), AppScreens (copy), UrlBuilder (copy)
				v24.push(AppScreens.GenericWebPage, {
					detail = UrlBuilder.static.settings.account(),
					extraProps = {
						title = p3
					}
				})
			end
		})

		v24.push("AccountSettingsUpsell", {
			extraProps = v37
		})
	end, { v24 })
	local v26 = React.useCallback(function(p4) -- line: 62
		-- upvalues: v24 (copy)
		v24.push("IDVUpsell", {
			extraProps = p4
		})
	end, { v24 })
	local t1 = {
		[ActionTypeEnum.AgeEstimation] = React.useCallback(function(p5) -- line: 67
			-- upvalues: v24 (copy)
			v24.push("FAEUpsell", {
				extraProps = p5
			})
		end, { v24 }),
		[ActionTypeEnum.GovernmentId] = v26,
		[ActionTypeEnum.Subscription] = React.useCallback(function(p6) -- line: 71
			-- upvalues: v24 (copy)
			v24.push("SubscriptionUpsell", {
				extraProps = p6
			})
		end, { v24 }),
		[ActionTypeEnum.ParentConsent] = React.useCallback(function(p7) -- line: 74
			-- upvalues: v24 (copy)
			v24.push("VPCUpsell", {
				extraProps = p7
			})
		end, { v24 }),
		[ActionTypeEnum.ParentLink] = React.useCallback(function(p8) -- line: 77
			-- upvalues: v24 (copy)
			v24.push("VPCUpsell", {
				extraProps = p8
			})
		end, { v24 })
	}
	local v28 = Cryo.Dictionary.join(p1 or {}, {
		openUpsells = t1,
		openAccountSettingsUpsell = v25
	})

	return React.createElement(WizardContainer, v28)
end

local v22 = RoactNavigation.createRobloxStackNavigator({
	{
		Wizard = {
			screen = function(p9) -- line: 93
				-- upvalues: useNavigation (copy), React (copy), v21 (copy)
				local v30 = useNavigation().getParam("extraProps") or (not p9 or not p9.screenProps or p9.screenProps.extraProps)

				return React.createElement(v21, v30)
			end,
			navigationOptions = {
				transparent = true,
				overlayEnabled = true
			}
		}
	},
	{
		FAEUpsell = {
			screen = createLazyComponent(function() -- line: 110
				-- upvalues: FAEUpsellContainer (copy)
				return FAEUpsellContainer
			end),
			navigationOptions = {
				transparent = true,
				overlayEnabled = true
			}
		}
	},
	{
		IDVUpsell = {
			screen = createLazyComponent(function() -- line: 121
				-- upvalues: useNavigation (copy), React (copy), IDVUpsellContainer (copy)
				return function() -- line: 122
					-- upvalues: useNavigation (copy), React (copy), IDVUpsellContainer (copy)
					local v43 = useNavigation().getParam("extraProps")

					return React.createElement(IDVUpsellContainer, v43)
				end
			end),
			navigationOptions = {
				transparent = true,
				overlayEnabled = true
			}
		}
	},
	{
		SubscriptionUpsell = {
			screen = function(p10) -- line: 136
				-- upvalues: React (copy), RobloxSubscriptionPurchaseApp (copy), RobloxSubscriptionFlowCompleteReason (copy), SurfaceName (copy)
				local v32 = p10.navigation.getParam("extraProps") or {}

				React.useEffect(function() -- line: 152
					-- upvalues: RobloxSubscriptionPurchaseApp (copy), v32 (copy), RobloxSubscriptionFlowCompleteReason (copy), SurfaceName (copy)
					local v44 = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(v32.purchaseUIOptions, {
						onFlowComplete = function(p11) -- line: 156
							-- upvalues: RobloxSubscriptionFlowCompleteReason (copy), v32 (copy)
							if p11 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
								if v32.onSuccess then
									v32.onSuccess()

									return
								end
							elseif p11 == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed then
								if v32.onFailure then
									v32.onFailure()

									return
								end

								if v32.onCancel then
									v32.onCancel()

									return
								end
							elseif v32.onCancel then
								v32.onCancel()
							end
						end
					}, nil, v32.surfaceName or SurfaceName.Unspecified, v32.surfaceContext or RobloxSubscriptionPurchaseApp.SurfaceContext.Unspecified, nil, v32.analyticsContext)

					return function() -- line: 186
						-- upvalues: v44 (copy)
						if v44 then
							v44()
						end
					end
				end, {
					v32.analyticsContext,
					v32.onCancel,
					v32.onFailure,
					v32.onSuccess,
					v32.purchaseUIOptions,
					v32.surfaceContext,
					v32.surfaceName
				})

				return React.createElement(React.Fragment, {})
			end,
			navigationOptions = {
				transparent = true,
				overlayEnabled = false
			}
		}
	},
	{
		AccountSettingsUpsell = {
			screen = createLazyComponent(function() -- line: 214
				-- upvalues: useNavigation (copy), React (copy), AccountSettingsUpsell (copy)
				return function() -- line: 215
					-- upvalues: useNavigation (copy), React (copy), AccountSettingsUpsell (copy)
					local v45 = useNavigation().getParam("extraProps")

					return React.createElement(AccountSettingsUpsell, v45)
				end
			end),
			navigationOptions = {
				transparent = true,
				overlayEnabled = true
			}
		}
	},
	{
		VPCUpsell = {
			screen = createLazyComponent(function() -- line: 229
				-- upvalues: useNavigation (copy), React (copy), VPCUpsellContainer (copy)
				return function() -- line: 230
					-- upvalues: useNavigation (copy), React (copy), VPCUpsellContainer (copy)
					local v46 = useNavigation().getParam("extraProps")

					return React.createElement(VPCUpsellContainer, v46)
				end
			end),
			navigationOptions = {
				transparent = true,
				overlayEnabled = true
			}
		}
	},
	{
		[AppScreens.GenericWebPage] = {
			screen = function() -- line: 245
				-- upvalues: useNavigation (copy), WebViewServiceWrapper (copy)
				local v33 = useNavigation()
				local v34 = v33.getParam("detail")
				local v35 = v33.getParam("extraProps")

				WebViewServiceWrapper.new({
					url = v34,
					title = v35.title or "",
					closeCallback = function() -- line: 252
						-- upvalues: v33 (copy), v35 (copy)
						v33.pop()

						if v35.onClose then
							v35.onClose()
						end
					end
				}):open()
			end,
			navigationOptions = {
				transparent = true,
				overlayEnabled = true
			}
		}
	}
}, {
	initialRouteName = "Wizard",
	transitionConfig = function() -- line: 272
		return {
			transitionSpec = {
				frequency = 100000,
				dampingRatio = 1
			}
		}
	end
})

return (RoactNavigation.createAppContainer(v22))
