require("@game/CorePackages/Workspace/Packages/Navigation")
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage

return function()
	return {
		{
			[appPage.More] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/hGQ")
				end)
			}
		},
		{
			[appPage.Settings] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/hHw")
				end)
			}
		},
		{
			[appPage.AccountSettings] = fFlagUnifyConsoleSettingsPage and {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hIU")
				end)
			} or nil
		},
		{
			[appPage.PlatformSettings] = fFlagUnifyConsoleSettingsPage and {
				screen = createLazyComponent(function()
					return require("@luauforge/bundled/hIV")
				end)
			} or nil
		},
		{
			[appPage.AdjustScreen] = {
				screen = createLazyComponent(function()
					return require("@game/CoreGui/RobloxGui/Modules/Shell/Components/Overscan10ft/Overscan")
				end)
			}
		},
		{
			[appPage.About] = {
				screen = createLazyComponent(function()
					return require("@luauforge/deferred/hJe")
				end)
			}
		}
	}
end
