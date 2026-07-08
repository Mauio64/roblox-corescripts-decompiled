local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local t1 = {}

local function getRbxAssetId(p1) -- line: 16
	return (string.match(p1, "^rbxassetid://(%d+)$"))
end
local function getAssetUrlId(p2) -- line: 22
	local v14 = string.match(p2, "^https?://www%.(.+)") or string.match(p2, "^https?://(.+)")

	if not v14 then
		return nil
	end

	local v15 = string.match(v14, "^sitetest%d%.robloxlabs(.+)") or string.match(v14, "^roblox(.+)")

	if not v15 then
		return nil
	end

	return (string.match(v15, "^%.com//?asset/%?id=(%d+)$"))
end
local function getAssetDeliveryAssetUrlId(p3) -- line: 37
	local match = string.match(p3, "^https?://assetdelivery%.(.+)")

	if not match then
		return nil
	end

	local v18 = string.match(match, "^sitetest%d%.robloxlabs(.+)") or string.match(match, "^roblox(.+)")

	if not v18 then
		return nil
	end

	return (string.match(v18, "^%.com/v1/asset/%?id=(%d+)$"))
end
local function tryGetAssetIdFromContentIdInternal(p4) -- line: 51
	-- upvalues: getAssetUrlId (copy), getAssetDeliveryAssetUrlId (copy)
	local num = tonumber(p4)

	if num ~= nil then
		return num
	end

	local match = string.match(p4, "^rbxassetid://(%d+)$")

	if match ~= nil then
		return match
	end

	local v22 = getAssetUrlId(p4)

	if v22 ~= nil then
		return v22
	end

	local v23 = getAssetDeliveryAssetUrlId(p4)

	if v23 ~= nil then
		return v23
	end

	return nil
end
local function hasInExpCreatedEditableInstance(p5, p6, p7) -- line: 75
	if not p7 then
		return false
	end

	if not p7.allowEditableInstances then
		return false
	end

	local v27 = p7.editableImages[p5]

	if v27 and v27[p6] and v27[p6].instance then
		return true
	end

	local v28 = p7.editableMeshes[p5]

	if v28 and v28[p6] and v28[p6].instance then
		return true
	end

	return false
end
local function parseContentId(p8, p9, p10, p11, p12, p13, p14) -- line: 105
	-- upvalues: getAssetUrlId (copy), getAssetDeliveryAssetUrlId (copy)
	local v36 = p11[p12]

	if v36 == "" then
		local v37

		if not p14 then
			v37 = false
		elseif not p14.allowEditableInstances then
			v37 = false
		else
			local v38 = p14.editableImages[p11]

			if v38 and v38[p12] and v38[p12].instance then
				v37 = true
			else
				local v39 = p14.editableMeshes[p11]

				v37 = not not v39 and (not not v39[p12] and not not v39[p12].instance)
			end
		end

		if v37 then
			if p10 then
				table.insert(p10, {
					fieldName = p12,
					instance = p11
				})
			end
		elseif p13 then
			return false, { string.format("%s.%s cannot be empty", p11:GetFullName(), p12) }
		end

		return true
	end

	local num = tonumber(v36)

	if num ~= nil then
	else
		num = string.match(v36, "^rbxassetid://(%d+)$")

		if num ~= nil then
		else
			num = getAssetUrlId(v36)

			if num ~= nil then
			else
				local v41 = getAssetDeliveryAssetUrlId(v36)

				num = if v41 == nil then nil else v41
			end
		end
	end

	if num == nil then
		return false, { string.format("Could not parse ContentId %s in %s.%s. Please make sure you are using a valid URL with a valid ID.", v36, p11:GetFullName(), p12) }
	end

	if p9[num] == nil then
		p9[num] = {
			fieldName = p12,
			instance = p11
		}
		table.insert(p8, num)
	end

	if p10 then
		table.insert(p10, {
			fieldName = p12,
			instance = p11,
			id = num
		})
	end

	return true
end
local function parseWithErrorCheckInternal(p15, p16, p17, p18, p19, p20, p21) -- line: 150
	-- upvalues: Constants (copy), FailureReasonsAccumulator (copy), parseContentId (copy)
	local v49 = p19 or Constants.CONTENT_ID_FIELDS
	local v50 = FailureReasonsAccumulator.new()
	local descendants = p18:GetDescendants()

	table.insert(descendants, p18)

	for _, v in pairs(descendants) do
		local v54 = v49[v.ClassName]

		if v54 then
			local v55 = p20 and p20[v.ClassName]

			for _, v2 in ipairs(v54) do
				local v58 = v55 and v55[v2]

				v50:updateReasons(parseContentId(p15, p16, p17, v, v2, v58, p21))
			end
		end
	end

	return v50:getFinalResults()
end

function t1.tryGetAssetIdFromContentId(s1: string) -- line: 189
	-- upvalues: getAssetUrlId (copy), getAssetDeliveryAssetUrlId (copy)
	local num = tonumber(s1)

	if num ~= nil then
		return num
	end

	local match = string.match(s1, "^rbxassetid://(%d+)$")

	if match ~= nil then
		return match
	end

	local v62 = getAssetUrlId(s1)

	if v62 ~= nil then
		return v62
	end

	local v63 = getAssetDeliveryAssetUrlId(s1)

	if v63 ~= nil then
		return v63
	end

	return nil
end
function t1.parseWithErrorCheck(p22, p23, p24, p25, p26, p27) -- line: 193
	-- upvalues: parseWithErrorCheckInternal (copy)
	return parseWithErrorCheckInternal(p22, p23, nil, p24, p25, p26, p27)
end
function t1.parse(p28, p29, p30) -- line: 212
	-- upvalues: parseWithErrorCheckInternal (copy)
	local t2 = {}

	assert((parseWithErrorCheckInternal({}, {}, t2, p28, p29, nil, p30)))

	return t2
end

return t1
