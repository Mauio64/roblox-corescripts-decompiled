local HttpService = game:GetService("HttpService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local fFlagMomentsOptimisticProfilePending = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsOptimisticProfilePending
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/tutils")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed
local fFlagMomentsServeEDPVideos = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsServeEDPVideos
local FFlagMomentsTTSFeedPlayback = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsTTSFeedPlayback")
local FFlagMomentsTTSPendingPreviewPlayback = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsTTSPendingPreviewPlayback")
local GetFFlagMomentsRenderPostAssets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/GetFFlagMomentsRenderPostAssets")
local deriveMomentFromPost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/deriveMomentFromPost")
local MomentsGetPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetPostAssetStore")

local fFlagMomentsVideoPermissionContextFix = MomentsCommon.Flags.FFlagMomentsVideoPermissionContextFix

local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailType = Foundation.Enums.ThumbnailType

local function getMediaContentUri(p2, p3, p4)
	local formatted = `rbxassetid://{p2}`

	if p3 == Enum.CaptureType.Video and p4 ~= nil then
		return `{formatted}&accessContext={p4}&permissionContext=ignoreUniverse`
	end

	return formatted
end

local function getMediaContents(assetId, captureType, p2)
	local fromUri = Content.fromUri
	local formatted = `rbxassetid://{assetId}`

	if captureType == Enum.CaptureType.Video and p2 ~= nil then
		formatted = `{formatted}&accessContext={p2}&permissionContext=ignoreUniverse`
	end

	local content = fromUri(formatted)

	if
		fFlagMomentsVideoPermissionContextFix
		and game.GameId == 0
		and captureType == Enum.CaptureType.Video
		and p2 ~= nil
	then
		return Content.fromUri(`rbxassetid://{assetId}&accessContext={p2}`), content
	end

	return content, nil
end

local function getLocalTts(p2, p3)
	if p2 == nil or p3 == nil then
		return nil
	end

	local tts = p3.tts

	if tts == nil or tts.text == nil or tts.text == "" then
		return nil
	end

	return tts
end

local function toMediaItem(p2, p3)
	local v5 = not (p3 == nil) and p3.includeLocalTts == true

	if fFlagMomentsRenderAvatarPostsInFeed and p2.kind == "avatarMoment" then
		local moment = p2.moment
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
		if p2.kind ~= "moment" then
			return nil
		end

		local moment = p2.moment

		if moment == nil or moment.metadata == nil then
			return nil
		end

		if GetFFlagMomentsRenderPostAssets() then
			local function createMediaItem(data, p4)
				local localContent = if fFlagMomentsOptimisticProfilePending then data.localContent else nil

				local assetId = data.assetId
				local assetAccessContext

				if not (fFlagMomentsServeEDPVideos and data.entityType == "edpVideo") then
					assetAccessContext = data.metadata.assetAccessContext
				end

				local v6

				if not (assetAccessContext == nil or assetAccessContext == "") then
					v6 = HttpService:UrlEncode(assetAccessContext)
				end

				local v7

				if localContent == nil then
					if assetId > 0 then
						local fromUri = Content.fromUri
						local v8

						if v6 == nil then
							v8 = getRbxThumb(thumbnailType.Asset, assetId)
						else
							v8 = `{getRbxThumb(thumbnailType.Asset, assetId)}&accessContext={v6}`
						end

						v7 = fromUri(v8)
					end
				else
					v7 = localContent
				end

				local edits = data.metadata.edits

				if not FFlagMomentsTTSFeedPlayback and edits ~= nil and edits.ttsAudios ~= nil then
					edits = table.clone(edits)
					edits.ttsAudios = nil
				end

				local mediaContents, v8 = getMediaContents(assetId, data.metadata.captureType, v6)

				local mediaItem = {
					momentId = data.momentId,
					sourceKey = p4,
					content = localContent or mediaContents,
					preloadContent = 0,
					posterContent = 0,
					captureType = 0,
					edits = 0,
					localTts = 0
				}

				if localContent ~= nil then
					v8 = nil
				end

				mediaItem.preloadContent = v8
				mediaItem.posterContent = v7
				mediaItem.captureType = data.metadata.captureType
				mediaItem.edits = edits
				local tts

				if FFlagMomentsTTSPendingPreviewPlayback and FFlagMomentsTTSFeedPlayback and v5 and localContent ~= nil and edits ~= nil then
					tts = edits.tts

					if tts == nil or tts.text == nil or tts.text == "" then
						tts = nil
					end
				end

				mediaItem.localTts = tts
				return mediaItem
			end

			local mediaItem = createMediaItem(moment, `json:{moment.assetId}`)
			local postAssetId = if moment.postAsset ~= nil then moment.postAsset.postAssetId else nil

			if postAssetId == nil or postAssetId <= 0 then
				return mediaItem
			end

			function mediaItem.resolve(p4)
				local data = MomentsGetPostAssetStore(false).getAndFetchPostAsset(postAssetId).data(p4)

				if data == nil then
					return mediaItem
				end

				local v6 = deriveMomentFromPost(moment, data)

				if v6 == nil then
					return mediaItem
				end

				local mediaItem2 = createMediaItem(v6, `post:{postAssetId}`)
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
			local localContent = if fFlagMomentsOptimisticProfilePending then moment.localContent else nil
			local assetAccessContext

			if not (fFlagMomentsServeEDPVideos and moment.entityType == "edpVideo") then
				assetAccessContext = moment.metadata.assetAccessContext
			end

			local v6

			if not (assetAccessContext == nil or assetAccessContext == "") then
				v6 = HttpService:UrlEncode(assetAccessContext)
			end

			local v7

			if localContent == nil then
				if assetId > 0 then
					local fromUri = Content.fromUri
					local v8

					if v6 == nil then
						v8 = getRbxThumb(thumbnailType.Asset, assetId)
					else
						v8 = `{getRbxThumb(thumbnailType.Asset, assetId)}&accessContext={v6}`
					end

					v7 = fromUri(v8)
				end
			else
				v7 = localContent
			end

			local edits = moment.metadata.edits

			if not FFlagMomentsTTSFeedPlayback and edits ~= nil and edits.ttsAudios ~= nil then
				edits = table.clone(edits)
				edits.ttsAudios = nil
			end

			local mediaContents, v8 = getMediaContents(assetId, moment.metadata.captureType, v6)
			local v9 = {
				momentId = moment.momentId,
				content = localContent or mediaContents,
				preloadContent = 0,
				posterContent = 0,
				captureType = 0,
				edits = 0,
				localTts = 0
			}

			if localContent ~= nil then
				v8 = nil
			end

			v9.preloadContent = v8
			v9.posterContent = v7
			v9.captureType = moment.metadata.captureType
			v9.edits = edits
			local tts

			if FFlagMomentsTTSPendingPreviewPlayback and FFlagMomentsTTSFeedPlayback and v5 and localContent ~= nil and edits ~= nil then
				tts = edits.tts

				if tts == nil or tts.text == nil or tts.text == "" then
					tts = nil
				end
			end

			v9.localTts = tts
			return v9
		end
	end
end

return toMediaItem
