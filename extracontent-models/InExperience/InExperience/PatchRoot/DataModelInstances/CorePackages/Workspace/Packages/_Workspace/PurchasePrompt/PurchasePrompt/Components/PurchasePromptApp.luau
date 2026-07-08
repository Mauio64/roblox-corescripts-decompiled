game:GetService("CoreGui")

local LocalizationService = game:GetService("LocalizationService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local LoggingProtocol = require(PurchasePromptParent.LoggingProtocol)
local Roact = PurchasePromptDeps.Roact
local _ = PurchasePromptDeps.Rodux
local RoactRodux = PurchasePromptDeps.RoactRodux
local _ = PurchasePromptDeps.UIBlox.Style.Provider
local LocaleProvider = require(PurchasePromptParent.IAPExperience).Locale.LocaleProvider
local Toast = require(PurchasePromptParent.ToastLite).Components.Toast

require(PurchasePrompt.Reducers.Reducer)
require(PurchasePrompt.Services.ABTest)
require(PurchasePrompt.Services.Network)
require(PurchasePrompt.Services.Analytics)
require(PurchasePrompt.Services.PlatformInterface)

local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)

require(PurchasePrompt.Thunk)

local EventConnections = require(script.Parent.Connection.EventConnections)
local LayoutValuesProvider = require(script.Parent.Connection.LayoutValuesProvider)
local provideRobloxLocale = require(script.Parent.Connection.provideRobloxLocale)
local PurchasePromptPolicy = require(PurchasePrompt.Components.Connection.PurchasePromptPolicy)
local ProductPurchaseContainer = require(script.Parent.ProductPurchase.ProductPurchaseContainer)
local RobuxUpsellContainer = require(script.Parent.RobuxUpsell.RobuxUpsellContainer)
local PremiumUpsellContainer = require(script.Parent.PremiumUpsell.PremiumUpsellContainer)
local SubscriptionPurchaseContainer = require(script.Parent.SubscriptionPurchase.SubscriptionPurchaseContainer)
local renderWithCoreScriptsStyleProvider = require(script.Parent.Connection.renderWithCoreScriptsStyleProvider)
local FocusNavigationOptimizationTelemetry = require(PurchasePrompt.Events.FocusNavigationOptimizationTelemetry)
local SelectionCursorProvider = require(PurchasePromptParent.UIBlox).App.SelectionImage.SelectionCursorProvider
local ReactFocusNavigation = require(PurchasePromptParent.ReactFocusNavigation)
local v25 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(PurchasePromptParent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local GetFFlagEnableToastLiteRender = require(PurchasePrompt.Flags.GetFFlagEnableToastLiteRender)
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local FFlagAddCursorProviderToPurchasePromptApp = SharedFlags.FFlagAddCursorProviderToPurchasePromptApp
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local RequestType = require(PurchasePrompt.Enums.RequestType)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local v37 = game:DefineFastFlag("PurchasePromptAppConditionalFocusNavigation", false)
local v38 = game:DefineFastFlag("PurchasePromptAppTrackRenderPerformance", false)
local v39 = game:DefineFastFlag("PurchasePromptAppFixStyleLink", false)
local v40 = Roact.Component:extend("PurchasePromptApp")

function v40.init(p1) -- line: 65
	-- upvalues: ExternalSettings (copy)
	p1.state = {
		isTenFootInterface = ExternalSettings.new().isTenFootInterface()
	}
	p1.renderCount = 0
	p1.lastRenderTime = 0
end
function v40.hasAnyActivePrompt(p2) -- line: 77
	-- upvalues: v37 (copy), PromptState (copy), RequestType (copy)
	if not v37 then
		return true
	end

	if not p2.props.store then
		return false
	end

	local v43 = p2.props.store:getState()
	local promptState = v43.promptState
	local requestType = v43.promptRequest.requestType

	return not (promptState == PromptState.None and requestType == RequestType.None)
end
function v40.trackRenderPerformance(p3) -- line: 96
	-- upvalues: v38 (copy), LoggingProtocol (copy), FocusNavigationOptimizationTelemetry (copy), v37 (copy)
	if not v38 then
		return
	end

	p3.renderCount = p3.renderCount + 1

	local timestamp = tick()
	local v48 = timestamp - p3.lastRenderTime

	if p3.renderCount > 1 then
		local v49 = v48 * 1000

		LoggingProtocol.default:logRobloxTelemetryStat(FocusNavigationOptimizationTelemetry.RerenderTimingStat, v49, {
			optimizationEnabled = tostring(v37)
		})
	end

	p3.lastRenderTime = timestamp
end
function v40.renderWithStyle(_, p5) -- line: 120
	-- upvalues: renderWithCoreScriptsStyleProvider (copy)
	return renderWithCoreScriptsStyleProvider(p5)
end
function v40.render(p6) -- line: 124
	-- upvalues: provideRobloxLocale (copy), Roact (copy), LocaleProvider (copy), LocalizationService (copy), ProductPurchaseContainer (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), FFlagPurchasePromptCartPricingEnabled (copy), RobuxUpsellContainer (copy), PremiumUpsellContainer (copy), SubscriptionPurchaseContainer (copy), EventConnections (copy), GetFFlagEnableToastLiteRender (copy), Toast (copy), FFlagAddCursorProviderToPurchasePromptApp (copy), v39 (copy), SelectionCursorProvider (copy), ReactFocusNavigation (copy), v25 (copy), Provider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), RoactRodux (copy), LayoutValuesProvider (copy), PurchasePromptPolicy (copy)
	return provideRobloxLocale(function() -- line: 125
		-- upvalues: Roact (copy), LocaleProvider (copy), LocalizationService (copy), ProductPurchaseContainer (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), p6 (copy), FFlagPurchasePromptCartPricingEnabled (copy), RobuxUpsellContainer (copy), PremiumUpsellContainer (copy), SubscriptionPurchaseContainer (copy), EventConnections (copy), GetFFlagEnableToastLiteRender (copy), Toast (copy), FFlagAddCursorProviderToPurchasePromptApp (copy), v39 (copy), SelectionCursorProvider (copy), ReactFocusNavigation (copy), v25 (copy), Provider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), RoactRodux (copy), LayoutValuesProvider (copy), PurchasePromptPolicy (copy)
		local t1 = {
			LocaleProvider = Roact.createElement(LocaleProvider, {
				locale = LocalizationService.RobloxLocaleId
			}, {
				ProductPurchaseContainer = Roact.createElement(ProductPurchaseContainer, {
					subtitleView = if not FFlagPurchasePromptSubtitleForTimedOptions then nil else p6.props.subtitleView,
					network = if not FFlagPurchasePromptCartPricingEnabled then nil else p6.props.network
				}),
				RobuxUpsellContainer = Roact.createElement(RobuxUpsellContainer, {
					network = if not FFlagPurchasePromptCartPricingEnabled then nil else p6.props.network
				}),
				PremiumUpsellContainer = Roact.createElement(PremiumUpsellContainer),
				SubscriptionPurchaseContainer = Roact.createElement(SubscriptionPurchaseContainer)
			}),
			EventConnections = Roact.createElement(EventConnections),
			Toast = if not GetFFlagEnableToastLiteRender() then nil else Roact.createElement(Toast)
		}
		local v54 = FFlagAddCursorProviderToPurchasePromptApp and p6:hasAnyActivePrompt()

		if v39 then
			t1 = Roact.createElement("Folder", nil, t1)
		end

		if v54 then
			p6:trackRenderPerformance()
			t1 = {
				CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
					FocusNavigationProvider = Roact.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
						value = v25
					}, {
						FocusNavigationRegistryProvider = Roact.createElement(Provider, nil, {
							FocusNavigationCoreScriptsWrapper = Roact.createElement(FocusRoot, {
								isIsolated = true,
								isAutoFocusRoot = true,
								surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
							}, t1)
						})
					})
				})
			}
		end

		return Roact.createElement(RoactRodux.StoreProvider, {
			store = p6.props.store
		}, {
			StyleProvider = p6:renderWithStyle({
				LayoutValuesProvider = Roact.createElement(LayoutValuesProvider, {
					isTenFootInterface = p6.state.isTenFootInterface
				}, {
					PolicyProvider = Roact.createElement(PurchasePromptPolicy.Provider, {
						policy = { PurchasePromptPolicy.Mapper }
					}, t1)
				})
			})
		})
	end)
end

return v40
