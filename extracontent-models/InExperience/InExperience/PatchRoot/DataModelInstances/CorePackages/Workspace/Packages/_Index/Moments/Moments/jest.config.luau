local scriptParent = script.Parent

return {
	projects = {
		scriptParent["jest.main.config"],
		scriptParent["jest.mockDataModel.config"]
	}
}
