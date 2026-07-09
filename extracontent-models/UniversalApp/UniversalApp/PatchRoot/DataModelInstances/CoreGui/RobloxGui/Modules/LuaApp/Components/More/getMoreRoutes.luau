local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(CorePackages.Workspace.Packages.Navigation)

local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local createLazyComponent = require(CorePackages.Workspace.Packages.RoactUtils).Components.createLazyComponent
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage

return function() -- line: 12
	-- upvalues: AppPage (copy), createLazyComponent (copy), Modules (copy), GlobalNavDisplayOption (copy), ScreenKind (copy)
	return {
		{
			[AppPage.More] = {
				screen = createLazyComponent(function() -- line: 16
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.More.MorePage)
				end),
				navigationOptions = {
					globalNavDisplayOption = GlobalNavDisplayOption.OptionGroupOnly
				}
			}
		},
		{
			[AppPage.Settings] = {
				screen = createLazyComponent(function() -- line: 26
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.More.AccountSettings.MoreSettingsPageSelector)
				end),
				navigationOptions = {
					globalNavDisplayOption = GlobalNavDisplayOption.OptionGroupOnly
				}
			}
		},
		{
			[AppPage.AdjustScreen] = {
				screen = createLazyComponent(function() -- line: 36
					-- upvalues: Modules (copy)
					return require(Modules.Shell.Components.Overscan10ft.Overscan)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		},
		{
			[AppPage.About] = {
				screen = createLazyComponent(function() -- line: 47
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.More.AboutPage)
				end),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.OptionGroupOnly
				}
			}
		}
	}
end
