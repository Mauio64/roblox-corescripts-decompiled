local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local MomentsTypes = require(DataHydrationParent.MomentsTypes)

require(DataHydration.Moments.MomentsStoreTypes)

local FFlagMomentsStickerOverlayNormalization = require(DataHydration.Moments.FFlagMomentsStickerOverlayNormalization)
local FFlagMomentsRequireApiFeedItemId = require(DataHydration.Moments.FFlagMomentsRequireApiFeedItemId)
local MomentStatus = MomentsTypes.Enums.MomentStatus
local BuilderSansMedium = Enum.Font.BuilderSansMedium
local color3 = Color3.new(0, 0, 0)
local Center = Enum.TextXAlignment.Center
local uDim2 = UDim2.fromScale(0.5, 0.5)

local function toCaptureType(s1: string?) -- line: 26
	if s1 == "Screenshot" then
		return Enum.CaptureType.Screenshot
	end

	return Enum.CaptureType.Video
end
local function toMomentStatus(s2: string?) -- line: 34
	-- upvalues: MomentStatus (copy)
	if s2 == MomentStatus.Deleted then
		return MomentStatus.Deleted
	end

	return MomentStatus.Public
end
local function toEnumItem(p1, p2, p3) -- line: 42
	if typeof(p2) == "EnumItem" then
		return p2
	end

	if type(p2) ~= "string" then
		return p3
	end

	local v27 = string.match(p2, "([^%.]+)$") or p2
	local ok, result = pcall(function() -- line: 51
		-- upvalues: p1 (copy), v27 (copy)
		return p1[v27]
	end)

	if ok and result ~= nil then
		return result
	end

	return p3
end
local function toColor3(p4) -- line: 60
	-- upvalues: color3 (copy)
	if typeof(p4) == "Color3" then
		return p4
	end

	if type(p4) ~= "table" then
		return color3
	end

	local v31 = p4.R or (p4.r or (p4.Red or (p4.red or p4[1])))
	local v32 = p4.G or (p4.g or (p4.Green or (p4.green or p4[2])))
	local v33 = p4.B or (p4.b or (p4.Blue or (p4.blue or p4[3])))

	if type(v31) ~= "number" or type(v32) ~= "number" or type(v33) ~= "number" then
		return color3
	end

	if v31 > 1 or v32 > 1 or v33 > 1 then
		return Color3.fromRGB(v31, v32, v33)
	end

	return Color3.new(v31, v32, v33)
end
local function toUDim2(p5) -- line: 81
	-- upvalues: uDim2 (copy)
	if typeof(p5) == "UDim2" then
		return p5
	end

	if type(p5) ~= "table" then
		return uDim2
	end

	if type(p5[1]) == "number" and type(p5[2]) == "number" then
		return UDim2.fromScale(p5[1], p5[2])
	end

	local v35 = p5.X or p5.x
	local v36 = p5.Y or p5.y

	if type(v35) == "table" and type(v36) == "table" then
		return UDim2.new(v35.Scale or (v35.scale or 0), v35.Offset or (v35.offset or 0), v36.Scale or (v36.scale or 0), v36.Offset or (v36.offset or 0))
	end

	return UDim2.new(p5.XScale or (p5.xScale or (p5.scaleX or (p5[1] or 0.5))), p5.XOffset or (p5.xOffset or (p5.offsetX or (p5[2] or 0))), p5.YScale or (p5.yScale or (p5.scaleY or (p5[3] or 0.5))), p5.YOffset or (p5.yOffset or (p5.offsetY or (p5[4] or 0))))
end
local function normalizeTextOverlayEdit(p6) -- line: 112
	-- upvalues: toUDim2 (copy), toEnumItem (copy), BuilderSansMedium (copy), toColor3 (copy), Center (copy)
	if type(p6) ~= "table" then
		return nil
	end

	local v38 = p6.textOverlayStyle or {}

	return {
		position = toUDim2(p6.position),
		rotation = type(p6.rotation) ~= "number" and 0 or p6.rotation,
		scale = type(p6.scale) ~= "number" and 1 or p6.scale,
		text = type(p6.text) ~= "string" and "" or p6.text,
		textOverlayStyle = {
			font = toEnumItem(Enum.Font, v38.font, BuilderSansMedium),
			fontColor = toColor3(v38.fontColor),
			fontSize = type(v38.fontSize) ~= "number" and 16 or v38.fontSize,
			textXAlignment = toEnumItem(Enum.TextXAlignment, v38.textXAlignment, Center)
		},
		zIndex = type(p6.zIndex) ~= "number" and 1 or p6.zIndex
	}
end
local function normalizeStickerOverlayEdit(p7) -- line: 135
	-- upvalues: toUDim2 (copy)
	if type(p7) ~= "table" then
		return nil
	end

	if type(p7.stickerURI) ~= "string" or p7.stickerURI == "" then
		return nil
	end

	return {
		position = toUDim2(p7.position),
		rotation = type(p7.rotation) ~= "number" and 0 or p7.rotation,
		scale = type(p7.scale) ~= "number" and 1 or p7.scale,
		stickerSize = type(p7.stickerSize) ~= "number" and 1 or p7.stickerSize,
		stickerURI = type(p7.stickerURI) ~= "string" and "" or p7.stickerURI,
		zIndex = type(p7.zIndex) ~= "number" and 1 or p7.zIndex
	}
end
local function normalizeCaptureEdits(p8) -- line: 154
	-- upvalues: normalizeTextOverlayEdit (copy), FFlagMomentsStickerOverlayNormalization (copy), normalizeStickerOverlayEdit (copy)
	if p8 == nil then
		return nil
	end

	local v41 = nil

	if type(p8.textOverlays) == "table" then
		local t1 = {}

		for _, v44 in p8.textOverlays do
			local v45 = normalizeTextOverlayEdit(v44)

			if v45 ~= nil then
				table.insert(t1, v45)
			end
		end

		if #t1 > 0 then
			v41 = t1
		end
	end

	local v46 = nil

	if FFlagMomentsStickerOverlayNormalization() and type(p8.stickerOverlays) == "table" then
		local t2 = {}

		for _, v49 in p8.stickerOverlays do
			local v50 = normalizeStickerOverlayEdit(v49)

			if v50 ~= nil then
				table.insert(t2, v50)
			end
		end

		if #t2 > 0 then
			v46 = t2
		end
	end

	return {
		trim = p8.trim,
		music = p8.music,
		textOverlays = v41,
		stickerOverlays = v46
	}
end
local function reactionTotal(p9) -- line: 195
	if p9 == nil or p9.counts == nil then
		return nil
	end

	local n1 = 0

	for _, v54 in p9.counts do
		n1 += v54
	end

	return n1
end
local function convertApiMomentToMomentItem(p10) -- line: 208
	-- upvalues: FFlagMomentsRequireApiFeedItemId (copy), normalizeCaptureEdits (copy), MomentStatus (copy)
	local captionedAssetMoment = p10.captionedAssetMoment
	local owner = p10.owner
	local v58 = p10.entityId or p10.id
	local feedItemId = p10.feedItemId

	if captionedAssetMoment == nil or (captionedAssetMoment.assetId == nil or owner == nil or owner.id == nil or v58 == nil) or FFlagMomentsRequireApiFeedItemId and (feedItemId == nil or feedItemId == "") then
		return nil
	end

	local v60 = if p10.primaryCta == nil then nil else p10.primaryCta.experienceCta
	local v61 = if captionedAssetMoment.captureType ~= "Screenshot" then captionedAssetMoment.videoCaptureEdits else captionedAssetMoment.screenshotCaptureEdits
	local v62 = normalizeCaptureEdits(v61)
	local v63 = if (captionedAssetMoment.status or p10.status) ~= MomentStatus.Deleted then MomentStatus.Public else MomentStatus.Deleted
	local t3 = {
		assetId = captionedAssetMoment.assetId,
		creatorId = owner.id,
		isModerated = captionedAssetMoment.isModerated
	}
	local t4 = {
		assetToken = captionedAssetMoment.assetToken,
		assetTotalDuration = captionedAssetMoment.assetTotalDuration,
		assetAccessContext = captionedAssetMoment.assetAccessContext,
		captureType = if captionedAssetMoment.captureType ~= "Screenshot" then Enum.CaptureType.Video else Enum.CaptureType.Screenshot,
		description = captionedAssetMoment.caption,
		edits = v62,
		experienceName = if v60 == nil then nil else v60.experienceName
	}
	local reactions = p10.reactions
	local v67

	if reactions == nil or reactions.counts == nil then
		v67 = nil
	else
		v67 = 0

		for _, v69 in reactions.counts do
			v67 += v69
		end
	end

	t4.likeCount = v67
	t4.partnerUploadType = captionedAssetMoment.partnerUploadType
	t4.placeId = if v60 == nil then nil else v60.placeId
	t4.universeId = if v60 == nil then nil else v60.experienceId
	t3.metadata = t4
	t3.momentId = v58
	t3.recommendationMetadata = {
		feedItemId = feedItemId,
		tracingId = p10.feedSessionId
	}
	t3.status = v63

	return t3
end
local function convertApiMomentsToMomentItems(t5: {[any]: any}?) -- line: 261
	-- upvalues: convertApiMomentToMomentItem (copy)
	local t6 = {}

	if t5 == nil then
		return t6
	end

	for _, v in ipairs(t5) do
		local v74 = convertApiMomentToMomentItem(v)

		if v74 ~= nil then
			table.insert(t6, v74)
		end
	end

	return t6
end

return convertApiMomentsToMomentItems
