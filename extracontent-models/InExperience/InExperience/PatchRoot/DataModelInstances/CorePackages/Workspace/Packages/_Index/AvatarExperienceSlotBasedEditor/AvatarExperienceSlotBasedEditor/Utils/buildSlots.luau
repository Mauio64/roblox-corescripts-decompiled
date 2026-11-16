local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
require(script.Parent.Parent.Types)
local SlotType = require(script.Parent.Parent.Enums.SlotType)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagEnableSlotsHeadShapeThumbnail = AvatarExperienceFlags.FFlagEnableSlotsHeadShapeThumbnail

local function buildSlotSubcategory(data, thumbnailUrl: string?, currentAssetType) -- 4 equivalent calls inferred from this helper
	return {
		nameTranslationKey = data.nameTranslationKey,
		icon = data.icon,
		thumbnailUrl = thumbnailUrl,
		assetTypes = data.assetTypes,
		editorSubcategory = data.editorSubcategory,
		eligibleSubcategories = data.eligibleSubcategories,
		currentAssetType = currentAssetType,
		hide = data.hide,
		deselectable = data.deselectable
	}
end

local function buildLayeredSlotSubcategory(item, thumbnailUrl: string?, assetType, layerIndex: number) -- 2 equivalent calls inferred from this helper
	local slotSubcategory = buildSlotSubcategory(item, thumbnailUrl, assetType) -- inferred equivalent call
	slotSubcategory.slotType = SlotType.LayeredSlot
	slotSubcategory.layerLimit = item.layerLimit
	slotSubcategory.layerIndex = layerIndex

	return slotSubcategory
end

local function getHeadShapeFromEquippedAssets(p)
	local v = p[tostring(Enum.AvatarAssetType.DynamicHead.Value)]

	if not v then
		return nil
	end

	for _, v2 in v do
		return if v2.headShape ~= "Default" then v2.headShape else nil
	end

	return nil
end

local function getClassicFaceOrDynamicHeadThumbnail(p, flag: boolean)
	local v

	if flag then
		v = tostring(Enum.AvatarAssetType.DynamicHead.Value)
	else
		v = tostring(Enum.AvatarAssetType.Face.Value)
	end

	local v2 = p[v]

	if v2 then
		for k, _ in v2 do
			return `rbxthumb://type=Asset&id={k}&w=150&h=150`
		end
	end

	return nil
end

local function buildSlots(items, p)
	local slots = {}
	local v = false
	local v2 = false

	for _, item in items do
		if item.slotType == SlotType.LayeredSlot then
			for i = 0, item.layerLimit - 1 do
				local v3 = false

				for _, assetType in item.assetTypes do
					local v4 = p[tostring(assetType.Value)]
					local v5

					if v4 == nil then
						v5 = false
					else
						v5 = next(v4)
					end

					if not v5 then
						continue
					end

					for k, v6 in v4 do
						if v6.order == i then
							table.insert(
								slots,
								buildLayeredSlotSubcategory( -- inferred equivalent call
									item,
									`rbxthumb://type=Asset&id={k}&w=150&h=150`,
									assetType,
									i
								)
							)
							v3 = true
							break
						end
					end
				end

				if not v3 then
					table.insert(slots, buildLayeredSlotSubcategory(item, nil, nil, i)) -- inferred equivalent call
				end
			end
		else
			local assetTypes = item.assetTypes
			local v3 = false

			for _, assetType in assetTypes do
				local v4 = p[tostring(assetType.Value)]
				local v5

				if v4 == nil then
					v5 = false
				else
					v5 = next(v4)
				end

				if not v5 then
					continue
				end

				if assetType == Enum.AvatarAssetType.Face then
					v2 = true
				else
					v = assetType == Enum.AvatarAssetType.DynamicHead or v

					for k, _ in v4 do
						local v6 = `rbxthumb://type=Asset&id={k}&w=150&h=150`

						if v and FFlagEnableSlotsHeadShapeThumbnail then
							local v7 = p[tostring(Enum.AvatarAssetType.DynamicHead.Value)]
							local headShape

							if v7 then
								local flag = true

								for _, v8 in v7 do
									if v8.headShape == "Default" then
										headShape = nil
									else
										headShape = v8.headShape
									end

									flag = false
									break
								end

								if flag then
									headShape = nil
								end
							end

							if headShape then
								v6 = `rbxthumb://type=Asset&id={k}&headshape={headShape}&w=150&h=150`
							end
						end

						table.insert(slots, buildSlotSubcategory(item, v6, assetType)) -- inferred equivalent call
						v3 = true
					end
				end
			end

			for _, assetType in assetTypes do
				if not (assetType == Enum.AvatarAssetType.Face and (v or v2)) then
					continue
				end

				table.insert(slots, buildSlotSubcategory(item, getClassicFaceOrDynamicHeadThumbnail(p, v), assetType)) -- inferred equivalent call
				v3 = true
			end

			if not v3 then
				table.insert(slots, buildSlotSubcategory(item)) -- inferred equivalent call
			end
		end
	end

	return slots
end

return buildSlots
