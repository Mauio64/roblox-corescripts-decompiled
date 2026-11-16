local parent = script:FindFirstAncestor("AppChat").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
return LuaSocialLibrariesDeps.RoduxAliases.config({ keyPath = "ChatAppReducer.Aliases" })
