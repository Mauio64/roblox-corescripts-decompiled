local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local MomentsTypes = require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local GetFFlagMomentsRenderPostAssets = require(parent.MomentsCommon.GetFFlagMomentsRenderPostAssets)
require(DataHydration.Moments.MomentsStoreTypes)
local convertApiMomentComments = require(DataHydration.Moments.Util.convertApiMomentComments)

local FFlagMomentsStickerOverlayNormalization = require(DataHydration.Moments.FFlagMomentsStickerOverlayNormalization)

local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled
local FFlagProfileMomentSceneOutfitPoster = SharedFlags.FFlagProfileMomentSceneOutfitPoster
local FFlagEnableMomentsCommentReporting = SharedFlags.FFlagEnableMomentsCommentReporting
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local MomentStatus = MomentsTypes.Enums.MomentStatus

local BuilderSansMedium = Enum.Font.BuilderSansMedium
local color = Color3.new(0, 0, 0)

local Center = Enum.TextXAlignment.Center

local udim = UDim2.fromScale(0.5, 0.5)

local function toCaptureType(captureType: string?) -- 1 equivalent call inferred from this helper
	if captureType == "Screenshot" then
		return Enum.CaptureType.Screenshot
	end

	return Enum.CaptureType.Video
end

local function toMomentStatus(status: string?) -- 1 equivalent call inferred from this helper
	if status == MomentStatus.Deleted then
		return MomentStatus.Deleted
	end

	return MomentStatus.Public
end

local function toMomentEntityType(entityType: string?) -- 1 equivalent call inferred from this helper
	if entityType == "experience" or entityType == "ad" then
		return entityType
	end

	if FFlagMomentsServeEDPVideos and entityType == "edpVideo" then
		return "edpVideo"
	end

	return nil
end

local function toEnumItem(p, value, p2)
	if typeof(value) == "EnumItem" then
		return value
	end

	if type(value) ~= "string" then
		return p2
	end

	local v = string.match(value, "([^%.]+)$") or value
	local success, result = pcall(function()
		return p[v]
	end)
	return if success and result ~= nil then result else p2
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
			font = toEnumItem(Enum.Font, textOverlayStyle.font, BuilderSansMedium),
			fontColor = toColor3(textOverlayStyle.fontColor),
			fontSize = type(textOverlayStyle.fontSize) ~= "number" and 16 or textOverlayStyle.fontSize,
			textXAlignment = toEnumItem(Enum.TextXAlignment, textOverlayStyle.textXAlignment, Center)
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

	local v = {
		text = type(ttsAudio.text) ~= "string" and "" or ttsAudio.text,
		voiceId = type(ttsAudio.voiceId) ~= "number" and 0 or ttsAudio.voiceId,
		startTime = type(ttsAudio.startTime) ~= "number" and 0 or ttsAudio.startTime,
		assetId = assetId,
		assetAccessContext = 0
	}
	local assetAccessContext

	if type(ttsAudio.assetAccessContext) == "string" then
		assetAccessContext = ttsAudio.assetAccessContext
	end

	v.assetAccessContext = assetAccessContext
	return v
end

local function normalizeCaptureEdits(data)
	if data == nil then
		return nil
	end

	local textOverlays = nil

	if type(data.textOverlays) == "table" then
		local textOverlayEdits = {}

		for _, textOverlay in data.textOverlays do
			local textOverlayEdit = normalizeTextOverlayEdit(textOverlay)

			if textOverlayEdit ~= nil then
				table.insert(textOverlayEdits, textOverlayEdit)
			end
		end

		if #textOverlayEdits > 0 then
			textOverlays = textOverlayEdits
		end
	end

	local stickerOverlays = nil

	if FFlagMomentsStickerOverlayNormalization() and type(data.stickerOverlays) == "table" then
		local stickerOverlayEdits = {}

		for _, stickerOverlay in data.stickerOverlays do
			local stickerOverlayEdit = normalizeStickerOverlayEdit(stickerOverlay)

			if stickerOverlayEdit ~= nil then
				table.insert(stickerOverlayEdits, stickerOverlayEdit)
			end
		end

		if #stickerOverlayEdits > 0 then
			stickerOverlays = stickerOverlayEdits
		end
	end

	local ttsAudios = nil

	if type(data.ttsAudios) == "table" then
		local ttsEdits = {}

		for _, ttsAudio in data.ttsAudios do
			local ttsEdit = normalizeTtsEdit(ttsAudio)

			if ttsEdit ~= nil then
				table.insert(ttsEdits, ttsEdit)
			end
		end

		if #ttsEdits > 0 then
			ttsAudios = ttsEdits
		end
	end

	return {
		trim = data.trim,
		music = data.music,
		ttsAudios = ttsAudios,
		textOverlays = textOverlays,
		stickerOverlays = stickerOverlays
	}
end

local function reactionTotal(p)
	if p == nil or p.counts == nil then
		return nil
	end

	local total = 0

	for _, count in p.counts do
		total += count
	end

	return total
end

local function convertApiMomentToMomentItem(data)
	local captionedAssetMoment = data.captionedAssetMoment
	local postAssetId

	if FFlagMomentsRenderAvatarPostsInFeed and data.postAsset ~= nil then
		postAssetId = data.postAsset.postAssetId
	end

	local v = FFlagMomentsRenderAvatarPostsInFeed

	if v then
		if
			(captionedAssetMoment == nil or captionedAssetMoment.captureType ~= "Avatar")
			and data.entityType ~= "avatar"
			or typeof(postAssetId) ~= "number"
		then
			v = false
		else
			v = postAssetId > 0
		end
	end

	local v2 = FFlagMomentsRenderAvatarPostsInFeed
		and captionedAssetMoment == nil
		and v
		and { assetId = 0, captureType = "Avatar" }
		or captionedAssetMoment

	local owner = data.owner
	local v3

	if FFlagMomentsServeEDPVideos then
		v3 = data.entityType == "edpVideo"
	end

	local momentId

	if FFlagMomentsServeEDPVideos and v3 then
		momentId = data.id

		if not momentId then
			if v2 == nil or v2.assetId == nil then
				momentId = nil
			else
				momentId = tostring(v2.assetId)
			end
		end
	else
		momentId = data.entityId or data.id
	end

	local feedItemId = data.feedItemId

	if
		v2 == nil
		or v2.assetId == nil
		or not (FFlagMomentsServeEDPVideos and v3) and (owner == nil or owner.id == nil)
		or momentId == nil
		or feedItemId == nil
		or feedItemId == ""
	then
		return nil
	end

	local experienceCta

	if data.primaryCta ~= nil then
		experienceCta = data.primaryCta.experienceCta
	end

	local universeId

	if FFlagMomentsServeEDPVideos then
		if experienceCta == nil then
			if v3 then
				universeId = tonumber(data.entityId)
			end
		else
			universeId = experienceCta.experienceId
		end
	end

	local v4

	if v2.captureType == "Screenshot" then
		v4 = v2.screenshotCaptureEdits
	else
		v4 = v2.videoCaptureEdits
	end

	local captureEdits = normalizeCaptureEdits(v4)
	local status = toMomentStatus(v2.status or data.status) -- inferred equivalent call

	local v5 = {
		assetId = v2.assetId,
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
	local channelId

	if FFlagEnableMomentsCommentReporting and type(data.channelId) == "string" and data.channelId ~= "" then
		channelId = data.channelId
	end

	v5.channelId = channelId

	v5.creatorId = FFlagMomentsServeEDPVideos and (owner == nil or owner.id == nil) and 0 or owner.id
	v5.isModerated = v2.isModerated
	local metadata = {
		assetToken = v2.assetToken,
		assetTotalDuration = v2.assetTotalDuration,
		assetAccessContext = v2.assetAccessContext,
		captureType = toCaptureType(v2.captureType), -- inferred equivalent call
		description = v2.caption,
		edits = captureEdits,
		experienceName = 0,
		likeCount = 0,
		partnerUploadType = 0,
		placeId = 0,
		universeId = 0
	}
	local experienceName

	if experienceCta ~= nil then
		experienceName = experienceCta.experienceName
	end

	metadata.experienceName = experienceName
	local reactions = data.reactions
	local likeCount

	if not (reactions == nil or reactions.counts == nil) then
		likeCount = 0

		for _, count in reactions.counts do
			likeCount += count
		end
	end

	metadata.likeCount = likeCount
	metadata.partnerUploadType = v2.partnerUploadType
	local placeId

	if experienceCta ~= nil then
		placeId = experienceCta.placeId
	end

	metadata.placeId = placeId

	if not FFlagMomentsServeEDPVideos then
		if experienceCta == nil then
			universeId = nil
		else
			universeId = experienceCta.experienceId
		end
	end

	metadata.universeId = universeId
	v5.metadata = metadata
	local entityType

	if FFlagMomentsServeEDPVideos then
		entityType = data.entityType
		entityType = toMomentEntityType(entityType) -- inferred equivalent call
	end

	v5.entityType = entityType
	v5.momentId = momentId
	v5.postAsset = FFlagMomentsRenderAvatarPostsInFeed and v and {
			postAssetId = postAssetId,
			isAvatar = true
		}
		or GetFFlagMomentsRenderPostAssets()
		and data.postAsset ~= nil
		and data.postAsset.postAssetId ~= nil
		and { postAssetId = data.postAsset.postAssetId }
		or nil

	v5.recommendationMetadata = { feedItemId = feedItemId, tracingId = data.feedSessionId }

	v5.status = status

	if type(data.feedCreatedTime) == "string" and data.feedCreatedTime ~= "" then
		v5.createdAt = data.feedCreatedTime
	end

	if FFlagMomentsComments or FFlagMomentsCommentsIxpEnabled then
		local comments = convertApiMomentComments(data.comments)

		if comments ~= nil then
			v5.comments = comments
		end
	end

	if not FFlagProfileMomentSceneOutfitPoster or v2.captureType ~= "Avatar" then
		return v5
	end

	v5.metadata.isMomentScene = true
	local postAsset = data.postAsset

	if v5.postAsset == nil and postAsset ~= nil and postAsset.postAssetId ~= nil then
		v5.postAsset = { postAssetId = postAsset.postAssetId }
	end

	return v5
end

local function convertApiMomentsToMomentItems(list)
	local result = {}

	if list == nil then
		return result
	end

	for _, item in ipairs(list) do
		local v = convertApiMomentToMomentItem(item)

		if v ~= nil then
			table.insert(result, v)
		end
	end

	return result
end

return convertApiMomentsToMomentItems
