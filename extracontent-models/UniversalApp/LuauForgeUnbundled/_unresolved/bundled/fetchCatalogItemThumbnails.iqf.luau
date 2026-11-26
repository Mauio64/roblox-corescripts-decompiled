local CorePackages = game:GetService("CorePackages")

local ContentProvider = game:GetService("ContentProvider")

require("@luauforge/bundled/dPs")
local module = require("@luauforge/bundled/dPN")
local Promise = require(CorePackages.Packages.Promise)
local itemTypeEnum = require("@luauforge/bundled/dPt").Enums.ItemTypeEnum
local constants = require("@luauforge/bundled/ciE").Utils.Constants

local v5 = {
	[itemTypeEnum.Asset] = true,
	Hat = true,
	Face = true,
	FaceAccessory = true,
	PantsAccessory = true,
	EmoteAnimation = true,
	Gear = true,
	HairAccessory = true,
	BackAccessory = true,
	ShoulderAccessory = true,
	DressSkirtAccessory = true,
	FrontAccessory = true
}

local function getThumbnailTypeForItem(p2)
	if v5[p2] then
		return constants.RbxthumbTypes.Asset
	end

	if p2 == itemTypeEnum.Bundle then
		return constants.RbxthumbTypes.BundleThumbnail
	end

	if p2 == itemTypeEnum.Look then
		return constants.RbxthumbTypes.Look
	end

	return constants.RbxthumbTypes.Asset
end

local function getThumbnailSize(p2, p3)
	if p3 then
		return p3
	end

	if p2 == itemTypeEnum.Look then
		return module.CatalogThumbnailTypeToSize.Look._300x450
	end

	return module.CatalogThumbnailTypeToSize.Asset._150x150
end

local function fetchCatalogItemThumbnails(list, p2)
	if not list or #list == 0 then
		return Promise.resolve()
	end

	local v6 = {}
	local v7 = false

	for k, item in list do
		local kind = item.type
		local v8

		if v5[kind] then
			v8 = constants.RbxthumbTypes.Asset
		elseif kind == itemTypeEnum.Bundle then
			v8 = constants.RbxthumbTypes.BundleThumbnail
		elseif kind == itemTypeEnum.Look then
			v8 = constants.RbxthumbTypes.Look
		else
			v8 = constants.RbxthumbTypes.Asset
		end

		local v9 = item.thumbnailSize or p2
		local kind2 = item.type

		if not v9 then
			if kind2 == itemTypeEnum.Look then
				v9 = module.CatalogThumbnailTypeToSize.Look._300x450
			else
				v9 = module.CatalogThumbnailTypeToSize.Asset._150x150
			end
		end

		table.insert(v6, `rbxthumb://type={v8}&id={item.id}&{v9}`)

		if item.type ~= itemTypeEnum.Look or v7 then
			continue
		end

		v7 = true
	end

	return Promise.new(function(callback, callback2)
		task.spawn(function()
			local success, result = pcall(function()
				ContentProvider:PreloadAsync(v6)
			end)

			if success then
				callback()
			else
				callback2("Failed to preload thumbnails: " .. tostring(result))
			end
		end)
	end)
end

return fetchCatalogItemThumbnails
