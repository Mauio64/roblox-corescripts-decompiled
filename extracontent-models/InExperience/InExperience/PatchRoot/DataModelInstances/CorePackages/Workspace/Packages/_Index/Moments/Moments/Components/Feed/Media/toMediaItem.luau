local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local HttpService = game:GetService("HttpService")

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local tutils = require(parent.tutils)

require(Moments.Components.Feed.FeedTypes)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags2.FFlagMomentsRenderAvatarPostsInFeed
local SharedFlags3 = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags3.FFlagMomentsServeEDPVideos
local FFlagMomentsTTSFeedPlayback = require(Moments.Flags.FFlagMomentsTTSFeedPlayback)
local FFlagMomentsTTSPendingPreviewPlayback = require(Moments.Flags.FFlagMomentsTTSPendingPreviewPlayback)
local GetFFlagMomentsRenderPostAssets = require(parent.MomentsCommon.GetFFlagMomentsRenderPostAssets)
local deriveMomentFromPost = require(Moments.Utils.deriveMomentFromPost)
local MomentsGetPostAssetStore = require(parent.DataHydration.MomentsGetPostAssetStore)

local FFlagMomentsVideoPermissionContextFix = MomentsCommon.Flags.FFlagMomentsVideoPermissionContextFix

local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType

local function getMediaContentUri(p: number, p2, p3: string?) -- 1 equivalent call inferred from this helper
	local formatted = `rbxassetid://{p}`

	if p2 == Enum.CaptureType.Video and p3 ~= nil then
		return `{formatted}&accessContext={p3}&permissionContext=ignoreUniverse`
	end

	return formatted
end

local function getMediaContents(assetId: number, captureType, p: string?)
	local content = Content.fromUri(getMediaContentUri(assetId, captureType, p)) -- inferred equivalent call

	if
		FFlagMomentsVideoPermissionContextFix
		and game.GameId == 0
		and captureType == Enum.CaptureType.Video
		and p ~= nil
	then
		return Content.fromUri(`rbxassetid://{assetId}&accessContext={p}`), content
	end

	return content, nil
end

local function getLocalTts(p, p2)
	if p == nil or p2 == nil then
		return nil
	end

	local tts = p2.tts

	if tts == nil or tts.text == nil or tts.text == "" then
		return nil
	end

	return tts
end

local function toMediaItem(p, p2)
	local v

	if p2 == nil then
		v = false
	else
		v = p2.includeLocalTts == true
	end

	if FFlagMomentsRenderAvatarPostsInFeed and p.kind == "avatarMoment" then
		local moment = p.moment
		local edits = moment.metadata.edits

		if not FFlagMomentsTTSFeedPlayback and edits ~= nil and edits.ttsAudios ~= nil then
			edits = table.clone(edits)
			edits.ttsAudios = nil
		end

		return {
			momentId = moment.momentId,
			sourceKey = `avatar-post:{moment.momentId}`,
			content = Content.none,
			posterContent = nil,
			captureType = Enum.CaptureType.Screenshot,
			isExternalBase = true,
			edits = edits
		}
	else
		if p.kind ~= "moment" then
			return nil
		end

		local moment = p.moment

		if moment == nil or moment.metadata == nil then
			return nil
		end

		if GetFFlagMomentsRenderPostAssets() then
			local function createMediaItem(data, sourceKey: string)
				local localContent

				if FFlagMomentsOptimisticProfilePending then
					localContent = data.localContent
				end

				local assetId = data.assetId
				local assetAccessContext

				if not (FFlagMomentsServeEDPVideos and data.entityType == "edpVideo") then
					assetAccessContext = data.metadata.assetAccessContext
				end

				local v2

				if not (assetAccessContext == nil or assetAccessContext == "") then
					v2 = HttpService:UrlEncode(assetAccessContext)
				end

				local posterContent

				if localContent == nil then
					if assetId > 0 then
						local v3

						if v2 == nil then
							v3 = getRbxThumb(ThumbnailType.Asset, assetId)
						else
							v3 = `{getRbxThumb(ThumbnailType.Asset, assetId)}&accessContext={v2}`
						end

						posterContent = Content.fromUri(v3)
					end
				else
					posterContent = localContent
				end

				local edits = data.metadata.edits

				if not FFlagMomentsTTSFeedPlayback and edits ~= nil and edits.ttsAudios ~= nil then
					edits = table.clone(edits)
					edits.ttsAudios = nil
				end

				local mediaContents, preloadContent = getMediaContents(assetId, data.metadata.captureType, v2)

				local mediaItem = {
					momentId = data.momentId,
					sourceKey = sourceKey,
					content = localContent or mediaContents,
					preloadContent = 0,
					posterContent = 0,
					captureType = 0,
					edits = 0,
					localTts = 0
				}

				if localContent ~= nil then
					preloadContent = nil
				end

				mediaItem.preloadContent = preloadContent
				mediaItem.posterContent = posterContent
				mediaItem.captureType = data.metadata.captureType
				mediaItem.edits = edits
				local tts

				if
					FFlagMomentsTTSPendingPreviewPlayback
					and FFlagMomentsTTSFeedPlayback
					and v
					and localContent ~= nil
					and edits ~= nil
				then
					tts = edits.tts

					if tts == nil or tts.text == nil or tts.text == "" then
						tts = nil
					end
				end

				mediaItem.localTts = tts
				return mediaItem
			end

			local mediaItem = createMediaItem(moment, `json:{moment.assetId}`)
			local postAssetId

			if moment.postAsset == nil then
				postAssetId = nil
			else
				postAssetId = moment.postAsset.postAssetId
			end

			if postAssetId == nil or postAssetId <= 0 then
				return mediaItem
			end

			function mediaItem.resolve(p3)
				local data = MomentsGetPostAssetStore(false).getAndFetchPostAsset(postAssetId).data(p3)

				if data == nil then
					return mediaItem
				end

				local v2 = deriveMomentFromPost(moment, data)

				if v2 == nil then
					return mediaItem
				end

				local mediaItem2 = createMediaItem(v2, `post:{postAssetId}`)
				mediaItem2.cornerRadius = mediaItem.cornerRadius

				if
					mediaItem2.content.Uri == mediaItem.content.Uri
					and mediaItem2.captureType == mediaItem.captureType
					and tutils.deepEqual(mediaItem2.edits or {}, mediaItem.edits or {})
				then
					mediaItem2.sourceKey = mediaItem.sourceKey
				end

				return mediaItem2
			end

			return mediaItem
		else
			local assetId = moment.assetId
			local localContent

			if FFlagMomentsOptimisticProfilePending then
				localContent = moment.localContent
			end

			local assetAccessContext

			if not (FFlagMomentsServeEDPVideos and moment.entityType == "edpVideo") then
				assetAccessContext = moment.metadata.assetAccessContext
			end

			local v2

			if not (assetAccessContext == nil or assetAccessContext == "") then
				v2 = HttpService:UrlEncode(assetAccessContext)
			end

			local posterContent

			if localContent == nil then
				if assetId > 0 then
					local v3

					if v2 == nil then
						v3 = getRbxThumb(ThumbnailType.Asset, assetId)
					else
						v3 = `{getRbxThumb(ThumbnailType.Asset, assetId)}&accessContext={v2}`
					end

					posterContent = Content.fromUri(v3)
				end
			else
				posterContent = localContent
			end

			local edits = moment.metadata.edits

			if not FFlagMomentsTTSFeedPlayback and edits ~= nil and edits.ttsAudios ~= nil then
				edits = table.clone(edits)
				edits.ttsAudios = nil
			end

			local mediaContents, preloadContent = getMediaContents(assetId, moment.metadata.captureType, v2)
			local v3 = {
				momentId = moment.momentId,
				content = localContent or mediaContents,
				preloadContent = 0,
				posterContent = 0,
				captureType = 0,
				edits = 0,
				localTts = 0
			}

			if localContent ~= nil then
				preloadContent = nil
			end

			v3.preloadContent = preloadContent
			v3.posterContent = posterContent
			v3.captureType = moment.metadata.captureType
			v3.edits = edits
			local tts

			if
				FFlagMomentsTTSPendingPreviewPlayback
				and FFlagMomentsTTSFeedPlayback
				and v
				and localContent ~= nil
				and edits ~= nil
			then
				tts = edits.tts

				if tts == nil or tts.text == nil or tts.text == "" then
					tts = nil
				end
			end

			v3.localTts = tts
			return v3
		end
	end
end

return toMediaItem
