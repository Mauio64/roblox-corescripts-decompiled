local Parent = script:FindFirstAncestor("Moments").Parent
local MomentsGetMomentsShareLinkStore = require(Parent.DataHydration.MomentsGetMomentsShareLinkStore)

local function fetchShareLink(t1: {[any]: any}) -- line: 13
	-- upvalues: MomentsGetMomentsShareLinkStore (copy)
	local v5 = MomentsGetMomentsShareLinkStore(false).getAndFetchShareLink(t1.momentId, t1.description, t1.title)

	while v5.status(false) == "NotReady" do
		task.wait()
	end

	if v5.status(false) == "Ready" then
		return v5.data(false)
	end

	return nil
end

return fetchShareLink
