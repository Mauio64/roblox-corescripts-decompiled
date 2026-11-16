local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Cryo")

local promiseUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/AppCommonLib").Utils.PromiseUtilities
require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Promise")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/Constants")
local getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils").getRbxthumbWithTypeSizeAndOptions

local function subdivideEntries(list, p2)
	local result = {}

	for i = 1, #list, p2 do
		table.insert(result, (Cryo.List.getRange(list, i, i + p2 - 1)))
	end

	return result
end

local function makePreloadAsyncPromise(items, items2, p2)
	return (Promise.new(function(callback, p3)
		local v5 = {}
		local rbxthumbWithTypeSizeAndOptions = {}

		for k, item in items do
			v5[item] = {}

			for k2, item2 in items2 do
				v5[item][item2.thumbnailType] = v5[item][item2.thumbnailType] or {}
				local v6 = Constants.RbxThumbnailSizeToNumberSize[item2.thumbnailSize]

				local rbxthumbWithTypeSizeAndOptions2 = getRbxthumbWithTypeSizeAndOptions(
					item,
					Constants.RbxAvatarThumbnailTypeFromEnumToRbxthumbType[item2.thumbnailType],
					v6
				)
				v5[item][item2.thumbnailType][item2.thumbnailSize] = rbxthumbWithTypeSizeAndOptions2
				table.insert(rbxthumbWithTypeSizeAndOptions, rbxthumbWithTypeSizeAndOptions2)
			end
		end

		(p2 or game:GetService("ContentProvider")):PreloadAsync(rbxthumbWithTypeSizeAndOptions)

		callback()
	end))
end

return function(p2, p3, p4)
	return function(p5)
		local v5 = subdivideEntries(p2, 100)
		local v6 = {}

		for k, v7 in pairs(v5) do
			local v8 = p3
			local v9 = p4
			table.insert(v6, (Promise.new(function(callback, p6)
				local v10 = {}
				local rbxthumbWithTypeSizeAndOptions = {}

				for k2, v11 in v7 do
					v10[v11] = {}

					for k3, v12 in v8 do
						v10[v11][v12.thumbnailType] = v10[v11][v12.thumbnailType] or {}
						local v13 = Constants.RbxThumbnailSizeToNumberSize[v12.thumbnailSize]

						local rbxthumbWithTypeSizeAndOptions2 = getRbxthumbWithTypeSizeAndOptions(
							v11,
							Constants.RbxAvatarThumbnailTypeFromEnumToRbxthumbType[v12.thumbnailType],
							v13
						)
						v10[v11][v12.thumbnailType][v12.thumbnailSize] = rbxthumbWithTypeSizeAndOptions2
						table.insert(rbxthumbWithTypeSizeAndOptions, rbxthumbWithTypeSizeAndOptions2)
					end
				end

				(v9 or game:GetService("ContentProvider")):PreloadAsync(rbxthumbWithTypeSizeAndOptions)

				callback()
			end)))
		end

		return promiseUtilities.Batch(v6)
	end
end
