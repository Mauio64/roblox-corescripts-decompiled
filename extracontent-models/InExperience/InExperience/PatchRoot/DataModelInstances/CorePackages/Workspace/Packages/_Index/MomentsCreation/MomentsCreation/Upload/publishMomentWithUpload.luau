local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)

local makeMomentMetadata = require(MomentsCreation.Utils.makeMomentMetadata)
local makeRegistrationInfo = require(MomentsCreation.Utils.makeRegistrationInfo)
local uploadMoment = require(MomentsCreation.Upload.uploadMoment)

local function publishMomentWithUpload(p, p2, p3: string, data)
	local momentMetadata = makeMomentMetadata(p, p3, p2, data.resolvedTimeLength, data.commentsEnabled)
	uploadMoment(
		p,
		momentMetadata,
		makeRegistrationInfo(p, momentMetadata),
		data.localizations,
		data.uploadStore,
		data.toastStore,
		nil,
		nil,
		data.creationSessionId
	)
end

return publishMomentWithUpload
