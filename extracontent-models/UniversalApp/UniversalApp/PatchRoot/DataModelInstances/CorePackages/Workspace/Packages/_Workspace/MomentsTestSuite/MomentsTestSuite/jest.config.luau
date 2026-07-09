local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.Moments)["jest.main.config"],
		require(ParentParent.Moments)["jest.mockDataModel.config"],
		require(ParentParent.MomentsCommon)["jest.config"],
		require(ParentParent.MomentsCreation)["jest.config"],
		require(ParentParent.MomentsTypes)["jest.config"]
	}
}
