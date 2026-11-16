local parent = script:FindFirstAncestor("AppChat").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
return LuaSocialLibrariesDeps.RoduxPresence.config({ keyPath = "ChatAppReducer.Presence" })
