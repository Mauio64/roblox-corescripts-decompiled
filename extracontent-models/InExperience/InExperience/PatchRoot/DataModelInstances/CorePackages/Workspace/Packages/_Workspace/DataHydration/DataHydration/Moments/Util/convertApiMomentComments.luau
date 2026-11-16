local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)

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

	local count

	if type(data.count) == "number" then
		count = data.count
	end

	local countIsCapped

	if type(data.countIsCapped) == "boolean" then
		countIsCapped = data.countIsCapped
	end

	return {
		count = count,
		countIsCapped = countIsCapped,
		creatorEnabled = data.creatorEnabled,
		viewerCanRead = data.viewerCanRead,
		viewerCanWrite = data.viewerCanWrite
	}
end

return convertApiMomentComments
