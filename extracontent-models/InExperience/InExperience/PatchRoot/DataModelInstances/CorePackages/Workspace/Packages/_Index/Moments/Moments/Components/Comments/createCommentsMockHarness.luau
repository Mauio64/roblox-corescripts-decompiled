local parent = script:FindFirstAncestor("Moments").Parent

local MomentsComments = require(parent.DataHydration.MomentsComments)
local MomentsCreateCommentsMockNetwork = require(parent.DataHydration.MomentsCreateCommentsMockNetwork)
require(parent.DataHydration.MomentsStoreTypes)

local createCommentCollectionStore = require(script.Parent.GetCommentCollectionStore.createCommentCollectionStore)

local createCommentSessionFiltersStore = require(script.Parent.GetCommentSessionFiltersStore.createCommentSessionFiltersStore)

local function createCommentsMockHarness(p)
	local latencySeconds

	if p ~= nil then
		latencySeconds = p.latencySeconds
	end

	local postOutcome

	if p ~= nil then
		postOutcome = p.postOutcome
	end

	local network = MomentsCreateCommentsMockNetwork({
		latencySeconds = latencySeconds,
		postOutcome = postOutcome
	})

	local momentsCommentsStore = MomentsComments.createMomentsCommentsStore({ network = network })

	local commentSessionFiltersStore = createCommentSessionFiltersStore()
	local commentCollectionStore = createCommentCollectionStore({
		sessionFilters = commentSessionFiltersStore
	})

	commentCollectionStore.selectFeed("feed-1", momentsCommentsStore.getOwnerGeneration(false))
	local flag = false

	local function dispose()
		if flag then
			return
		end

		flag = true
		commentCollectionStore.dispose()
		momentsCommentsStore.dispose()
	end

	return {
		network = network,
		commentsEntityStore = momentsCommentsStore,
		collectionStore = commentCollectionStore,
		sessionFilters = commentSessionFiltersStore,
		dispose = dispose
	}
end

return createCommentsMockHarness
