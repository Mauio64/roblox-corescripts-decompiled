local CorePackages = game:GetService("CorePackages")
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
return CoreScriptsRoactCommon.Traversal.Flags.FFlagAddTraversalHistory
	and game:DefineFastFlag("AddTraversalHistoryReactMenuButtons", false)
