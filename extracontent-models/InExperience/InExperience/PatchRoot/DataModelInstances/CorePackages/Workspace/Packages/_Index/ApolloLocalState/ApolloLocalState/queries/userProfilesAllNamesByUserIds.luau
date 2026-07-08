local Parent = script:FindFirstAncestor("ApolloLocalState").Parent
local gql = require(Parent.ApolloClient).gql
local v3 = gql(require(script.Parent.schema.UserProfilesAllNamesByUserIdsNew))
local v4 = gql(require(script.Parent.schema.UserProfilesAllNamesByUserIds))

if game:GetEngineFeature("PlatformFriendsService") and game:GetEngineFeature("PlatformFriendsProfile") then
	return v3
end

return v4
