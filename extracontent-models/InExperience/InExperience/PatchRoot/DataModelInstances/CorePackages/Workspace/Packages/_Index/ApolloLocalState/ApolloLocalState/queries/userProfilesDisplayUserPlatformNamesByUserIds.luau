local parent = script:FindFirstAncestor("ApolloLocalState").Parent

local ApolloClient = require(parent.ApolloClient)
return (ApolloClient.gql(require(script.Parent.schema.UserProfilesDisplayUserPlatformNamesByUserIds)))
