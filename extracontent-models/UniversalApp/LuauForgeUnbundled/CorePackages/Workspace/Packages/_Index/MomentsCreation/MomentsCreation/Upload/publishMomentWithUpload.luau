require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local makeMomentMetadata = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeMomentMetadata")
local makeRegistrationInfo = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeRegistrationInfo")
local uploadMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/uploadMoment")

local function publishMomentWithUpload(p2, p3, p4, data)
	local v5 = makeMomentMetadata(p2, p4, p3, data.resolvedTimeLength, data.commentsEnabled)
	uploadMoment(
		p2,
		v5,
		makeRegistrationInfo(p2, v5),
		data.localizations,
		data.uploadStore,
		data.toastStore,
		nil,
		nil,
		data.creationSessionId
	)
end

return publishMomentWithUpload
