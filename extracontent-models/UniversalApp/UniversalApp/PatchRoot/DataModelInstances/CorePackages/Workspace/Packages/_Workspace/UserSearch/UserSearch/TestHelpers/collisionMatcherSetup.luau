local Parent = script:FindFirstAncestor("UserSearch").Parent
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local JestGlobals = require(Parent.Dev.JestGlobals)
local CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers

JestGlobals.expect.extend(CollisionMatchers.Jest)
