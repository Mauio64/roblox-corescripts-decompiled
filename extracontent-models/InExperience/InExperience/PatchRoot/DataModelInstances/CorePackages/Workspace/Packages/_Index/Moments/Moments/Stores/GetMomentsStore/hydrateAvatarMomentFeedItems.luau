local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.DataHydration.MomentsStoreTypes)
local MomentsCommon = require(parent.MomentsCommon)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

require(Moments.Components.Feed.FeedTypes)
local deriveMomentFromPost = require(Moments.Utils.deriveMomentFromPost)

local Analytics = MomentsCommon.Analytics

local function getAvatarPostPayload(data)
	local v = nil
	local v2 = nil

	for _, v3 in data.tracks or {} do
		for _, v4 in v3.slots or {} do
			local content = v4.content

			if content == nil then
				continue
			end

			if content.type == "avatar_annotation" then
				local outfit_id = content.value.outfit_id

				if typeof(outfit_id) == "number" and outfit_id > 0 then
					v2 = outfit_id
				end
			elseif content.type == "visual" then
				local content2 = content.value.content

				if content2 ~= nil and content2.type == "scene" then
					local rbxm_data = content2.value.rbxm_data

					if typeof(rbxm_data) == "buffer" and buffer.len(rbxm_data) > 0 then
						v = rbxm_data
					end
				end
			end
		end
	end

	return v, v2
end

local function classifyPost(item, data, avatarPostPayload: buffer, id: number)
	local clone = deriveMomentFromPost(item.moment, data) or item.moment

	if clone == item.moment then
		local metadata = data.metadata

		if metadata ~= nil and typeof(metadata.caption) == "string" and metadata.caption ~= "" then
			clone = table.clone(clone)
			clone.metadata = table.clone(item.moment.metadata)
			clone.metadata.description = metadata.caption
		end
	end

	return {
		kind = "avatarMoment",
		moment = clone,
		outfit = {
			source = { type = "outfit", id = id }
		},
		rbxmData = avatarPostPayload
	}
end

local function hydrateAvatarMomentFeedItemsImpl(list, p)
	local clone = table.clone(list)
	local v = {}

	for k, item in list do
		if item.kind ~= "moment" then
			continue
		end

		local postAsset = item.moment.postAsset

		if not (postAsset ~= nil and postAsset.isAvatar == true) then
			continue
		end

		local postAssetId = postAsset.postAssetId

		if typeof(postAssetId) == "number" and not (postAssetId <= 0) then
			clone[k] = nil
			local success, result = pcall(p.getAndFetchPostAsset, postAssetId)

			if success then
				v[k] = { item = item, postAssetId = postAssetId, result = result }
			else
				Analytics.fireAnalyticsEvent(Analytics.EventNames.AvatarMomentLoadFailed, {
					stage = "fetchPostAsset",
					momentId = item.moment.momentId,
					feedItemId = item.moment.recommendationMetadata.feedItemId,
					postAssetId = tostring(postAssetId)
				})
			end
		else
			Analytics.fireAnalyticsEvent(Analytics.EventNames.AvatarMomentLoadFailed, {
				stage = "validatePostAssetId",
				momentId = item.moment.momentId,
				feedItemId = item.moment.recommendationMetadata.feedItemId
			})
		end
	end

	for k, v2 in v do
		local item = v2.item
		local postAssetId = v2.postAssetId
		local result = v2.result
		local stage = "loadPostAsset"
		local success, result2 = pcall(function()
			local v3 = result.status(false)

			while v3 == "NotReady" do
				task.wait()
				v3 = result.status(false)
			end

			local data = result.data(false)

			if data == nil then
				return nil
			end

			stage = "extractAvatarPostPayload"
			local avatarPostPayload, id = getAvatarPostPayload(data)

			if avatarPostPayload == nil then
				stage = "findInlineScene"
				return nil
			end

			if id == nil then
				stage = "findOutfitAnnotation"
				return nil
			end

			stage = "classifyAvatarPost"
			return classifyPost(item, data, avatarPostPayload, id)
		end)

		if success and result2 ~= nil then
			clone[k] = result2
		else
			Analytics.fireAnalyticsEvent(Analytics.EventNames.AvatarMomentLoadFailed, {
				stage = stage,
				momentId = item.moment.momentId,
				feedItemId = item.moment.recommendationMetadata.feedItemId,
				postAssetId = tostring(postAssetId)
			})
		end
	end

	local result = {}

	for i = 1, #list do
		local v2 = clone[i]

		if v2 ~= nil then
			table.insert(result, v2)
		end
	end

	return result
end

local function hydrateAvatarMomentFeedItems(p, p2)
	if FFlagMomentsRenderAvatarPostsInFeed then
		return hydrateAvatarMomentFeedItemsImpl(p, p2)
	end

	return p
end

return hydrateAvatarMomentFeedItems
