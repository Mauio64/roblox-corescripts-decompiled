local gql = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/ApolloClient").gql

local v5 = gql(require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/schema/UserProfilesAllNamesByUserIdsNew"))

local v6 = gql(require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/schema/UserProfilesAllNamesByUserIds"))

if game:GetEngineFeature("PlatformFriendsService") and game:GetEngineFeature("PlatformFriendsProfile") then
	return v5
end

return v6
