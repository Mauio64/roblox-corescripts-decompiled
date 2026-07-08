local ParentParent = script.Parent.Parent

return {
	testMatch = { "**/*.spec" },
	setupFilesAfterEnv = { ParentParent.Utilities.UIBloxInitializer }
}
