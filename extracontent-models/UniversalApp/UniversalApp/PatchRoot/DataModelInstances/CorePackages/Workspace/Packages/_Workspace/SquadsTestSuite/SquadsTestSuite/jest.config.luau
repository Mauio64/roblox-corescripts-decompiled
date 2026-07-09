local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.NetworkingSquads)["jest.config"],
		require(ParentParent.RoduxSquads)["jest.config"],
		require(ParentParent.Squads)["jest.config"],
		require(ParentParent.SquadsCore)["jest.config"]
	}
}
