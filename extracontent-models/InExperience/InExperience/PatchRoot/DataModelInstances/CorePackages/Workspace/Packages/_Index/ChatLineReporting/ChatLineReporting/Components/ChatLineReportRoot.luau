local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent
local CoreGui = game:GetService("CoreGui")

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Roact = require(parent.Roact)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local UIBlox = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider

local ChatLineReportStepHandler = require(ChatLineReporting.Components.ChatLineReportStepHandler)

local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local focusNavigationService = nil
local v = nil

local function fn()
	if v then
		Roact.unmount(v)
		focusNavigationService:teardown()
	end
end

return {
	initialize = function(messages)
		local element = React.createElement(
			"ScreenGui",
			{
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			},
			{
				LayerCollector = React.createElement(LayerCollectorProvider, {}, {
					LocalizationProvider = Roact.createElement(
						LocalizationProvider,
						{
							localization = Localization.new(LocalizationService.RobloxLocaleId)
						},
						{
							FoundationProvider = React.createElement(FoundationProvider, {
								colorMode = "Dark"
							}, {
								StyleProvider = React.createElement(
									StyleProviderWithDefaultTheme,
									{ withDarkTheme = true },
									{
										ChatLineReportStepHandler = React.createElement(ChatLineReportStepHandler, {
											unmount = fn,
											messages = messages
										})
									}
								)
							})
						}
					)
				})
			}
		)

		focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

		v = Roact.mount(
			React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = focusNavigationService },
				{
					FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
						ChatLineReportRoot = element
					})
				}
			),
			CoreGui,
			"ChatLineReportRoot"
		)
	end
}
