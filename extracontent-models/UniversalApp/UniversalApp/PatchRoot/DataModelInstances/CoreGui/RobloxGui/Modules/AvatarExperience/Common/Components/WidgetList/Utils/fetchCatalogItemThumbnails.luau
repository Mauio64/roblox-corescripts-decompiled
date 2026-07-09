local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ContentProvider = game:GetService("ContentProvider")

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local Promise = require(CorePackages.Packages.Promise)
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local Constants2 = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local t1 = {
	[ItemTypeEnum.Asset] = true,
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

local function getThumbnailTypeForItem(p1) -- line: 42
	-- upvalues: t1 (copy), Constants2 (copy), ItemTypeEnum (copy)
	if t1[p1] then
		return Constants2.RbxthumbTypes.Asset
	end

	if p1 == ItemTypeEnum.Bundle then
		return Constants2.RbxthumbTypes.BundleThumbnail
	end

	if p1 == ItemTypeEnum.Look then
		return Constants2.RbxthumbTypes.Look
	end

	return Constants2.RbxthumbTypes.Asset
end
local function getThumbnailSize(p2, p3) -- line: 67
	-- upvalues: ItemTypeEnum (copy), Constants (copy)
	if p3 then
		return p3
	end

	if p2 == ItemTypeEnum.Look then
		return Constants.CatalogThumbnailTypeToSize.Look._300x450
	end

	return Constants.CatalogThumbnailTypeToSize.Asset._150x150
end
local function fetchCatalogItemThumbnails(t2: {[any]: any}, p4) -- line: 93
	-- upvalues: Promise (copy), t1 (copy), Constants2 (copy), ItemTypeEnum (copy), Constants (copy), ContentProvider (copy)
	if not t2 or #t2 == 0 then
		return Promise.resolve()
	end

	local t3 = {}
	local v18 = false

	for _, v20 in t2 do
		local type = v20.type
		local v22 = if not t1[type] then if type ~= ItemTypeEnum.Bundle then if type ~= ItemTypeEnum.Look then Constants2.RbxthumbTypes.Asset else Constants2.RbxthumbTypes.Look else Constants2.RbxthumbTypes.BundleThumbnail else Constants2.RbxthumbTypes.Asset
		local v23 = v20.thumbnailSize or p4
		local type2 = v20.type
		local v25 = if not v23 then if type2 ~= ItemTypeEnum.Look then Constants.CatalogThumbnailTypeToSize.Asset._150x150 else Constants.CatalogThumbnailTypeToSize.Look._300x450 else v23

		table.insert(t3, `rbxthumb://type={ v22 }&id={ v20.id }&{ v25 }`)

		if v20.type == ItemTypeEnum.Look and not v18 then
			v18 = true
		end
	end

	return Promise.new(function(resolve, reject) -- line: 125
		-- upvalues: ContentProvider (copy), t3 (copy)
		task.spawn(function() -- line: 126
			-- upvalues: ContentProvider (copy), t3 (copy), resolve (copy), reject (copy)
			local ok, result = pcall(function() -- line: 127
				-- upvalues: ContentProvider (copy), t3 (copy)
				ContentProvider:PreloadAsync(t3)
			end)

			if ok then
				resolve()

				return
			end

			reject("Failed to preload thumbnails: " .. tostring(result))
		end)
	end)
end

return fetchCatalogItemThumbnails
