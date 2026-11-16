require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")
local SlotType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/SlotType")
local fFlagEnableSlotsHeadShapeThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagEnableSlotsHeadShapeThumbnail

local function buildSlotSubcategory(data, p2, p3)
	return {
		nameTranslationKey = data.nameTranslationKey,
		icon = data.icon,
		thumbnailUrl = p2,
		assetTypes = data.assetTypes,
		editorSubcategory = data.editorSubcategory,
		eligibleSubcategories = data.eligibleSubcategories,
		currentAssetType = p3,
		hide = data.hide,
		deselectable = data.deselectable
	}
end

local function buildLayeredSlotSubcategory(data, p2, p3, layerIndex)
	local layeredSlotSubcategory = {
		nameTranslationKey = data.nameTranslationKey,
		icon = data.icon,
		thumbnailUrl = p2,
		assetTypes = data.assetTypes,
		editorSubcategory = data.editorSubcategory,
		eligibleSubcategories = data.eligibleSubcategories,
		currentAssetType = p3,
		hide = data.hide,
		deselectable = data.deselectable
	}

	layeredSlotSubcategory.slotType = SlotType.LayeredSlot
	layeredSlotSubcategory.layerLimit = data.layerLimit
	layeredSlotSubcategory.layerIndex = layerIndex

	return layeredSlotSubcategory
end

local function getHeadShapeFromEquippedAssets(p2)
	local v5 = p2[tostring(Enum.AvatarAssetType.DynamicHead.Value)]

	if not v5 then
		return nil
	end

	for k, v6 in v5 do
		if v6.headShape == "Default" then
			return nil
		end

		return v6.headShape
	end

	return nil
end

local function getClassicFaceOrDynamicHeadThumbnail(p2, p3)
	local v5 = if p3 then tostring(Enum.AvatarAssetType.DynamicHead.Value) else tostring(Enum.AvatarAssetType.Face.Value)

	local v6 = p2[v5]

	if v6 then
		for k, v7 in v6 do
			return `rbxthumb://type=Asset&id={k}&w=150&h=150`
		end
	end

	return nil
end

local function buildSlots(items, p2)
	local slots = {}
	local v5 = false
	local v6 = false

	for k, item in items do
		if item.slotType == SlotType.LayeredSlot then
			for i = 0, item.layerLimit - 1 do
				local v7 = false

				for k2, assetType in item.assetTypes do
					local v8 = p2[tostring(assetType.Value)]
					local v9 = not (v8 == nil) and next(v8)

					if not v9 then
						continue
					end

					for k3, v11 in v8 do
						if v11.order == i then
							local formatted = `rbxthumb://type=Asset&id={k3}&w=150&h=150`
							local v12 = {
								nameTranslationKey = item.nameTranslationKey,
								icon = item.icon,
								thumbnailUrl = formatted,
								assetTypes = item.assetTypes,
								editorSubcategory = item.editorSubcategory,
								eligibleSubcategories = item.eligibleSubcategories,
								currentAssetType = assetType,
								hide = item.hide,
								deselectable = item.deselectable
							}

							v12.slotType = SlotType.LayeredSlot
							v12.layerLimit = item.layerLimit
							v12.layerIndex = i

							table.insert(slots, v12)
							v7 = true
							break
						end
					end
				end

				if v7 then
					continue
				end

				local v8 = {
					nameTranslationKey = item.nameTranslationKey,
					icon = item.icon,
					thumbnailUrl = nil,
					assetTypes = item.assetTypes,
					editorSubcategory = item.editorSubcategory,
					eligibleSubcategories = item.eligibleSubcategories,
					currentAssetType = nil,
					hide = item.hide,
					deselectable = item.deselectable
				}

				v8.slotType = SlotType.LayeredSlot
				v8.layerLimit = item.layerLimit
				v8.layerIndex = i

				table.insert(slots, v8)
			end
		else
			local assetTypes = item.assetTypes
			local v7 = false

			for k2, assetType in assetTypes do
				local v8 = p2[tostring(assetType.Value)]
				local v9 = not (v8 == nil) and next(v8)

				if not v9 then
					continue
				end

				if assetType == Enum.AvatarAssetType.Face then
					v6 = true
				else
					v5 = assetType == Enum.AvatarAssetType.DynamicHead or v5

					for k3, v10 in v8 do
						local v11 = `rbxthumb://type=Asset&id={k3}&w=150&h=150`

						if v5 and fFlagEnableSlotsHeadShapeThumbnail then
							local v12 = p2[tostring(Enum.AvatarAssetType.DynamicHead.Value)]
							local headShape

							if v12 then
								local flag = true

								for k4, v13 in v12 do
									headShape = if v13.headShape ~= "Default" then v13.headShape else nil
									flag = false
									break
								end

								if flag then
									headShape = nil
								end
							end

							if headShape then
								v11 = `rbxthumb://type=Asset&id={k3}&headshape={headShape}&w=150&h=150`
							end
						end

						table.insert(slots, {
							nameTranslationKey = item.nameTranslationKey,
							icon = item.icon,
							thumbnailUrl = v11,
							assetTypes = item.assetTypes,
							editorSubcategory = item.editorSubcategory,
							eligibleSubcategories = item.eligibleSubcategories,
							currentAssetType = assetType,
							hide = item.hide,
							deselectable = item.deselectable
						})
						v7 = true
					end
				end
			end

			for k2, assetType in assetTypes do
				if not (assetType == Enum.AvatarAssetType.Face and (v5 or v6)) then
					continue
				end

				local classicFaceOrDynamicHeadThumbnail = getClassicFaceOrDynamicHeadThumbnail(p2, v5)
				table.insert(slots, {
					nameTranslationKey = item.nameTranslationKey,
					icon = item.icon,
					thumbnailUrl = classicFaceOrDynamicHeadThumbnail,
					assetTypes = item.assetTypes,
					editorSubcategory = item.editorSubcategory,
					eligibleSubcategories = item.eligibleSubcategories,
					currentAssetType = assetType,
					hide = item.hide,
					deselectable = item.deselectable
				})
				v7 = true
			end

			if not v7 then
				table.insert(slots, {
					nameTranslationKey = item.nameTranslationKey,
					icon = item.icon,
					thumbnailUrl = nil,
					assetTypes = item.assetTypes,
					editorSubcategory = item.editorSubcategory,
					eligibleSubcategories = item.eligibleSubcategories,
					currentAssetType = nil,
					hide = item.hide,
					deselectable = item.deselectable
				})
			end
		end
	end

	return slots
end

return buildSlots
