local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")

local v5 = {}
v5.__index = v5

function v5:onBeforeSendingMessage(p3) end

function v5.sendMessage(p2, p3)
	return Promise.reject("Not implemented")
end

function v5.onSuccess(p2, p3, p4)
	return p4
end

function v5.onFailure(p2, p3, p4)
	return p4
end

return v5
