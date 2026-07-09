local ParentParent = script.Parent.Parent
local HttpResponseStatus = require(ParentParent.InternalHttpStore).HttpResponseStatus

local function isHttpStoreFetchCancelled(p1) -- line: 9
	-- upvalues: HttpResponseStatus (copy)
	if p1.status ~= HttpResponseStatus.Failed then
		return false
	end

	if p1.cancelled == true then
		return true
	end

	local response = p1.response

	if response and response.HttpError == Enum.HttpError.Aborted then
		return true
	end

	return false
end

return isHttpStoreFetchCancelled
