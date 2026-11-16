local url = require("@luauforge/deferred/gqA").Url
local module = require("@luauforge/deferred/gqB")
require("@luauforge/deferred/gqC")

local v5 = nil

return function(callback, p2)
	assert(type(p2) == "boolean", "GetCameraOptIn request expects invalidateCache to be a boolean")

	local v6 = string.format("%s/v1/settings/avatar", url.VOICE_URL)
	local v7 = if v5 ~= nil then v5:getStatus() else nil

	if p2 then
		if v7 == module.Status.Started then
			return v5
		end
	elseif v5 and v7 ~= module.Status.Cancelled then
		return v5
	end

	v5 = callback(v6, "GET"):andThen(function(p3)
		local responseBody = p3.responseBody

		if responseBody then
			return module.resolve(responseBody.isAvatarVideoOptIn)
		end

		return module.reject("Unexpected response fetching cameraOptIn settings")
	end, function(p3)
		return module.reject(p3)
	end)

	return v5
end
