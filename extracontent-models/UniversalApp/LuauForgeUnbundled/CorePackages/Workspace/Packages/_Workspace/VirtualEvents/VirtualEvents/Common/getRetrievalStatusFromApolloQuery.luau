require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ApolloClient")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Http").Enum.RetrievalStatus

local function getRetrievalStatusFromApolloQuery(data)
	if data.loading then
		return retrievalStatus.Fetching
	end

	if data.data then
		return retrievalStatus.Done
	end

	if data.error then
		return retrievalStatus.Failed
	end

	return retrievalStatus.NotStarted
end

return getRetrievalStatusFromApolloQuery
