local Parent = script:FindFirstAncestor("CameraOptIn").Parent
local Url = require(Parent.Http).Url
local Promise = require(Parent.Promise)

require(Parent.LuauPolyfill)

local u4 = nil

return function(p1, b1: boolean) -- line: 16
	-- upvalues: Url (copy), u4 (ref), Promise (copy)
	assert(type(b1) == "boolean", "GetCameraOptIn request expects invalidateCache to be a boolean")

	local v7 = string.format("%s/v1/settings/avatar", Url.VOICE_URL)
	local v8 = if u4 == nil then nil else u4:getStatus()

	if b1 then
		if v8 == Promise.Status.Started then
			return u4
		end
	elseif u4 and v8 ~= Promise.Status.Cancelled then
		return u4
	end

	u4 = p1(v7, "GET"):andThen(function(p2) -- line: 33
		-- upvalues: Promise (copy)
		local responseBody = p2.responseBody

		if not responseBody then
			return Promise.reject("Unexpected response fetching cameraOptIn settings")
		end

		return Promise.resolve(responseBody.isAvatarVideoOptIn)
	end, function(p3) -- line: 40
		-- upvalues: Promise (copy)
		return Promise.reject(p3)
	end)

	return u4
end
