local parent = script:FindFirstAncestor("ContactImporter").Parent

local GenericChallenges = require(parent.GenericChallenges)
local ChallengeRequestWrapper = GenericChallenges.Middleware.ChallengeRequestWrapper
local DataHydration = require(parent.DataHydration)
return ChallengeRequestWrapper(DataHydration.Friends.httpRequest)
