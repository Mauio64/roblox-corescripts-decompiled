local Parent = script:FindFirstAncestor("QRCodeDisplay").Parent
local LuaSocialLibrariesDeps = require(Parent.Dev.LuaSocialLibrariesDeps)
local JestGlobals = require(Parent.Dev.JestGlobals)
local CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers

JestGlobals.expect.extend(CollisionMatchers.Jest)
