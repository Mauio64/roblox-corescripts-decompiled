local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
return LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
