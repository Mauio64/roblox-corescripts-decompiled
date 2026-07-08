local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local Cryo = require(UserLibParent.Cryo)
local PromiseUtilities = require(UserLibParent.AppCommonLib).Utils.PromiseUtilities

require(UserLib.Utils)

local Promise = require(UserLibParent.Promise)
local Constants = require(UserLib.Utils.Constants)
local getRbxthumbWithTypeSizeAndOptions = require(UserLib.Utils).getRbxthumbWithTypeSizeAndOptions

local function subdivideEntries(p1, p2) -- line: 33
	-- upvalues: Cryo (copy)
	local t1 = {}

	for i = 1, #p1, p2 do
		table.insert(t1, (Cryo.List.getRange(p1, i, i + p2 - 1)))
	end

	return t1
end
local function makePreloadAsyncPromise(t2: {[any]: any}, t3: {[any]: any}, p3) -- line: 42
	-- upvalues: Promise (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy)
	return (Promise.new(function(resolve, _) -- line: 47
		-- upvalues: t2 (copy), t3 (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), p3 (copy)
		local t4 = {}
		local t5 = {}

		for _, v25 in t2 do
			t5[v25] = {}

			for _, v27 in t3 do
				t5[v25][v27.thumbnailType] = t5[v25][v27.thumbnailType] or {}

				local v28 = Constants.RbxThumbnailSizeToNumberSize[v27.thumbnailSize]
				local v29 = Constants.RbxAvatarThumbnailTypeFromEnumToRbxthumbType[v27.thumbnailType]
				local v30 = getRbxthumbWithTypeSizeAndOptions(v25, v29, v28)

				t5[v25][v27.thumbnailType][v27.thumbnailSize] = v30
				table.insert(t4, v30)
			end
		end;

		(p3 or game:GetService("ContentProvider")):PreloadAsync(t4)
		resolve()
	end))
end

return function(t6: {[any]: any}, t7: {[any]: any}, p5) -- line: 80
	-- upvalues: subdivideEntries (copy), Promise (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), PromiseUtilities (copy)
	return function(_) -- line: 81
		-- upvalues: subdivideEntries (copy), t6 (copy), t7 (copy), p5 (copy), Promise (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), PromiseUtilities (copy)
		local t8 = {}
		local v33 = subdivideEntries(t6, 100)

		for _, v in pairs(v33) do
			local v36 = t7
			local v37 = p5

			table.insert(t8, (Promise.new(function(resolve, _) -- line: 47
				-- upvalues: v (copy), v36 (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), v37 (copy)
				local t9 = {}
				local t10 = {}

				for _, v43 in v do
					t10[v43] = {}

					for _, v45 in v36 do
						t10[v43][v45.thumbnailType] = t10[v43][v45.thumbnailType] or {}

						local v46 = Constants.RbxThumbnailSizeToNumberSize[v45.thumbnailSize]
						local v47 = Constants.RbxAvatarThumbnailTypeFromEnumToRbxthumbType[v45.thumbnailType]
						local v48 = getRbxthumbWithTypeSizeAndOptions(v43, v47, v46)

						t10[v43][v45.thumbnailType][v45.thumbnailSize] = v48
						table.insert(t9, v48)
					end
				end;

				(v37 or game:GetService("ContentProvider")):PreloadAsync(t9)
				resolve()
			end)))
		end

		return PromiseUtilities.Batch(t8)
	end
end
