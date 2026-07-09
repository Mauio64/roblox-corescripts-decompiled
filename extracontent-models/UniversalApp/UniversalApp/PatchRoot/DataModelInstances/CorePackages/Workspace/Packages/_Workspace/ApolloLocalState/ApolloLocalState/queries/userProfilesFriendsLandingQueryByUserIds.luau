local Parent = script:FindFirstAncestor("ApolloLocalState").Parent

return (require(Parent.ApolloClient).gql(require(script.Parent.schema.UserProfilesFriendsLandingQueryByUserIds)))
