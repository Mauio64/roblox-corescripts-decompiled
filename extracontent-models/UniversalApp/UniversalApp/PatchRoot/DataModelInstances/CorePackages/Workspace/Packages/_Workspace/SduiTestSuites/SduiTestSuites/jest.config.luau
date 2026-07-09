_G.__TESTEZ_RUNNING_TEST__ = true

local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.SduiCompat)["jest.config"],
		require(ParentParent.SduiCoreSystem)["jest.config"],
		require(ParentParent.SduiSharedContent)["jest.config"],
		require(ParentParent.SduiSharedUtilities)["jest.config"]
	}
}
