local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.GraphQLServer)["jest.config"],
		require(ParentParent.RobloxApolloClient)["jest.config"],
		require(ParentParent.GraphQlShared)["jest.config"],
		require(ParentParent.ApolloLocalState)["jest.config"]
	}
}
