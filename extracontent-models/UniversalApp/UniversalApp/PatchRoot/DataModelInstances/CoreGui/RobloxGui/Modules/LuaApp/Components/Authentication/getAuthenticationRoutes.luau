local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Navigation)

local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local createLazyComponent = require(CorePackages.Workspace.Packages.RoactUtils).Components.createLazyComponent
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local Modules = game:GetService("CoreGui").RobloxGui.Modules

return function() -- line: 15
	-- upvalues: AppPage (copy), createLazyComponent (copy), CorePackages (copy), ScreenKind (copy), GlobalNavDisplayOption (copy), default (copy), Modules (copy)
	return {
		{
			[AppPage.PlatformAccountRouter] = {
				screen = createLazyComponent(function() -- line: 19
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.AppStartup).PlatformAccountRouter
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.SingleSignOnError] = {
				screen = createLazyComponent(function() -- line: 30
					-- upvalues: CorePackages (copy)
					return require(CorePackages.Workspace.Packages.SingleSignOn).SingleSignOnError
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.Startup] = {
				screen = createLazyComponent(function() -- line: 41
					-- upvalues: default (copy), Modules (copy)
					default:logEventOnce("lazily_require_startup_page")

					return require(Modules.LuaApp.Components.Authentication.StartupPage)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.Landing] = {
				screen = createLazyComponent(function() -- line: 53
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Authentication.LandingPage)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.SinglePageSignUp] = {
				screen = createLazyComponent(function() -- line: 64
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Authentication.SinglePageSignUp)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.MultiPageSignup] = {
				screen = createLazyComponent(function() -- line: 75
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Authentication.MultiPageSignupMonoWrapper)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.SingleSignOnContainer] = {
				screen = createLazyComponent(function() -- line: 86
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Authentication.SingleSignOnContainer)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.Login] = {
				screen = createLazyComponent(function() -- line: 97
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Authentication.LoginView)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.CrossDeviceLogin] = {
				screen = createLazyComponent(function() -- line: 108
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.CrossDeviceLoginPage)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		}
	}
end
