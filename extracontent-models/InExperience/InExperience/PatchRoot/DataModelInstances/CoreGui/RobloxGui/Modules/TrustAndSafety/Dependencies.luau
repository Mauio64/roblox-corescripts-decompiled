local CorePackages = game:GetService("CorePackages")

local InGameMenu = script.Parent.Parent.InGameMenu

local defineFastFlag = game:DefineFastFlag("SwitchTnSTranslationsPackage", false)

local Dependencies = {
	BarOnTopScrollingFrame = InGameMenu.Components.BarOnTopScrollingFrame,
	Divider = InGameMenu.Components.Divider,
	FocusHandler = InGameMenu.Components.Connection.FocusHandler,
	ThemedTextLabel = InGameMenu.Components.ThemedTextLabel,
	PlayerCell = InGameMenu.Components.PlayerCell,
	GameIcon = InGameMenu.Components.GameIcon,
	PlayerSearchPredicate = InGameMenu.Utility.PlayerSearchPredicate,
	SearchBar = InGameMenu.Components.SearchBar,
	Localization = 0,
	LocalizationProvider = 0,
	withLocalization = 0,
	playerInterface = 0
}
local localization

if defineFastFlag then
	local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
	localization = InExperienceLocales.Localization
else
	localization = require(InGameMenu.Localization.Localization)
end

Dependencies.Localization = localization
Dependencies.LocalizationProvider = InGameMenu.Localization.LocalizationProvider
Dependencies.withLocalization = InGameMenu.Localization.withLocalization
Dependencies.playerInterface = script.Parent.Parent.Interfaces.playerInterface
return Dependencies
