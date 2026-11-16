local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local GetFFlagMomentsRenderPostAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsCommon/GetFFlagMomentsRenderPostAssets")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local convertApiMomentComments = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/convertApiMomentComments")

local FFlagMomentsStickerOverlayNormalization = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/FFlagMomentsStickerOverlayNormalization")

local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled
local fFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local fFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local momentStatus = MomentsTypes.Enums.MomentStatus

local builderSansMedium = Enum.Font.BuilderSansMedium
local color = Color3.new(0, 0, 0)

local center = Enum.TextXAlignment.Center

local udim = UDim2.fromScale(0.5, 0.5)

local function toCaptureType(p2)
	if p2 == "Screenshot" then
		return Enum.CaptureType.Screenshot
	end

	return Enum.CaptureType.Video
end

local function toMomentStatus(p2)
	if p2 == momentStatus.Deleted then
		return momentStatus.Deleted
	end

	return momentStatus.Public
end

local function toMomentEntityType(p2)
	if p2 == "experience" or p2 == "ad" then
		return p2
	end

	if fFlagMomentsServeEDPVideos and p2 == "edpVideo" then
		return "edpVideo"
	end

	return nil
end

local function toEnumItem(p2, value, p3)
	if typeof(value) == "EnumItem" then
		return value
	end

	if type(value) ~= "string" then
		return p3
	end

	local v5 = string.match(value, "([^%.]+)$") or value
	local success, result = pcall(function()
		return p2[v5]
	end)

	if success and result ~= nil then
		return result
	end

	return p3
end

local function toColor3(fontColor)
	if typeof(fontColor) == "Color3" then
		return fontColor
	end

	if type(fontColor) ~= "table" then
		return color
	end

	local r = fontColor.R or fontColor.r or fontColor.Red or fontColor.red or fontColor[1]
	local g = fontColor.G or fontColor.g or fontColor.Green or fontColor.green or fontColor[2]
	local b = fontColor.B or fontColor.b or fontColor.Blue or fontColor.blue or fontColor[3]

	if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
		return color
	end

	if r > 1 or g > 1 or b > 1 then
		return Color3.fromRGB(r, g, b)
	end

	return Color3.new(r, g, b)
end

local function toUDim2(position)
	if typeof(position) == "UDim2" then
		return position
	end

	if type(position) ~= "table" then
		return udim
	end

	if type(position[1]) == "number" and type(position[2]) == "number" then
		return UDim2.fromScale(position[1], position[2])
	end

	local x = position.X or position.x
	local y = position.Y or position.y

	if type(x) == "table" and type(y) == "table" then
		return UDim2.new(
			x.Scale or x.scale or 0,
			x.Offset or x.offset or 0,
			y.Scale or y.scale or 0,
			y.Offset or y.offset or 0
		)
	end

	return UDim2.new(
		position.XScale or position.xScale or position.scaleX or position[1] or 0.5,
		position.XOffset or position.xOffset or position.offsetX or position[2] or 0,
		position.YScale or position.yScale or position.scaleY or position[3] or 0.5,
		position.YOffset or position.yOffset or position.offsetY or position[4] or 0
	)
end

local function normalizeTextOverlayEdit(textOverlay)
	if type(textOverlay) ~= "table" then
		return nil
	end

	local textOverlayStyle = textOverlay.textOverlayStyle or {}
	return {
		position = toUDim2(textOverlay.position),
		rotation = type(textOverlay.rotation) ~= "number" and 0 or textOverlay.rotation,
		scale = type(textOverlay.scale) ~= "number" and 1 or textOverlay.scale,
		text = type(textOverlay.text) ~= "string" and "" or textOverlay.text,
		textOverlayStyle = {
			font = toEnumItem(Enum.Font, textOverlayStyle.font, builderSansMedium),
			fontColor = toColor3(textOverlayStyle.fontColor),
			fontSize = type(textOverlayStyle.fontSize) ~= "number" and 16 or textOverlayStyle.fontSize,
			textXAlignment = toEnumItem(Enum.TextXAlignment, textOverlayStyle.textXAlignment, center)
		},
		zIndex = type(textOverlay.zIndex) ~= "number" and 1 or textOverlay.zIndex
	}
end

local function normalizeStickerOverlayEdit(stickerOverlay)
	if type(stickerOverlay) ~= "table" then
		return nil
	end

	if type(stickerOverlay.stickerURI) == "string" and stickerOverlay.stickerURI ~= "" then
		return {
			position = toUDim2(stickerOverlay.position),
			rotation = type(stickerOverlay.rotation) ~= "number" and 0 or stickerOverlay.rotation,
			scale = type(stickerOverlay.scale) ~= "number" and 1 or stickerOverlay.scale,
			stickerSize = type(stickerOverlay.stickerSize) ~= "number" and 1 or stickerOverlay.stickerSize,
			stickerURI = type(stickerOverlay.stickerURI) ~= "string" and "" or stickerOverlay.stickerURI,
			zIndex = type(stickerOverlay.zIndex) ~= "number" and 1 or stickerOverlay.zIndex
		}
	end

	return nil
end

local function normalizeTtsEdit(ttsAudio)
	if type(ttsAudio) ~= "table" then
		return nil
	end

	local assetId = tonumber(ttsAudio.assetId)

	if assetId == nil or assetId <= 0 then
		return nil
	end

	local v5 = {
		text = type(ttsAudio.text) ~= "string" and "" or ttsAudio.text,
		voiceId = type(ttsAudio.voiceId) ~= "number" and 0 or ttsAudio.voiceId,
		startTime = type(ttsAudio.startTime) ~= "number" and 0 or ttsAudio.startTime,
		assetId = assetId,
		assetAccessContext = 0
	}

	local v6 = if type(ttsAudio.assetAccessContext) == "string" then ttsAudio.assetAccessContext else nil
	v5.assetAccessContext = v6
	return v5
end

local function normalizeCaptureEdits(data)
	if data == nil then
		return nil
	end

	local v5 = nil

	if type(data.textOverlays) == "table" then
		local textOverlayEdits = {}

		for k, textOverlay in data.textOverlays do
			local textOverlayEdit = normalizeTextOverlayEdit(textOverlay)

			if textOverlayEdit ~= nil then
				table.insert(textOverlayEdits, textOverlayEdit)
			end
		end

		if #textOverlayEdits > 0 then
			v5 = textOverlayEdits
		end
	end

	local v6 = nil

	if FFlagMomentsStickerOverlayNormalization() and type(data.stickerOverlays) == "table" then
		local stickerOverlayEdits = {}

		for k, stickerOverlay in data.stickerOverlays do
			local stickerOverlayEdit = normalizeStickerOverlayEdit(stickerOverlay)

			if stickerOverlayEdit ~= nil then
				table.insert(stickerOverlayEdits, stickerOverlayEdit)
			end
		end

		if #stickerOverlayEdits > 0 then
			v6 = stickerOverlayEdits
		end
	end

	local v7 = nil

	if type(data.ttsAudios) == "table" then
		local ttsEdits = {}

		for k, ttsAudio in data.ttsAudios do
			local ttsEdit = normalizeTtsEdit(ttsAudio)

			if ttsEdit ~= nil then
				table.insert(ttsEdits, ttsEdit)
			end
		end

		if #ttsEdits > 0 then
			v7 = ttsEdits
		end
	end

	return {
		trim = data.trim,
		music = data.music,
		ttsAudios = v7,
		textOverlays = v5,
		stickerOverlays = v6
	}
end

local function reactionTotal(p2)
	if p2 == nil or p2.counts == nil then
		return nil
	end

	local total = 0

	for k, count in p2.counts do
		total += count
	end

	return total
end

local function convertApiMomentToMomentItem(data)
	local captionedAssetMoment = data.captionedAssetMoment
	local postAssetId

	if fFlagMomentsRenderAvatarPostsInFeed and data.postAsset ~= nil then
		postAssetId = data.postAsset.postAssetId
	end

	local v5 = fFlagMomentsRenderAvatarPostsInFeed

	if v5 then
		if
			(captionedAssetMoment == nil or captionedAssetMoment.captureType ~= "Avatar")
			and data.entityType ~= "avatar"
			or typeof(postAssetId) ~= "number"
		then
			v5 = false
		else
			v5 = postAssetId > 0
		end
	end

	local v6 = fFlagMomentsRenderAvatarPostsInFeed
		and captionedAssetMoment == nil
		and v5
		and { assetId = 0, captureType = "Avatar" }
		or captionedAssetMoment

	local owner = data.owner
	local v7 = if fFlagMomentsServeEDPVideos then data.entityType == "edpVideo" else nil
	local v8

	if fFlagMomentsServeEDPVideos and v7 then
		v8 = data.id

		if not v8 then
			v8 = if not (v6 == nil or v6.assetId == nil) then tostring(v6.assetId) else nil
		end
	else
		v8 = data.entityId or data.id
	end

	local feedItemId = data.feedItemId

	if
		v6 == nil
		or v6.assetId == nil
		or not (fFlagMomentsServeEDPVideos and v7) and (owner == nil or owner.id == nil)
		or v8 == nil
		or feedItemId == nil
		or feedItemId == ""
	then
		return nil
	end

	local experienceCta = if data.primaryCta ~= nil then data.primaryCta.experienceCta else nil
	local v9

	if fFlagMomentsServeEDPVideos then
		if experienceCta == nil then
			if v7 then
				v9 = tonumber(data.entityId)
			end
		else
			v9 = experienceCta.experienceId
		end
	end

	local v10 = if v6.captureType == "Screenshot" then v6.screenshotCaptureEdits else v6.videoCaptureEdits
	local captureEdits = normalizeCaptureEdits(v10)
	local v11

	if (v6.status or data.status) == momentStatus.Deleted then
		v11 = momentStatus.Deleted
	else
		v11 = momentStatus.Public
	end

	local v12 = {
		assetId = v6.assetId,
		channelId = 0,
		creatorId = 0,
		isModerated = 0,
		metadata = 0,
		entityType = 0,
		momentId = 0,
		postAsset = 0,
		recommendationMetadata = 0,
		status = 0
	}

	local v13 = if fFlagEnableMomentsCommentReporting and type(data.channelId) == "string" and data.channelId ~= "" then data.channelId else nil
	v12.channelId = v13

	v12.creatorId = fFlagMomentsServeEDPVideos and (owner == nil or owner.id == nil) and 0 or owner.id
	v12.isModerated = v6.isModerated
	local v14 = {
		assetToken = v6.assetToken,
		assetTotalDuration = v6.assetTotalDuration,
		assetAccessContext = v6.assetAccessContext,
		captureType = 0,
		description = 0,
		edits = 0,
		experienceName = 0,
		likeCount = 0,
		partnerUploadType = 0,
		placeId = 0,
		universeId = 0
	}
	local v15 = if v6.captureType == "Screenshot" then Enum.CaptureType.Screenshot else Enum.CaptureType.Video
	v14.captureType = v15
	v14.description = v6.caption
	v14.edits = captureEdits
	local v16 = if experienceCta ~= nil then experienceCta.experienceName else nil
	v14.experienceName = v16
	local reactions = data.reactions
	local v17

	if not (reactions == nil or reactions.counts == nil) then
		v17 = 0

		for k, count in reactions.counts do
			v17 += count
		end
	end

	v14.likeCount = v17
	v14.partnerUploadType = v6.partnerUploadType
	local v18 = if experienceCta ~= nil then experienceCta.placeId else nil
	v14.placeId = v18

	if not fFlagMomentsServeEDPVideos then
		v9 = if experienceCta ~= nil then experienceCta.experienceId else nil
	end

	v14.universeId = v9
	v12.metadata = v14
	local entityType

	if fFlagMomentsServeEDPVideos then
		entityType = data.entityType

		if
			entityType ~= "experience"
			and entityType ~= "ad"
			and (not fFlagMomentsServeEDPVideos or entityType ~= "edpVideo")
		then
			entityType = nil
		end
	end

	v12.entityType = entityType
	v12.momentId = v8
	v12.postAsset = fFlagMomentsRenderAvatarPostsInFeed
		and v5
		and { postAssetId = postAssetId, isAvatar = true }
		or GetFFlagMomentsRenderPostAssets()
		and data.postAsset ~= nil
		and data.postAsset.postAssetId ~= nil
		and { postAssetId = data.postAsset.postAssetId }
		or nil

	v12.recommendationMetadata = {
		feedItemId = feedItemId,
		tracingId = data.feedSessionId
	}

	v12.status = v11

	if type(data.feedCreatedTime) == "string" and data.feedCreatedTime ~= "" then
		v12.createdAt = data.feedCreatedTime
	end

	if fFlagMomentsComments or fFlagMomentsCommentsIxpEnabled then
		local v19 = convertApiMomentComments(data.comments)

		if v19 ~= nil then
			v12.comments = v19
		end
	end

	if not fFlagProfileMomentSceneOutfitPoster or v6.captureType ~= "Avatar" then
		return v12
	end

	v12.metadata.isMomentScene = true
	local postAsset = data.postAsset

	if v12.postAsset == nil and postAsset ~= nil and postAsset.postAssetId ~= nil then
		v12.postAsset = { postAssetId = postAsset.postAssetId }
	end

	return v12
end

local function convertApiMomentsToMomentItems(list)
	local result = {}

	if list == nil then
		return result
	end

	for i, item in ipairs(list) do
		local v5 = convertApiMomentToMomentItem(item)

		if v5 ~= nil then
			table.insert(result, v5)
		end
	end

	return result
end

return convertApiMomentsToMomentItems
