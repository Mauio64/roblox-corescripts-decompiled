local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local CoreGui = game:GetService("CoreGui")
local Provider = require(ChatLineReportingParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ChatLineReportingParent.InExperienceLocales).Localization
local LocalizationProvider = require(ChatLineReportingParent.Localization).LocalizationProvider
local React = require(ChatLineReportingParent.React)
local ReactFocusNavigation = require(ChatLineReportingParent.ReactFocusNavigation)
local Roact = require(ChatLineReportingParent.Roact)
local StyleProviderWithDefaultTheme = require(ChatLineReportingParent.Style).StyleProviderWithDefaultTheme
local LayerCollectorProvider = require(ChatLineReportingParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local FFlagChatLineReportingFocusFixesEnabled = require(ChatLineReportingParent.SharedFlags).FFlagChatLineReportingFocusFixesEnabled
local ChatLineReportStepHandler = require(ChatLineReporting.Components.ChatLineReportStepHandler)
local FoundationProvider = require(ChatLineReportingParent.Foundation).FoundationProvider
local u16 = nil
local u17 = nil

local function v18() -- line: 28
	-- upvalues: u17 (ref), Roact (copy), FFlagChatLineReportingFocusFixesEnabled (copy), u16 (ref)
	if u17 then
		Roact.unmount(u17)

		if FFlagChatLineReportingFocusFixesEnabled then
			u16:teardown()
		end
	end
end

return {
	initialize = function(p1) -- line: 38
		-- upvalues: React (copy), LayerCollectorProvider (copy), Roact (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), FoundationProvider (copy), StyleProviderWithDefaultTheme (copy), ChatLineReportStepHandler (copy), v18 (copy), FFlagChatLineReportingFocusFixesEnabled (copy), u16 (ref), ReactFocusNavigation (copy), u17 (ref), Provider (copy), CoreGui (copy)
		local v20 = React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			LayerCollector = React.createElement(LayerCollectorProvider, {}, {
				LocalizationProvider = Roact.createElement(LocalizationProvider, {
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				}, {
					FoundationProvider = React.createElement(FoundationProvider, {
						theme = "Dark"
					}, {
						StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {
							withDarkTheme = true
						}, {
							ChatLineReportStepHandler = React.createElement(ChatLineReportStepHandler, {
								unmount = v18,
								messages = p1
							})
						})
					})
				})
			})
		})

		if FFlagChatLineReportingFocusFixesEnabled then
			u16 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
			u17 = Roact.mount(React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = u16
			}, {
				FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
					ChatLineReportRoot = v20
				})
			}), CoreGui, "ChatLineReportRoot")

			return
		end

		u17 = Roact.mount(v20, CoreGui, "ChatLineReportRoot")
	end
}
