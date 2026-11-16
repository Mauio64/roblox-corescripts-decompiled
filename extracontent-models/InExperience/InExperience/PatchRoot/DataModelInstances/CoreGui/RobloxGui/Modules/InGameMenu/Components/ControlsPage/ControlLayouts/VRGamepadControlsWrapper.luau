local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local modules = CoreGui:WaitForChild("RobloxGui").Modules

local VRGamepadControls = script.Parent.VRGamepadControls
local HelpPage = require(CorePackages.Workspace.Packages.HelpPage)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local React = require(CorePackages.Packages.React)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
local ControlLayoutContainer = require(script.Parent.Parent.ControlLayoutContainer)

local HelpReactView = HelpPage.HelpReactView
local FFlagHelpPageMountVR = HelpPage.Flags.FFlagHelpPageMountVR
local utils

if FFlagHelpPageMountVR then
	local Integrations = require(modules.Settings.Integrations)
	utils = Integrations.Utils
else
	utils = nil
end

if not FFlagHelpPageMountVR then
	return require(VRGamepadControls)
end

local function VRGamepadControlsWrapper()
	return React.createElement(
		ControlLayoutContainer,
		{ titleText = "CoreScripts.InGameMenu.Controls.VrControllerTitle" },
		{
			Inner = React.createElement(LocalizationProvider, { localization = localization }, {
				FoundationProvider = React.createElement(
					FoundationProvider,
					{ colorMode = Foundation.Enums.ColorMode.Dark, device = utils.getDeviceType() },
					{
						HelpReactView = React.createElement(HelpReactView)
					}
				)
			})
		}
	)
end

return React.memo(VRGamepadControlsWrapper)
