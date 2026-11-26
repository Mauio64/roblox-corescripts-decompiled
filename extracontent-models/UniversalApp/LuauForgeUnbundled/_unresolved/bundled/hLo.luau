require("@game/CorePackages/Workspace/Packages/Navigation")
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

return function()
	return {
		{
			[appPage.PlatformAccountRouter] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/cBa").PlatformAccountRouter
				end)
			}
		},
		{
			[appPage.SingleSignOnError] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hLp").SingleSignOnError
				end)
			}
		},
		{
			[appPage.Startup] = {
				screen = createLazyComponent(function()
					default:logEventOnce("lazily_require_startup_page")
					return require("@luauforge/bundled/hLC")
				end)
			}
		},
		{
			[appPage.Landing] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/gra")
				end)
			}
		},
		{
			[appPage.SinglePageSignUp] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hLD")
				end)
			}
		},
		{
			[appPage.MultiPageSignup] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hMC")
				end)
			}
		},
		{
			[appPage.SingleSignOnContainer] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hOo")
				end)
			}
		},
		{
			[appPage.Login] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hOv")
				end)
			}
		},
		{
			[appPage.CrossDeviceLogin] = {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hPc")
				end)
			}
		}
	}
end
