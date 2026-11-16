local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/SharedFlags").FFlagUserProfilePlatformProfile
local makeDefaultReadPolicy = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/makeDefaultReadPolicy")

local v6 = {
	alias = { read = makeDefaultReadPolicy("") },
	contactName = { read = makeDefaultReadPolicy("") },
	platformName = 0
}

local v8 = if not fFlagUserProfilePlatformProfile then makeDefaultReadPolicy("") else nil
v6.platformName = { read = v8 }
return { fields = v6 }
