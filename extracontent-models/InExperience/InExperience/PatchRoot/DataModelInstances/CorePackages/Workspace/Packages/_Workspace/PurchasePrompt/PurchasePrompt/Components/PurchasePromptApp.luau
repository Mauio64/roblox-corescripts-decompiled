game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local LoggingProtocol = require(parent.LoggingProtocol)
local Roact = PurchasePromptDeps.Roact
local Rodux = PurchasePromptDeps.Rodux
local RoactRodux = PurchasePromptDeps.RoactRodux
local Provider = PurchasePromptDeps.UIBlox.Style.Provider
local IAPExperience = require(parent.IAPExperience)
local LocaleProvider = IAPExperience.Locale.LocaleProvider
local ToastLite = require(parent.ToastLite)
local Toast = ToastLite.Components.Toast

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
local SubscriptionPurchaseContainer = require(script.Parent.SubscriptionPurchase.SubscriptionPurchaseContainer)
local renderWithCoreScriptsStyleProvider = require(script.Parent.Connection.renderWithCoreScriptsStyleProvider)
local FocusNavigationOptimizationTelemetry = require(PurchasePrompt.Events.FocusNavigationOptimizationTelemetry)
local UIBlox = require(parent.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local GetFFlagEnableToastLiteRender = require(PurchasePrompt.Flags.GetFFlagEnableToastLiteRender)
local SharedFlags = require(parent.SharedFlags)
local FFlagAddCursorProviderToPurchasePromptApp = SharedFlags.FFlagAddCursorProviderToPurchasePromptApp
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions

local RequestType = require(PurchasePrompt.Enums.RequestType)
local PromptState = require(PurchasePrompt.Enums.PromptState)

local defineFastFlag = game:DefineFastFlag("PurchasePromptAppConditionalFocusNavigation", false)

local defineFastFlag2 = game:DefineFastFlag("PurchasePromptAppTrackRenderPerformance", false)

local extended = Roact.Component:extend("PurchasePromptApp")

function extended:init()
	self.state = {
		isTenFootInterface = ExternalSettings.new().isTenFootInterface()
	}

	self.renderCount = 0
	self.lastRenderTime = 0
end

function extended:hasAnyActivePrompt(): boolean
	if not defineFastFlag then
		return true
	end

	if not self.props.store then
		return false
	end

	local state = self.props.store:getState()
	local promptState = state.promptState
	local requestType = state.promptRequest.requestType

	return promptState ~= PromptState.None or requestType ~= RequestType.None
end

function extended:trackRenderPerformance()
	if not defineFastFlag2 then
		return
	end

	self.renderCount += 1
	local now = tick()
	local v = now - self.lastRenderTime

	if self.renderCount > 1 then
		local v2 = v * 1000
		LoggingProtocol.default:logRobloxTelemetryStat(FocusNavigationOptimizationTelemetry.RerenderTimingStat, v2, {
			optimizationEnabled = tostring(defineFastFlag)
		})
	end

	self.lastRenderTime = now
end

function extended:renderWithStyle(p)
	return renderWithCoreScriptsStyleProvider(p)
end

function extended:render()
	return provideRobloxLocale(function()
		local createElement = Roact.createElement
		local v = { locale = LocalizationService.RobloxLocaleId }

		local createElement2 = Roact.createElement
		local subtitleView

		if FFlagPurchasePromptSubtitleForTimedOptions then
			subtitleView = self.props.subtitleView
		end

		local children = {
			LocaleProvider = createElement(LocaleProvider, v, {
				ProductPurchaseContainer = createElement2(ProductPurchaseContainer, {
					subtitleView = subtitleView,
					network = self.props.network
				}),
				RobuxUpsellContainer = Roact.createElement(RobuxUpsellContainer, {
					network = self.props.network
				}),
				SubscriptionPurchaseContainer = Roact.createElement(SubscriptionPurchaseContainer)
			}),
			EventConnections = Roact.createElement(EventConnections),
			Toast = 0
		}
		local toast

		if GetFFlagEnableToastLiteRender() then
			toast = Roact.createElement(Toast)
		end

		children.Toast = toast

		local v2 = FFlagAddCursorProviderToPurchasePromptApp and self:hasAnyActivePrompt()
		local v3 = Roact.createElement("Folder", nil, children)

		if v2 then
			self:trackRenderPerformance()

			v3 = {
				CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
					FocusNavigationProvider = Roact.createElement(
						ReactFocusNavigation.FocusNavigationContext.Provider,
						{ value = focusNavigationService },
						{
							FocusNavigationRegistryProvider = Roact.createElement(provider, nil, {
								FocusNavigationCoreScriptsWrapper = Roact.createElement(
									FocusRoot,
									{
										surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
										isIsolated = true,
										isAutoFocusRoot = true
									},
									v3
								)
							})
						}
					)
				})
			}
		end

		return Roact.createElement(RoactRodux.StoreProvider, { store = self.props.store }, {
			StyleProvider = self:renderWithStyle({
				LayoutValuesProvider = Roact.createElement(
					LayoutValuesProvider,
					{ isTenFootInterface = self.state.isTenFootInterface },
					{
						PolicyProvider = Roact.createElement(PurchasePromptPolicy.Provider, {
							policy = { PurchasePromptPolicy.Mapper }
						}, v3)
					}
				)
			})
		})
	end)
end

return extended
