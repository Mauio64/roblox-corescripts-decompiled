local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/eXl")

local module2 = require("@luauforge/deferred/hMb")

local function PeopleListContextualMenuFn(p2)
	local v5 = module.Hooks.useUserProfilesFetch({
		userIds = { p2.user.id },
		query = module.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})

	local v6 = if v5.data then module.Selectors.getCombinedNameFromId(v5.data, p2.user.id) else nil

	return React.createElement(module2, Cryo.Dictionary.join(p2, { combinedName = v6 }))
end

return PeopleListContextualMenuFn
