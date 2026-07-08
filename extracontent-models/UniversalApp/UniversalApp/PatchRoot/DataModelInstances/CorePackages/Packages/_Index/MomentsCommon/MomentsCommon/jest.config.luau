local scriptParent = script.Parent

return {
	projects = {
		require(scriptParent.Components.Tests)["jest.config"],
		require(scriptParent.Hooks.Tests)["jest.config"],
		require(scriptParent.Utils.Tests)["jest.config"]
	}
}
