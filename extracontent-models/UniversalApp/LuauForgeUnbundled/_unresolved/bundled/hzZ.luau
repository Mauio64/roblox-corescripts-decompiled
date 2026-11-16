require("@game/CorePackages/Workspace/Packages/Navigation")
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

return function()
	return {
		{
			[appPage.PlatformAccountRouter] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/cyM").PlatformAccountRouter
				end)
			}
		},
		{
			[appPage.SingleSignOnError] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hAa").SingleSignOnError
				end)
			}
		},
		{
			[appPage.Startup] = {
				screen = createLazyComponent(function()
					default:logEventOnce("lazily_require_startup_page")
					return require("@luauforge/bundled/hAn")
				end)
			}
		},
		{
			[appPage.Landing] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/fMF")
				end)
			}
		},
		{
			[appPage.SinglePageSignUp] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hAo")
				end)
			}
		},
		{
			[appPage.MultiPageSignup] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hBl")
				end)
			}
		},
		{
			[appPage.SingleSignOnContainer] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hCX")
				end)
			}
		},
		{
			[appPage.Login] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hDe")
				end)
			}
		},
		{
			[appPage.CrossDeviceLogin] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hEb")
				end)
			}
		}
	}
end
