require("@game/CorePackages/Workspace/Packages/Navigation")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local function getUserLibraryRoute()
	return {
		getScreen = function()
			return require("@luauforge/bundled/fDW").UserLibraryScreen()
		end
	}
end

return function()
	return {
		{
			[appPage.UserLibrary] = {
				getScreen = function()
					return require("@luauforge/bundled/fDW").UserLibraryScreen()
				end
			}
		},
		{
			[appPage.UserLibraryCollection] = {
				getScreen = function()
					return require("@luauforge/bundled/fDW").UserLibraryScreen()
				end
			}
		}
	}
end
