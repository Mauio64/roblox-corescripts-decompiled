local parent = script.Parent.Parent

local Constants = require(parent.Constants)
local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)

local getFFlagUGCValidateVersionedContentIds = require(parent.flags.getFFlagUGCValidateVersionedContentIds)

local ParseContentIds = {}

local function getRbxAssetId(value) -- 2 equivalent calls inferred from this helper
	return (string.match(value, "^rbxassetid://(%d+)$"))
end

local function getAssetUrlId(value)
	local v = string.match(value, "^https?://www%.(.+)") or string.match(value, "^https?://(.+)")

	if not v then
		return nil
	end

	local v2 = string.match(v, "^sitetest%d%.robloxlabs(.+)") or string.match(v, "^roblox(.+)")

	if v2 then
		return (string.match(v2, "^%.com//?asset/%?id=(%d+)$"))
	end

	return nil
end

local function getAssetDeliveryAssetUrlId(value)
	local v = string.match(value, "^https?://assetdelivery%.(.+)")

	if not v then
		return nil
	end

	local v2 = string.match(v, "^sitetest%d%.robloxlabs(.+)") or string.match(v, "^roblox(.+)")

	if v2 then
		return (string.match(v2, "^%.com/v1/asset/%?id=(%d+)$"))
	end

	return nil
end

local function splitVersionPin(value: string)
	local v, v2, v3 = string.match(value, "^(.*)&(%a+)=(%d+)$")

	if v == nil or string.lower(v2) ~= "version" or #v3 > 10 then
		return value, nil
	end

	local v4 = tonumber(v3)

	if v4 == nil or v4 < 1 then
		return value, nil
	end

	return v, v4
end

local function tryParseVersionedContentId(value: string)
	local v, v2, v3 = string.match(value, "^(.*)&(%a+)=(%d+)$")
	local v4

	if not (v == nil or string.lower(v2) ~= "version" or #v3 > 10) then
		v4 = tonumber(v3)

		if v4 == nil or v4 < 1 then
			v4 = nil
		else
			value = v
		end
	end

	local v5 = string.match(value, "^%d+$")

	if v5 ~= nil and v4 ~= nil then
		return nil, nil
	end

	local v6 = v5 or getRbxAssetId(value) or getAssetUrlId(value) or getAssetDeliveryAssetUrlId(value) -- inferred equivalent call

	if v6 == nil then
		return nil, nil
	end

	return string.gsub(v6, "^0+(%d)", "%1"), v4
end

local function tryGetAssetIdFromContentIdInternal(value)
	if getFFlagUGCValidateVersionedContentIds() then
		return (tryParseVersionedContentId(value))
	end

	local v = tonumber(value)

	if v ~= nil then
		return v
	end

	local rbxAssetId = getRbxAssetId(value) -- inferred equivalent call

	if rbxAssetId ~= nil then
		return rbxAssetId
	end

	local assetUrlId = getAssetUrlId(value)

	if assetUrlId ~= nil then
		return assetUrlId
	end

	local assetDeliveryAssetUrlId = getAssetDeliveryAssetUrlId(value)

	if assetDeliveryAssetUrlId == nil then
		return nil
	end

	return assetDeliveryAssetUrlId
end

local function hasInExpCreatedEditableInstance(instance, p, data): boolean -- 1 equivalent call inferred from this helper
	if not (data and data.allowEditableInstances) then
		return false
	end

	local editableImage = data.editableImages[instance]

	if editableImage and editableImage[p] and editableImage[p].instance then
		return true
	end

	local editableMesh = data.editableMeshes[instance]

	if editableMesh and editableMesh[p] and editableMesh[p].instance then
		return true
	end

	return false
end

local function parseContentId(list, p, list2, descendant, fieldName, p2, data)
	local v = descendant[fieldName]

	if v == "" then
		if hasInExpCreatedEditableInstance(descendant, fieldName, data) then -- inferred equivalent call
			if list2 then
				table.insert(list2, { fieldName = fieldName, instance = descendant })
			end
		elseif p2 then
			return false, { string.format("%s.%s cannot be empty", descendant:GetFullName(), fieldName) }
		end

		return true
	else
		local id = tryGetAssetIdFromContentIdInternal(v)

		if id == nil then
			return
				false,
				{ string.format(
						"Could not parse ContentId %s in %s.%s. Please make sure you are using a valid URL with a valid ID.",
						v,
						descendant:GetFullName(),
						fieldName
					) }
		end

		if p[id] == nil then
			p[id] = { fieldName = fieldName, instance = descendant }

			table.insert(list, id)
		end

		if list2 then
			table.insert(list2, { fieldName = fieldName, instance = descendant, id = id })
		end

		return true
	end
end

local function parseWithErrorCheckInternal(p, p2, p3, folder, p4, p5, p6)
	local v = p4 or Constants.CONTENT_ID_FIELDS
	local v2 = FailureReasonsAccumulator.new()

	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)

	for _, descendant in pairs(descendants) do
		local v3 = v[descendant.ClassName]

		if not v3 then
			continue
		end

		local v4 = p5 and p5[descendant.ClassName]

		for _, v5 in ipairs(v3) do
			v2:updateReasons(parseContentId(p, p2, p3, descendant, v5, v4 and v4[v5], p6))
		end
	end

	return v2:getFinalResults()
end

function ParseContentIds.tryGetAssetIdFromContentId(p: string)
	return tryGetAssetIdFromContentIdInternal(p)
end

function ParseContentIds.tryParseContentId(p: string)
	if getFFlagUGCValidateVersionedContentIds() then
		return tryParseVersionedContentId(p)
	end

	return tryGetAssetIdFromContentIdInternal(p), nil
end

function ParseContentIds.getReferenceKey(p: string, p2: number?)
	if p2 == nil then
		return p
	end

	return string.format("%s&version=%d", p, p2)
end

function ParseContentIds.toAssetUri(p: string, p2: number?)
	return "rbxassetid://" .. ParseContentIds.getReferenceKey(p, p2)
end

function ParseContentIds.getDistinctReferences(items)
	local referenceKeySet = {}
	local distinctReferences = {}

	for k, item in items do
		for _, entry in item do
			local referenceKey = ParseContentIds.getReferenceKey(k, entry.version)

			if referenceKeySet[referenceKey] then
				continue
			end

			referenceKeySet[referenceKey] = true
			table.insert(distinctReferences, {
				key = referenceKey,
				uri = ParseContentIds.toAssetUri(k, entry.version),
				assetId = k,
				entry = entry
			})
		end
	end

	return distinctReferences
end

function ParseContentIds.parseWithErrorCheck(p, p2, p3, p4, p5, p6)
	return parseWithErrorCheckInternal(p, p2, nil, p3, p4, p5, p6)
end

function ParseContentIds.parse(p, p2, p3)
	local v = {}
	assert((parseWithErrorCheckInternal({}, {}, v, p, p2, nil, p3)))
	return v
end

return ParseContentIds
