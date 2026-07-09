local Parent = script:FindFirstAncestor("SocialCommon").Parent
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local JestGlobals = require(Parent.Dev.JestGlobals)
local CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers

JestGlobals.expect.extend(CollisionMatchers.Jest)
