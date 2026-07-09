local Parent = script:FindFirstAncestor("AddFriends").Parent
local CollisionMatchers = require(Parent.Dev.CollisionMatchers)

require(Parent.Dev.JestGlobals).expect.extend(CollisionMatchers.Jest)
