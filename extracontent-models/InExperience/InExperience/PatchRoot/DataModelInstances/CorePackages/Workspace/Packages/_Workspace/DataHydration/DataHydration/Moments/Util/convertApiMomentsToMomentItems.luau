local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local MomentsTypes = require(DataHydrationParent.MomentsTypes)

require(DataHydration.Moments.MomentsStoreTypes)

local MomentStatus = MomentsTypes.Enums.MomentStatus
local uDim2 = UDim2.fromScale(0.5, 0.5)
local BuilderSansMedium = Enum.Font.BuilderSansMedium
local color3 = Color3.new(0, 0, 0)
local Center = Enum.TextXAlignment.Center

local function toCaptureType(s1: string?) -- line: 20
	if s1 == "Screenshot" then
		return Enum.CaptureType.Screenshot
	end

	return Enum.CaptureType.Video
end
local function toMomentStatus(s2: string?) -- line: 28
	-- upvalues: MomentStatus (copy)
	if s2 == MomentStatus.Deleted then
		return MomentStatus.Deleted
	end

	return MomentStatus.Public
end
local function toEnumItem(p1, p2, p3) -- line: 36
	if typeof(p2) == "EnumItem" then
		return p2
	end

	if type(p2) ~= "string" then
		return p3
	end

	local v24 = string.match(p2, "([^%.]+)$") or p2
	local ok, result = pcall(function() -- line: 45
		-- upvalues: p1 (copy), v24 (copy)
		return p1[v24]
	end)

	if ok and result ~= nil then
		return result
	end

	return p3
end
local function toColor3(p4) -- line: 54
	-- upvalues: color3 (copy)
	if typeof(p4) == "Color3" then
		return p4
	end

	if type(p4) ~= "table" then
		return color3
	end

	local v28 = p4.R or (p4.r or (p4.Red or (p4.red or p4[1])))
	local v29 = p4.G or (p4.g or (p4.Green or (p4.green or p4[2])))
	local v30 = p4.B or (p4.b or (p4.Blue or (p4.blue or p4[3])))

	if type(v28) ~= "number" or type(v29) ~= "number" or type(v30) ~= "number" then
		return color3
	end

	if v28 > 1 or v29 > 1 or v30 > 1 then
		return Color3.fromRGB(v28, v29, v30)
	end

	return Color3.new(v28, v29, v30)
end
local function toUDim2(p5) -- line: 75
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

	local v32 = p5.X or p5.x
	local v33 = p5.Y or p5.y

	if type(v32) == "table" and type(v33) == "table" then
		return UDim2.new(v32.Scale or (v32.scale or 0), v32.Offset or (v32.offset or 0), v33.Scale or (v33.scale or 0), v33.Offset or (v33.offset or 0))
	end

	return UDim2.new(p5.XScale or (p5.xScale or (p5.scaleX or (p5[1] or 0.5))), p5.XOffset or (p5.xOffset or (p5.offsetX or (p5[2] or 0))), p5.YScale or (p5.yScale or (p5.scaleY or (p5[3] or 0.5))), p5.YOffset or (p5.yOffset or (p5.offsetY or (p5[4] or 0))))
end
local function normalizeTextOverlayEdit(p6) -- line: 106
	-- upvalues: toUDim2 (copy), toEnumItem (copy), BuilderSansMedium (copy), toColor3 (copy), Center (copy)
	if type(p6) ~= "table" then
		return nil
	end

	local v35 = p6.textOverlayStyle or {}

	return {
		position = toUDim2(p6.position),
		rotation = type(p6.rotation) ~= "number" and 0 or p6.rotation,
		scale = type(p6.scale) ~= "number" and 1 or p6.scale,
		text = type(p6.text) ~= "string" and "" or p6.text,
		textOverlayStyle = {
			font = toEnumItem(Enum.Font, v35.font, BuilderSansMedium),
			fontColor = toColor3(v35.fontColor),
			fontSize = type(v35.fontSize) ~= "number" and 16 or v35.fontSize,
			textXAlignment = toEnumItem(Enum.TextXAlignment, v35.textXAlignment, Center)
		},
		zIndex = type(p6.zIndex) ~= "number" and 1 or p6.zIndex
	}
end
local function normalizeCaptureEdits(p7) -- line: 129
	-- upvalues: normalizeTextOverlayEdit (copy)
	if p7 == nil then
		return nil
	end

	local v37 = nil

	if type(p7.textOverlays) == "table" then
		local t1 = {}

		for _, v40 in p7.textOverlays do
			local v41 = normalizeTextOverlayEdit(v40)

			if v41 ~= nil then
				table.insert(t1, v41)
			end
		end

		if #t1 > 0 then
			v37 = t1
		end
	end

	return {
		trim = p7.trim,
		music = p7.music,
		textOverlays = v37
	}
end
local function reactionTotal(p8) -- line: 155
	if p8 == nil or p8.counts == nil then
		return nil
	end

	local n1 = 0

	for _, v45 in p8.counts do
		n1 += v45
	end

	return n1
end
local function convertApiMomentToMomentItem(p9) -- line: 168
	-- upvalues: normalizeCaptureEdits (copy), MomentStatus (copy)
	local captionedAssetMoment = p9.captionedAssetMoment
	local owner = p9.owner
	local v49 = p9.entityId or p9.id

	if captionedAssetMoment == nil or (captionedAssetMoment.assetId == nil or owner == nil or owner.id == nil or v49 == nil) then
		return nil
	end

	local v50 = if p9.primaryCta == nil then nil else p9.primaryCta.experienceCta
	local v51 = if captionedAssetMoment.captureType ~= "Screenshot" then captionedAssetMoment.videoCaptureEdits else captionedAssetMoment.screenshotCaptureEdits
	local v52 = normalizeCaptureEdits(v51)
	local v53 = if (captionedAssetMoment.status or p9.status) ~= MomentStatus.Deleted then MomentStatus.Public else MomentStatus.Deleted
	local t2 = {
		assetId = captionedAssetMoment.assetId,
		creatorId = owner.id,
		isModerated = captionedAssetMoment.isModerated
	}
	local t3 = {
		assetToken = captionedAssetMoment.assetToken,
		assetTotalDuration = captionedAssetMoment.assetTotalDuration,
		assetAccessContext = captionedAssetMoment.assetAccessContext,
		captureType = if captionedAssetMoment.captureType ~= "Screenshot" then Enum.CaptureType.Video else Enum.CaptureType.Screenshot,
		description = captionedAssetMoment.caption,
		edits = v52,
		experienceName = if v50 == nil then nil else v50.experienceName
	}
	local reactions = p9.reactions
	local v57

	if reactions == nil or reactions.counts == nil then
		v57 = nil
	else
		v57 = 0

		for _, v59 in reactions.counts do
			v57 += v59
		end
	end

	t3.likeCount = v57
	t3.partnerUploadType = captionedAssetMoment.partnerUploadType
	t3.placeId = if v50 == nil then nil else v50.placeId
	t3.universeId = if v50 == nil then nil else v50.experienceId
	t2.metadata = t3
	t2.momentId = v49
	t2.recommendationMetadata = {
		itemId = p9.feedItemId or v49,
		feedItemId = p9.feedItemId,
		tracingId = p9.feedSessionId
	}
	t2.status = v53

	return t2
end
local function convertApiMomentsToMomentItems(t4: {[any]: any}?) -- line: 218
	-- upvalues: convertApiMomentToMomentItem (copy)
	local t5 = {}

	if t4 == nil then
		return t5
	end

	for _, v in ipairs(t4) do
		local v64 = convertApiMomentToMomentItem(v)

		if v64 ~= nil then
			table.insert(t5, v64)
		end
	end

	return t5
end

return convertApiMomentsToMomentItems
