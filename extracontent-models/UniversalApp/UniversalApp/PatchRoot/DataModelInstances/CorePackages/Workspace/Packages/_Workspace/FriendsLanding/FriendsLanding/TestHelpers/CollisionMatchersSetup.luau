local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local devDependencies = require(FriendsLanding.devDependencies)

devDependencies.JestGlobals.expect.extend(devDependencies.CollisionMatchers.Jest)
