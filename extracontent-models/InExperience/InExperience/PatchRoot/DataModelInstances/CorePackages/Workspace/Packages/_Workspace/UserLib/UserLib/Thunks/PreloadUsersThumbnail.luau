local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local Cryo = require(parent.Cryo)

local AppCommonLib = require(parent.AppCommonLib)
local PromiseUtilities = AppCommonLib.Utils.PromiseUtilities
require(UserLib.Utils)

local Promise = require(parent.Promise)

local Constants = require(UserLib.Utils.Constants)
local Utils = require(UserLib.Utils)
local getRbxthumbWithTypeSizeAndOptions = Utils.getRbxthumbWithTypeSizeAndOptions

local function subdivideEntries(list, p)
	local result = {}

	for i = 1, #list, p do
		table.insert(result, (Cryo.List.getRange(list, i, i + p - 1)))
	end

	return result
end

local function makePreloadAsyncPromise(items, items2, p) -- 1 equivalent call inferred from this helper
	return (Promise.new(function(callback, _)
		local v = {}
		local rbxthumbWithTypeSizeAndOptions = {}

		for _, item in items do
			v[item] = {}

			for _, item2 in items2 do
				v[item][item2.thumbnailType] = v[item][item2.thumbnailType] or {}
				local v2 = Constants.RbxThumbnailSizeToNumberSize[item2.thumbnailSize]

				local rbxthumbWithTypeSizeAndOptions2 = getRbxthumbWithTypeSizeAndOptions(
					item,
					Constants.RbxAvatarThumbnailTypeFromEnumToRbxthumbType[item2.thumbnailType],
					v2
				)
				v[item][item2.thumbnailType][item2.thumbnailSize] = rbxthumbWithTypeSizeAndOptions2
				table.insert(rbxthumbWithTypeSizeAndOptions, rbxthumbWithTypeSizeAndOptions2)
			end
		end

		(p or game:GetService("ContentProvider")):PreloadAsync(rbxthumbWithTypeSizeAndOptions)

		callback()
	end))
end

return function(p, items, p2)
	return function(_)
		local v = subdivideEntries(p, 100)
		local v2 = {}

		for _, v3 in pairs(v) do
			table.insert(v2, makePreloadAsyncPromise(v3, items, p2)) -- inferred equivalent call
		end

		return PromiseUtilities.Batch(v2)
	end
end
