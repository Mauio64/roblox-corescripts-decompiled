local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.ApolloClient)

local RetrievalStatus = require(VirtualEvents.Parent.Http).Enum.RetrievalStatus

local function getRetrievalStatusFromApolloQuery(p1) -- line: 16
	-- upvalues: RetrievalStatus (copy)
	if p1.loading then
		return RetrievalStatus.Fetching
	end

	if p1.data then
		return RetrievalStatus.Done
	end

	if p1.error then
		return RetrievalStatus.Failed
	end

	return RetrievalStatus.NotStarted
end

return getRetrievalStatusFromApolloQuery
