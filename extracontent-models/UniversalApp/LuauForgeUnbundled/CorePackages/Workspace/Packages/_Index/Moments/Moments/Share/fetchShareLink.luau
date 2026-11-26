local MomentsGetMomentsShareLinkStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsShareLinkStore")

local function fetchShareLink(data)
	local fetchShareLink2 = MomentsGetMomentsShareLinkStore(false).getAndFetchShareLink(
		data.momentId,
		data.description,
		data.title,
		data.feedItemId
	)

	while fetchShareLink2.status(false) == "NotReady" do
		task.wait()
	end

	if fetchShareLink2.status(false) == "Ready" then
		return fetchShareLink2.data(false)
	end

	return nil
end

return fetchShareLink
