local parent = script.Parent.Parent
local InternalHttpStore = require(parent.InternalHttpStore)

local HttpResponseStatus = InternalHttpStore.HttpResponseStatus

local function isHttpStoreFetchCancelled(data): boolean
	if data.status ~= HttpResponseStatus.Failed then
		return false
	end

	if data.cancelled == true then
		return true
	end

	local response = data.response

	if response and response.HttpError == Enum.HttpError.Aborted then
		return true
	end

	return false
end

return isHttpStoreFetchCancelled
