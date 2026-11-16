game:DefineFastString("LuaAppSignupLayer", "PlayerApp.Signup")
game:DefineFastString("ConsoleSignUpLayer", "Consoles.Signup")
game:DefineFastString("AccountSwitcherLayer", "Accounts.AccountSwitcher")
game:DefineFastString("LuaAppLandingLayer", "PlayerApp.Landing")
game:DefineFastString("LuaAppIosPasswordSavingLayer", "PlayerApp.PasswordSaving.iOS")
game:DefineFastString("LuaAppAuthenticationStylingLayer", "PlayerApp.Authentication.Styling")
game:DefineFastString("AccountRecoveryUILayer", "AccountSecurity.SelfRecovery.RecoveryUI")
game:DefineFastString("ConsumerPlatformsIOSUIRefactor", "ConsumerPlatforms.IOSUIRefactor")
game:DefineFastString("LuaAppUniversalAppAuthEntryLayer", "PlayerApp.UniversalAppAuthEntry")

return {
	SignupLayer = game:GetFastString("LuaAppSignupLayer"),
	LoginLayer = "PlayerApp.Login",
	LandingLayer = game:GetFastString("LuaAppLandingLayer"),
	AccountSwitcherLayer = game:GetFastString("AccountSwitcherLayer"),
	ConsoleSignUpLayer = game:GetFastString("ConsoleSignUpLayer"),
	IosPasswordSavingLayer = game:GetFastString("LuaAppIosPasswordSavingLayer"),
	DefaultThemeLayer = "ConsumerPlatforms.Themes",
	AuthenticationStylingLayer = game:GetFastString("LuaAppAuthenticationStylingLayer"),
	AccountRecoveryUILayer = game:GetFastString("AccountRecoveryUILayer"),
	ConsumerPlatformsIOSUIRefactor = game:GetFastString("ConsumerPlatformsIOSUIRefactor"),
	AndroidWidgetLayer = "ConsumerPlatforms.AndroidWidgets",
	DeferredDeeplinkResolutionLayer = "Ads.OffPlatform.DeferredDeeplinkResolution",
	UniversalAppAuthEntryLayer = game:GetFastString("LuaAppUniversalAppAuthEntryLayer")
}
