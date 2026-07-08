local CorePackages = game:GetService("CorePackages")
local InGameMenu = script.Parent.Parent.InGameMenu
local v3 = game:DefineFastFlag("SwitchTnSTranslationsPackage", false)

return {
	BarOnTopScrollingFrame = InGameMenu.Components.BarOnTopScrollingFrame,
	Divider = InGameMenu.Components.Divider,
	FocusHandler = InGameMenu.Components.Connection.FocusHandler,
	ThemedTextLabel = InGameMenu.Components.ThemedTextLabel,
	PlayerCell = InGameMenu.Components.PlayerCell,
	GameIcon = InGameMenu.Components.GameIcon,
	PlayerSearchPredicate = InGameMenu.Utility.PlayerSearchPredicate,
	SearchBar = InGameMenu.Components.SearchBar,
	Localization = if not v3 then require(InGameMenu.Localization.Localization) else require(CorePackages.Workspace.Packages.InExperienceLocales).Localization,
	LocalizationProvider = InGameMenu.Localization.LocalizationProvider,
	withLocalization = InGameMenu.Localization.withLocalization,
	playerInterface = script.Parent.Parent.Interfaces.playerInterface
}
