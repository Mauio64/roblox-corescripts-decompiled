require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local deriveMomentFromPost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/deriveMomentFromPost")

local analytics = MomentsCommon.Analytics

local function getAvatarPostPayload(data)
	local v5 = nil
	local v6 = nil

	for k, v7 in data.tracks or {} do
		for k2, v8 in v7.slots or {} do
			local content = v8.content

			if content == nil then
				continue
			end

			if content.type == "avatar_annotation" then
				local outfit_id = content.value.outfit_id

				if typeof(outfit_id) == "number" and outfit_id > 0 then
					v6 = outfit_id
				end
			elseif content.type == "visual" then
				local content2 = content.value.content

				if content2 ~= nil and content2.type == "scene" then
					local rbxm_data = content2.value.rbxm_data

					if typeof(rbxm_data) == "buffer" and buffer.len(rbxm_data) > 0 then
						v5 = rbxm_data
					end
				end
			end
		end
	end

	return v5, v6
end

local function classifyPost(item, data, avatarPostPayload, p2)
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
			source = { type = "outfit", id = p2 }
		},
		rbxmData = avatarPostPayload
	}
end

local function hydrateAvatarMomentFeedItemsImpl(list, p2)
	local clone = table.clone(list)
	local v5 = {}

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
			local success, result = pcall(p2.getAndFetchPostAsset, postAssetId)

			if success then
				v5[k] = { item = item, postAssetId = postAssetId, result = result }
			else
				analytics.fireAnalyticsEvent(analytics.EventNames.AvatarMomentLoadFailed, {
					stage = "fetchPostAsset",
					momentId = item.moment.momentId,
					feedItemId = item.moment.recommendationMetadata.feedItemId,
					postAssetId = tostring(postAssetId)
				})
			end
		else
			analytics.fireAnalyticsEvent(analytics.EventNames.AvatarMomentLoadFailed, {
				stage = "validatePostAssetId",
				momentId = item.moment.momentId,
				feedItemId = item.moment.recommendationMetadata.feedItemId
			})
		end
	end

	for k, v6 in v5 do
		local item = v6.item
		local postAssetId = v6.postAssetId
		local result = v6.result
		local v7 = "loadPostAsset"
		local success, result2 = pcall(function()
			local v8 = result.status(false)

			while v8 == "NotReady" do
				task.wait()
				v8 = result.status(false)
			end

			local data = result.data(false)

			if data == nil then
				return nil
			end

			v7 = "extractAvatarPostPayload"
			local avatarPostPayload, v9 = getAvatarPostPayload(data)

			if avatarPostPayload == nil then
				v7 = "findInlineScene"
				return nil
			end

			if v9 == nil then
				v7 = "findOutfitAnnotation"
				return nil
			end

			v7 = "classifyAvatarPost"
			return classifyPost(item, data, avatarPostPayload, v9)
		end)

		if success and result2 ~= nil then
			clone[k] = result2
		else
			analytics.fireAnalyticsEvent(analytics.EventNames.AvatarMomentLoadFailed, {
				stage = v7,
				momentId = item.moment.momentId,
				feedItemId = item.moment.recommendationMetadata.feedItemId,
				postAssetId = tostring(postAssetId)
			})
		end
	end

	local result = {}

	for i = 1, #list do
		local v6 = clone[i]

		if v6 ~= nil then
			table.insert(result, v6)
		end
	end

	return result
end

local function hydrateAvatarMomentFeedItems(p2, p3)
	if fFlagMomentsRenderAvatarPostsInFeed then
		return hydrateAvatarMomentFeedItemsImpl(p2, p3)
	end

	return p2
end

return hydrateAvatarMomentFeedItems
