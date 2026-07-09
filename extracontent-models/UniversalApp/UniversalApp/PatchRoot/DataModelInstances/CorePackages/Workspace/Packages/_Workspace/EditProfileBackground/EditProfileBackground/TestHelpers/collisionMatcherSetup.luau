local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local CollisionMatchers2D = require(Parent.Dev.CollisionMatchers2D)

require(Parent.Dev.JestGlobals).expect.extend(CollisionMatchers2D.Jest)
