local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
require(script.Parent.MomentsStoreTypes)

local function createPostAssetStore(options)
	local v = options or {}

	local momentsService = v.momentsService or game:GetService("MomentsService")
	local v2 = v.postDecoder
	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return Promise.new(function(callback, callback2)
			task.spawn(function()
				local v3 = table.pack(pcall(function()
					if v2 == nil then
						local ServiceContractsProto = require(parent.ServiceContractsProto)
						v2 = ServiceContractsProto.posts.postasset.post.Post
					end

					local postAsync = momentsService:FetchPostAsync(p)

					if not FFlagMomentsRenderAvatarPostsInFeed then
						return v2.decode(postAsync)
					end

					if typeof(postAsync) ~= "buffer" then
						error(`FetchPostAsync returned {typeof(postAsync)} instead of a buffer for Post {p}`)
					end

					local decoded = v2.decode(postAsync)

					if decoded == nil then
						error(`Post decoder returned nil for Post {p} ({buffer.len(postAsync)} bytes)`)
					end

					return decoded
				end))

				if v3[1] then
					callback(v3[2])
				else
					callback2(v3[2])
				end
			end)
		end)
	end, {
		resolver = { replaceItems = true }
	})

	return {
		getCachedPostAsset = singleEntityResolver.get,
		getAndFetchPostAsset = singleEntityResolver.getAndFetch,
		clear = singleEntityResolver.clear,
		dispose = singleEntityResolver.dispose
	}
end

return createPostAssetStore
