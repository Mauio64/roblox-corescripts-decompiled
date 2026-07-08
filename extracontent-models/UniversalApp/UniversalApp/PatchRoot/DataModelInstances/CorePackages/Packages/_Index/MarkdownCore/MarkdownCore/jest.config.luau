local _Workspace = script:FindFirstAncestor("Packages")._Workspace
local setupJest = script.Parent.setupJest

return {
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "_Index" },
	setupFilesAfterEnv = { setupJest },
	rootDir = _Workspace
}
