local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/Navigation")

return function()
	return {
		{
			[appPage.Groups] = {
				getScreen = function()
					return require("@luauforge/deferred/fwu")
				end,
				navigationOptions = { disableBackButton = false }
			}
		}
	}
end
