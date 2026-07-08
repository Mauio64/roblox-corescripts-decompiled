local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = CoreGui:WaitForChild("RobloxGui").Modules
local VRGamepadControls = script.Parent.VRGamepadControls
local HelpPage = require(CorePackages.Workspace.Packages.HelpPage)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local React = require(CorePackages.Packages.React)
local v11 = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization.new(LocalizationService.RobloxLocaleId)
local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)
local HelpReactView = HelpPage.HelpReactView
local FFlagHelpPageMountVR = HelpPage.Flags.FFlagHelpPageMountVR
local Utils = nil

if FFlagHelpPageMountVR then
	Utils = require(Modules.Settings.Integrations).Utils
end

if FFlagHelpPageMountVR then
	local function VRGamepadControlsWrapper() -- line: 30
		-- upvalues: React (copy), ControlLayoutContainer (copy), LocalizationProvider (copy), v11 (copy), FoundationProvider (copy), Foundation (copy), Utils (ref), HelpReactView (copy)
		return React.createElement(ControlLayoutContainer, {
			titleText = "CoreScripts.InGameMenu.Controls.VrControllerTitle"
		}, {
			Inner = React.createElement(LocalizationProvider, {
				localization = v11
			}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					theme = Foundation.Enums.Theme.Dark,
					device = Utils.getDeviceType()
				}, {
					HelpReactView = React.createElement(HelpReactView)
				})
			})
		})
	end

	return React.memo(VRGamepadControlsWrapper)
end

return require(VRGamepadControls)
