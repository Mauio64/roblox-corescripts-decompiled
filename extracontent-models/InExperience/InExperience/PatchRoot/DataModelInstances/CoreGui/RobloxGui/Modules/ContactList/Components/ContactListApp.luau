local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList
local ContactListContainer = require(ContactList.Components.ContactListContainer)
local CallBarContainer = require(ContactList.Components.CallBarContainer)
local CallDialogContainer = require(ContactList.Components.CallDialogContainer)
local PlayerMenuContainer = require(ContactList.Components.PlayerMenuContainer)

return function() -- line: 19
	-- upvalues: React (copy), RoactNavigation (copy), ContactListContainer (copy), SoundManager (copy), SoundGroups (copy), CallDialogContainer (copy), PlayerMenuContainer (copy), CallBarContainer (copy)
	local v12 = React.useMemo(function() -- line: 23
		-- upvalues: RoactNavigation (copy), ContactListContainer (copy)
		return RoactNavigation.createAppContainer(RoactNavigation.createRobloxStackNavigator({{
			ContactList = {
				screen = ContactListContainer
			}
		}}, {
			defaultNavigationOptions = {
				absorbInput = false
			}
		}))
	end, {})

	React.useEffect(function() -- line: 33
		-- upvalues: SoundManager (copy), SoundGroups (copy)
		SoundManager:CreateSoundGroup(SoundGroups.Iris.Name)
	end, {})

	return React.createElement("Folder", {}, {
		CallDialogContainer = React.createElement(CallDialogContainer),
		ContactListContainer = React.createElement(v12),
		PlayerMenuContainer = React.createElement(PlayerMenuContainer),
		CallBarContainer = React.createElement(CallBarContainer)
	})
end
