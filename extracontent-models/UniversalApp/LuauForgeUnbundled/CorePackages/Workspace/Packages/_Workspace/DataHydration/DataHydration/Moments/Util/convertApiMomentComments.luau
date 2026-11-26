require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")

local function convertApiMomentComments(data)
	if type(data) ~= "table" then
		return nil
	end

	if
		type(data.creatorEnabled) ~= "boolean"
		or type(data.viewerCanRead) ~= "boolean"
		or type(data.viewerCanWrite) ~= "boolean"
	then
		return nil
	end

	local v6 = if type(data.count) == "number" then data.count else nil
	local v7 = if type(data.countIsCapped) == "boolean" then data.countIsCapped else nil
	return {
		count = v6,
		countIsCapped = v7,
		creatorEnabled = data.creatorEnabled,
		viewerCanRead = data.viewerCanRead,
		viewerCanWrite = data.viewerCanWrite
	}
end

return convertApiMomentComments
