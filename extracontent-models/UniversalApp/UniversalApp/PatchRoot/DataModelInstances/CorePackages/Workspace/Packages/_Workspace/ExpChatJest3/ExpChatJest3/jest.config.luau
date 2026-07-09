local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.ExpChatServer)["jest.config"],
		require(ParentParent.ExpChat)["jest.config"],
		require(ParentParent.ExpChat)["mockDataModel-jest.config"],
		require(ParentParent.ExpChatShared)["jest.config"],
		require(ParentParent.TextChannelWindow)["jest.config"]
	}
}
