local scriptParent = script.Parent

return {
	projects = {
		require(scriptParent.Components.Tests)["jest.config"],
		require(scriptParent.Thunks.Tests)["jest.config"],
		require(scriptParent.Utils.Tests)["jest.config"]
	}
}
