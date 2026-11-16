local httpResponseStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/InternalHttpStore").HttpResponseStatus

local function isHttpStoreFetchCancelled(data): boolean
	if data.status ~= httpResponseStatus.Failed then
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
