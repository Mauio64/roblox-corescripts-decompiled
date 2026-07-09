local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Packages = CorePackages.Workspace.Packages
local React = require(CorePackages.Packages.React)
local UserProfiles = require(Packages.UserProfiles)
local PeopleListContextualMenu = require(Modules.LuaApp.Components.Home.PeopleListContextualMenu)

local function PeopleListContextualMenuFn(p1) -- line: 15
	-- upvalues: UserProfiles (copy), React (copy), PeopleListContextualMenu (copy), Cryo (copy)
	local v10 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p1.user.id },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v11 = if not v10.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v10.data, p1.user.id)

	return React.createElement(PeopleListContextualMenu, Cryo.Dictionary.join(p1, {
		combinedName = v11
	}))
end

return PeopleListContextualMenuFn
