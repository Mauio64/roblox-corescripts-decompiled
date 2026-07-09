local CorePackages = game:GetService("CorePackages")
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage

require(CorePackages.Workspace.Packages.Navigation)

return function() -- line: 11
	-- upvalues: AppPage (copy)
	return {{
		[AppPage.Groups] = {
			getScreen = function() -- line: 15
				return require(script.Parent.GroupsUniversalAppWrapper)
			end,
			navigationOptions = {
				disableBackButton = false
			}
		}
	}}
end
