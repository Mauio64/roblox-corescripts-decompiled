local parent = script:FindFirstAncestor("ApolloLocalState").Parent

local ApolloClient = require(parent.ApolloClient)
local gql = ApolloClient.gql

local v = gql(require(script.Parent.schema.UserProfilesAllNamesByUserIdsNew))

local v2 = gql(require(script.Parent.schema.UserProfilesAllNamesByUserIds))

if game:GetEngineFeature("PlatformFriendsService") and game:GetEngineFeature("PlatformFriendsProfile") then
	return v
end

return v2
