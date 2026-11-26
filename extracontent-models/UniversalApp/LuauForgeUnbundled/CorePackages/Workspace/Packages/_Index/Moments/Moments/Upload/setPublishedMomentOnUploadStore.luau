local refreshOwnMomentsAfterPublish = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Upload/refreshOwnMomentsAfterPublish")

local function setPublishedMomentOnUploadStore(p2, p3, p4)
	local v5 = refreshOwnMomentsAfterPublish(p2, p4)

	if v5 == nil then
		p3.setSuccess(p2)
	else
		p3.setSuccess(v5)
	end
end

return setPublishedMomentOnUploadStore
