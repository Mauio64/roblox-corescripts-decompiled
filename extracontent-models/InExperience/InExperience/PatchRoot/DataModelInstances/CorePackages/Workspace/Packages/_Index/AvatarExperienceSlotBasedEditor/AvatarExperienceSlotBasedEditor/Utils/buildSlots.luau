local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

require(script.Parent.Parent.Types)

local SlotType = require(script.Parent.Parent.Enums.SlotType)
local FFlagEnableSlotsHeadShapeThumbnail = require(Parent.AvatarExperienceFlags).FFlagEnableSlotsHeadShapeThumbnail

local function buildSlotSubcategory(p1, s1: string?, p2) -- line: 21
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
local function buildLayeredSlotSubcategory(p3, s2: string?, p4, n1: number) -- line: 35
	-- upvalues: SlotType (copy)
	return {
		nameTranslationKey = p3.nameTranslationKey,
		icon = p3.icon,
		thumbnailUrl = s2,
		assetTypes = p3.assetTypes,
		editorSubcategory = p3.editorSubcategory,
		eligibleSubcategories = p3.eligibleSubcategories,
		currentAssetType = p4,
		hide = p3.hide,
		deselectable = p3.deselectable,
		slotType = SlotType.LayeredSlot,
		layerLimit = p3.layerLimit,
		layerIndex = n1
	}
end
local function getHeadShapeFromEquippedAssets(t1: {[any]: any}) -- line: 50
	local v17 = t1[tostring(Enum.AvatarAssetType.DynamicHead.Value)]

	if v17 then
		for _, v19 in v17 do
			if v19.headShape == "Default" then
				return nil
			end

			return v19.headShape
		end
	end

	return nil
end
local function getClassicFaceOrDynamicHeadThumbnail(t2: {[any]: any}, b1: boolean) -- line: 63
	local v22 = t2[if not b1 then tostring(Enum.AvatarAssetType.Face.Value) else tostring(Enum.AvatarAssetType.DynamicHead.Value)]

	if v22 then
		for v23, _ in v22 do
			return `rbxthumb://type=Asset&id={ v23 }&w=150&h=150`
		end
	end

	return nil
end
local function buildSlots(t3: {[any]: any}, t4: {[any]: any}) -- line: 80
	-- upvalues: SlotType (copy), FFlagEnableSlotsHeadShapeThumbnail (copy), getClassicFaceOrDynamicHeadThumbnail (copy)
	local t5 = {}
	local v28 = false
	local v29 = false
	local g52 = nil
	local v51 = nil

	for _, v31 in t3 do
		if v31.slotType == SlotType.LayeredSlot then
			for i = 0, v31.layerLimit - 1 do
				local v33 = false

				for _, v35 in v31.assetTypes do
					local v36 = t4[tostring(v35.Value)]

					if v36 ~= nil and next(v36) then
						for v37, v38 in v36 do
							if i == v38.order then
								local v39 = `rbxthumb://type=Asset&id={ v37 }&w=150&h=150`

								table.insert(t5, {
									nameTranslationKey = v31.nameTranslationKey,
									icon = v31.icon,
									thumbnailUrl = v39,
									assetTypes = v31.assetTypes,
									editorSubcategory = v31.editorSubcategory,
									eligibleSubcategories = v31.eligibleSubcategories,
									currentAssetType = v35,
									hide = v31.hide,
									deselectable = v31.deselectable,
									slotType = SlotType.LayeredSlot,
									layerLimit = v31.layerLimit,
									layerIndex = i
								})
								v33 = true

								break
							end
						end
					end
				end

				if not v33 then
					table.insert(t5, {
						thumbnailUrl = nil,
						currentAssetType = nil,
						nameTranslationKey = v31.nameTranslationKey,
						icon = v31.icon,
						assetTypes = v31.assetTypes,
						editorSubcategory = v31.editorSubcategory,
						eligibleSubcategories = v31.eligibleSubcategories,
						hide = v31.hide,
						deselectable = v31.deselectable,
						slotType = SlotType.LayeredSlot,
						layerLimit = v31.layerLimit,
						layerIndex = i
					})
				end
			end
		else
			local assetTypes = v31.assetTypes
			local v41 = false

			for _, v43 in assetTypes do
				local v44 = t4[tostring(v43.Value)]

				if v44 ~= nil and next(v44) then
					if v43 == Enum.AvatarAssetType.Face then
						v29 = true
					else
						if v43 == Enum.AvatarAssetType.DynamicHead then
							v28 = true
						end

						for v45, _ in v44 do
							local v47 = `rbxthumb://type=Asset&id={ v45 }&w=150&h=150`

							if v28 and FFlagEnableSlotsHeadShapeThumbnail then
								local v48 = t4[tostring(Enum.AvatarAssetType.DynamicHead.Value)]

								if v48 then
									for _, v50 in v48 do
										v51 = if v50.headShape ~= "Default" then v50.headShape else nil
										g52 = true

										if g52 then
											break
										end
									end
								end

								if not g52 then
									v51 = nil
								end

								g52 = false

								if v51 then
									v47 = `rbxthumb://type=Asset&id={ v45 }&headshape={ v51 }&w=150&h=150`
								end
							end

							table.insert(t5, {
								nameTranslationKey = v31.nameTranslationKey,
								icon = v31.icon,
								thumbnailUrl = v47,
								assetTypes = v31.assetTypes,
								editorSubcategory = v31.editorSubcategory,
								eligibleSubcategories = v31.eligibleSubcategories,
								currentAssetType = v43,
								hide = v31.hide,
								deselectable = v31.deselectable
							})
							v41 = true
						end
					end
				end
			end

			for _, v54 in assetTypes do
				if v54 == Enum.AvatarAssetType.Face and (v28 or v29) then
					local v55 = getClassicFaceOrDynamicHeadThumbnail(t4, v28)

					table.insert(t5, {
						nameTranslationKey = v31.nameTranslationKey,
						icon = v31.icon,
						thumbnailUrl = v55,
						assetTypes = v31.assetTypes,
						editorSubcategory = v31.editorSubcategory,
						eligibleSubcategories = v31.eligibleSubcategories,
						currentAssetType = v54,
						hide = v31.hide,
						deselectable = v31.deselectable
					})
					v41 = true
				end
			end

			if not v41 then
				table.insert(t5, {
					thumbnailUrl = nil,
					currentAssetType = nil,
					nameTranslationKey = v31.nameTranslationKey,
					icon = v31.icon,
					assetTypes = v31.assetTypes,
					editorSubcategory = v31.editorSubcategory,
					eligibleSubcategories = v31.eligibleSubcategories,
					hide = v31.hide,
					deselectable = v31.deselectable
				})
			end
		end
	end

	return t5
end

return buildSlots
