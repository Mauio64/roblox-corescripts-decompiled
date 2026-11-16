local LocalizationService = game:GetService("LocalizationService")

local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")
local roact = PurchasePromptDeps.Roact
local rodux = PurchasePromptDeps.Rodux
local roactRodux = PurchasePromptDeps.RoactRodux
local provider = PurchasePromptDeps.UIBlox.Style.Provider
local localeProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").Locale.LocaleProvider
local toast = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ToastLite").Components.Toast

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/Reducer")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ABTest")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PlatformInterface")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/EventConnections")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/LayoutValuesProvider")
local provideRobloxLocale = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/provideRobloxLocale")
local PurchasePromptPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/PurchasePromptPolicy")

local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/ProductPurchase/ProductPurchaseContainer")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/RobuxUpsell/RobuxUpsellContainer")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/SubscriptionPurchase/SubscriptionPurchaseContainer")
local renderWithCoreScriptsStyleProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/renderWithCoreScriptsStyleProvider")
local FocusNavigationOptimizationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/FocusNavigationOptimizationTelemetry")
local selectionCursorProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UIBlox").App.SelectionImage.SelectionCursorProvider
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ReactFocusNavigation")

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/FocusNavigationUtils")
local provider2 = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local GetFFlagEnableToastLiteRender = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableToastLiteRender")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
local fFlagAddCursorProviderToPurchasePromptApp = SharedFlags.FFlagAddCursorProviderToPurchasePromptApp
local fFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions

local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

local defineFastFlag = game:DefineFastFlag("PurchasePromptAppConditionalFocusNavigation", false)

local defineFastFlag2 = game:DefineFastFlag("PurchasePromptAppTrackRenderPerformance", false)

local extended = roact.Component:extend("PurchasePromptApp")

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
	local v5 = now - self.lastRenderTime

	if self.renderCount > 1 then
		local v6 = v5 * 1000
		LoggingProtocol.default:logRobloxTelemetryStat(FocusNavigationOptimizationTelemetry.RerenderTimingStat, v6, {
			optimizationEnabled = tostring(defineFastFlag)
		})
	end

	self.lastRenderTime = now
end

function extended:renderWithStyle(p3)
	return renderWithCoreScriptsStyleProvider(p3)
end

function extended:render()
	return provideRobloxLocale(function()
		local createElement = roact.createElement
		local v6 = { locale = LocalizationService.RobloxLocaleId }

		local createElement2 = roact.createElement
		local v9 = if fFlagPurchasePromptSubtitleForTimedOptions then self.props.subtitleView else nil
		local children = {
			LocaleProvider = createElement(localeProvider, v6, {
				ProductPurchaseContainer = createElement2(module8, {
					subtitleView = v9,
					network = self.props.network
				}),
				RobuxUpsellContainer = roact.createElement(module9, {
					network = self.props.network
				}),
				SubscriptionPurchaseContainer = roact.createElement(module10)
			}),
			EventConnections = roact.createElement(module4),
			Toast = 0
		}
		local v10 = if GetFFlagEnableToastLiteRender() then roact.createElement(toast) else nil
		children.Toast = v10

		local v11 = fFlagAddCursorProviderToPurchasePromptApp and self:hasAnyActivePrompt()
		local v12 = roact.createElement("Folder", nil, children)

		if v11 then
			self:trackRenderPerformance()

			v12 = {
				CursorProvider = roact.createElement(selectionCursorProvider, {}, {
					FocusNavigationProvider = roact.createElement(
						ReactFocusNavigation.FocusNavigationContext.Provider,
						{ value = focusNavigationService },
						{
							FocusNavigationRegistryProvider = roact.createElement(provider2, nil, {
								FocusNavigationCoreScriptsWrapper = roact.createElement(
									focusRoot,
									{
										surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
										isIsolated = true,
										isAutoFocusRoot = true
									},
									v12
								)
							})
						}
					)
				})
			}
		end

		return roact.createElement(roactRodux.StoreProvider, {
			store = self.props.store
		}, {
			StyleProvider = self:renderWithStyle({
				LayoutValuesProvider = roact.createElement(
					module5,
					{ isTenFootInterface = self.state.isTenFootInterface },
					{
						PolicyProvider = roact.createElement(PurchasePromptPolicy.Provider, {
							policy = { PurchasePromptPolicy.Mapper }
						}, v12)
					}
				)
			})
		})
	end)
end

return extended
