local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent

require(MomentsCreationParent.MomentsTypes)

local makeMomentMetadata = require(MomentsCreation.Utils.makeMomentMetadata)
local makeRegistrationInfo = require(MomentsCreation.Utils.makeRegistrationInfo)
local createMoment = require(MomentsCreation.Upload.createMoment)

local function publishMoment(p1, p2, s1: string, s2: string?, n1: number?) -- line: 31
	-- upvalues: makeMomentMetadata (copy), makeRegistrationInfo (copy), createMoment (copy)
	local v12 = makeMomentMetadata(p1, s1, p2, n1)
	local v13 = makeRegistrationInfo(p1, v12)

	createMoment(p1, v12, v13, s2)
end

return publishMoment
