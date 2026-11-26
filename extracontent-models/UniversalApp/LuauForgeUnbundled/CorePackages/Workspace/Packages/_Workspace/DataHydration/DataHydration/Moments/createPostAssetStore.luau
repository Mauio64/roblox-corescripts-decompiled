local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")

local function createPostAssetStore(options)
	local v5 = options or {}

	local momentsService = v5.momentsService or game:GetService("MomentsService")
	local v6 = v5.postDecoder
	local v7 = createSingleEntityResolver(function(p2)
		return Promise.new(function(callback, callback2)
			task.spawn(function()
				local v8 = table.pack(pcall(function()
					if v6 == nil then
						v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/ServiceContractsProto").posts.postasset.post.Post
					end

					local postAsync = momentsService:FetchPostAsync(p2)

					if not fFlagMomentsRenderAvatarPostsInFeed then
						return v6.decode(postAsync)
					end

					if typeof(postAsync) ~= "buffer" then
						error(`FetchPostAsync returned {typeof(postAsync)} instead of a buffer for Post {p2}`)
					end

					local decoded = v6.decode(postAsync)

					if decoded == nil then
						error(`Post decoder returned nil for Post {p2} ({buffer.len(postAsync)} bytes)`)
					end

					return decoded
				end))

				if v8[1] then
					callback(v8[2])
				else
					callback2(v8[2])
				end
			end)
		end)
	end, {
		resolver = { replaceItems = true }
	})

	return {
		getCachedPostAsset = v7.get,
		getAndFetchPostAsset = v7.getAndFetch,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createPostAssetStore
