local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

require(script.Parent.Parent.Types)

local SlotType = require(script.Parent.Parent.Enums.SlotType)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagEnableSlotsHeadShapeThumbnail = AvatarExperienceFlags.FFlagEnableSlotsHeadShapeThumbnail
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport

local function buildSlotSubcategory(p1, s1: string?, p2) -- line: 23
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy)
	if FFlagAXCustomizeMakeupSupport then
		return {
			nameTranslationKey = p1.nameTranslationKey,
			icon = p1.icon,
			thumbnailUrl = s1,
			assetTypes = p1.assetTypes,
			editorSubcategory = p1.editorSubcategory,
			eligibleSubcategories = p1.eligibleSubcategories,
			currentAssetType = p2,
			hide = p1.hide,
			deselectable = p1.deselectable
		}
	end

	return {
		nameTranslationKey = p1.nameTranslationKey,
		icon = p1.icon,
		thumbnailUrl = s1,
		assetTypes = p1.assetTypes,
		editorSubcategory = p1.editorSubcategory
	}
end
local function buildLayeredSlotSubcategory(p3, s2: string?, p4, n1: number) -- line: 47
	-- upvalues: buildSlotSubcategory (copy), SlotType (copy)
	local v18 = buildSlotSubcategory(p3, s2, p4)

	v18.slotType = SlotType.LayeredSlot
	v18.layerLimit = p3.layerLimit
	v18.layerIndex = n1

	return v18
end
local function getHeadShapeFromEquippedAssets(t1: {[any]: any}) -- line: 62
	local v20 = t1[tostring(Enum.AvatarAssetType.DynamicHead.Value)]

	if v20 then
		for _, v22 in v20 do
			if v22.headShape == "Default" then
				return nil
			end

			return v22.headShape
		end
	end

	return nil
end
local function getClassicFaceOrDynamicHeadThumbnail(t2: {[any]: any}, b1: boolean) -- line: 75
	local v25 = t2[if not b1 then tostring(Enum.AvatarAssetType.Face.Value) else tostring(Enum.AvatarAssetType.DynamicHead.Value)]

	if v25 then
		for v26, _ in v25 do
			return `rbxthumb://type=Asset&id={ v26 }&w=150&h=150`
		end
	end

	return nil
end
local function buildSlots(t3: {[any]: any}, t4: {[any]: any}) -- line: 92
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), SlotType (copy), buildSlotSubcategory (copy), FFlagEnableSlotsHeadShapeThumbnail (copy), getClassicFaceOrDynamicHeadThumbnail (copy)
	local t5 = {}
	local v31 = false
	local v32 = false
	local g57 = nil
	local v56 = nil

	for _, v34 in t3 do
		if FFlagAXCustomizeMakeupSupport and v34.slotType == SlotType.LayeredSlot then
			for i = 0, v34.layerLimit - 1 do
				local v36 = false

				for _, v38 in v34.assetTypes do
					local v39 = t4[tostring(v38.Value)]

					if v39 ~= nil and next(v39) then
						for v40, v41 in v39 do
							if i == v41.order then
								local v42 = `rbxthumb://type=Asset&id={ v40 }&w=150&h=150`
								local v43 = buildSlotSubcategory(v34, v42, v38)

								v43.slotType = SlotType.LayeredSlot
								v43.layerLimit = v34.layerLimit
								v43.layerIndex = i
								table.insert(t5, v43)
								v36 = true

								break
							end
						end
					end
				end

				if not v36 then
					local v44 = buildSlotSubcategory(v34, nil, nil)

					v44.slotType = SlotType.LayeredSlot
					v44.layerLimit = v34.layerLimit
					v44.layerIndex = i
					table.insert(t5, v44)
				end
			end
		else
			local assetTypes = v34.assetTypes
			local v46 = false

			for _, v48 in assetTypes do
				local v49 = t4[tostring(v48.Value)]

				if v49 ~= nil and next(v49) then
					if v48 == Enum.AvatarAssetType.Face then
						v32 = true
					else
						if v48 == Enum.AvatarAssetType.DynamicHead then
							v31 = true
						end

						for v50, _ in v49 do
							local v52 = `rbxthumb://type=Asset&id={ v50 }&w=150&h=150`

							if v31 and FFlagEnableSlotsHeadShapeThumbnail then
								local v53 = t4[tostring(Enum.AvatarAssetType.DynamicHead.Value)]

								if v53 then
									for _, v55 in v53 do
										v56 = if v55.headShape ~= "Default" then v55.headShape else nil
										g57 = true

										if g57 then
											break
										end
									end
								end

								if not g57 then
									v56 = nil
								end

								g57 = false

								if v56 then
									v52 = `rbxthumb://type=Asset&id={ v50 }&headshape={ v56 }&w=150&h=150`
								end
							end

							table.insert(t5, (buildSlotSubcategory(v34, v52, v48)))
							v46 = true
						end
					end
				end
			end

			for _, v59 in assetTypes do
				if v59 == Enum.AvatarAssetType.Face and (v31 or v32) then
					table.insert(t5, (buildSlotSubcategory(v34, getClassicFaceOrDynamicHeadThumbnail(t4, v31), v59)))
					v46 = true
				end
			end

			if not v46 then
				table.insert(t5, (buildSlotSubcategory(v34)))
			end
		end
	end

	return t5
end

return buildSlots
