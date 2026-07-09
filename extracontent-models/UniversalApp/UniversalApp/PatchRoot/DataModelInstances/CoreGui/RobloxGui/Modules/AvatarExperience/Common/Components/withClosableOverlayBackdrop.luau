local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

return function(p1) -- line: 11
	-- upvalues: useNavigation (copy), React (copy), NavigationUtils (copy)
	return function(p2) -- line: 12
		-- upvalues: useNavigation (copy), React (copy), NavigationUtils (copy), p1 (copy)
		local v8 = useNavigation()
		local v9 = React.useCallback(function() -- line: 15
			-- upvalues: NavigationUtils (copy), v8 (copy)
			NavigationUtils.closeOverlay(v8)
		end, { v8 })

		return React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = v9
		}, {
			Prompt = React.createElement(p1, p2)
		})
	end
end
