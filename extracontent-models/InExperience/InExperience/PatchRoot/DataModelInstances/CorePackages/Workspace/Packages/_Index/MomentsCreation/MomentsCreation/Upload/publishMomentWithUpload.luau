local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent

require(MomentsCreationParent.MomentsTypes)

local makeMomentMetadata = require(MomentsCreation.Utils.makeMomentMetadata)
local makeRegistrationInfo = require(MomentsCreation.Utils.makeRegistrationInfo)
local uploadMoment = require(MomentsCreation.Upload.uploadMoment)

local function publishMomentWithUpload(p1, p2, s1: string, t1: {[any]: any}) -- line: 38
	-- upvalues: makeMomentMetadata (copy), makeRegistrationInfo (copy), uploadMoment (copy)
	local v11 = makeMomentMetadata(p1, s1, p2, t1.resolvedTimeLength)
	local v12 = makeRegistrationInfo(p1, v11)

	uploadMoment(p1, v11, v12, t1.localizations, t1.uploadStore, t1.toastStore, nil, nil, t1.creationSessionId)
end

return publishMomentWithUpload
