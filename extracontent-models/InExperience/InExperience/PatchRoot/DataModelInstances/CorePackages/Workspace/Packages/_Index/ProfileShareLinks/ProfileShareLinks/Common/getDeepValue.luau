local parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
return LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
