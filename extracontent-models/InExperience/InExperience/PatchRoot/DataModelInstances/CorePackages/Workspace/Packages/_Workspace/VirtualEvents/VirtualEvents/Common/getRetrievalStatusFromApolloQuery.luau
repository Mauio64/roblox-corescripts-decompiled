local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.ApolloClient)
local Http = require(VirtualEvents.Parent.Http)

local RetrievalStatus = Http.Enum.RetrievalStatus

local function getRetrievalStatusFromApolloQuery(data)
	if data.loading then
		return RetrievalStatus.Fetching
	end

	if data.data then
		return RetrievalStatus.Done
	end

	if data.error then
		return RetrievalStatus.Failed
	end

	return RetrievalStatus.NotStarted
end

return getRetrievalStatusFromApolloQuery
