local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent

require(MomentsCreationParent.MomentsTypes)

local makeMomentMetadata = require(MomentsCreation.Utils.makeMomentMetadata)
local makeRegistrationInfo = require(MomentsCreation.Utils.makeRegistrationInfo)
local createMoment = require(MomentsCreation.Upload.createMoment)

local function publishMoment(p1, p2, s1: string) -- line: 27
	-- upvalues: makeMomentMetadata (copy), makeRegistrationInfo (copy), createMoment (copy)
	local v10 = makeMomentMetadata(p1, s1, p2)
	local v11 = makeRegistrationInfo(p1, v10)

	createMoment(p1, v10, v11)
end

return publishMoment
