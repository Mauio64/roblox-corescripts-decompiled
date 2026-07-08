local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local u4 = nil
local u5 = nil

local function removeDefaultClothing(p1, p2, p3) -- line: 14
	-- upvalues: AvatarEditorService (copy)
	local v11 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then AvatarEditorService:GetAvatarRules() else AvatarEditorService:GetAvatarRulesAsync()

	if not v11.DefaultClothingAssetLists then
		p3("No default clothing in avatar rules")

		return
	end

	local DefaultShirtAssetIds = v11.DefaultClothingAssetLists.DefaultShirtAssetIds
	local DefaultPantAssetIds = v11.DefaultClothingAssetLists.DefaultPantAssetIds

	if not DefaultShirtAssetIds or not DefaultPantAssetIds then
		p3("No default clothing ids in avatar rules")

		return
	end

	local v14 = nil

	for _, v in ipairs(DefaultShirtAssetIds) do
		if v == p1.Shirt then
			v14 = v14 or p1:Clone()
			v14.Shirt = 0
		end
	end

	for _, v in ipairs(DefaultPantAssetIds) do
		if v == p1.Pants then
			v14 = v14 or p1:Clone()
			v14.Pants = 0
		end
	end

	p2(v14 or p1)
end
local function GetConformedHumanoidDescription(p4, p5) -- line: 53
	-- upvalues: u4 (ref), Promise (copy), u5 (ref), removeDefaultClothing (copy), AvatarEditorService (copy)
	if p4 == u4 then
		if p5 then
			return Promise.resolve(u5)
		end

		return Promise.new(function(resolve, reject) -- line: 58
			-- upvalues: removeDefaultClothing (copy), u5 (ref)
			removeDefaultClothing(u5, resolve, reject)
		end)
	end

	return Promise.new(function(resolve, reject) -- line: 64
		-- upvalues: AvatarEditorService (copy), p4 (copy), u4 (ref), u5 (ref), p5 (copy), removeDefaultClothing (copy)
		coroutine.wrap(function() -- line: 65
			-- upvalues: AvatarEditorService (copy), p4 (copy), u4 (ref), u5 (ref), p5 (copy), resolve (copy), removeDefaultClothing (copy), reject (copy)
			local ok, result = pcall(function() -- line: 66
				-- upvalues: AvatarEditorService (copy), p4 (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return AvatarEditorService:ConformToAvatarRulesAsync(p4)
				end

				return AvatarEditorService:ConformToAvatarRules(p4)
			end)

			if ok then
				u4 = p4
				u5 = result

				if p5 then
					resolve(result)

					return
				end

				removeDefaultClothing(result, resolve, reject)

				return
			end

			reject(result)
		end)()
	end)
end

return GetConformedHumanoidDescription
