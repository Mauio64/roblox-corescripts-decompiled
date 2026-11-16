local refreshOwnMomentsAfterPublish = require(script.Parent.refreshOwnMomentsAfterPublish)

local function setPublishedMomentOnUploadStore(p: number, p2, p3)
	local v = refreshOwnMomentsAfterPublish(p, p3)

	if v == nil then
		p2.setSuccess(p)
	else
		p2.setSuccess(v)
	end
end

return setPublishedMomentOnUploadStore
