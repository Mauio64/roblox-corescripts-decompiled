local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)

local v = nil
local v2 = nil

local function removeDefaultClothing(instance, callback, callback2)
	local avatarRulesAsync = AvatarEditorService:GetAvatarRulesAsync()

	if not avatarRulesAsync.DefaultClothingAssetLists then
		callback2("No default clothing in avatar rules")
		return
	end

	local defaultShirtAssetIds = avatarRulesAsync.DefaultClothingAssetLists.DefaultShirtAssetIds
	local defaultPantAssetIds = avatarRulesAsync.DefaultClothingAssetLists.DefaultPantAssetIds

	if not (defaultShirtAssetIds and defaultPantAssetIds) then
		callback2("No default clothing ids in avatar rules")
		return
	end

	local v3 = nil

	for _, defaultShirtAssetId in ipairs(defaultShirtAssetIds) do
		if defaultShirtAssetId ~= instance.Shirt then
			continue
		end

		v3 = v3 or instance:Clone()
		v3.Shirt = 0
	end

	for _, defaultPantAssetId in ipairs(defaultPantAssetIds) do
		if defaultPantAssetId ~= instance.Pants then
			continue
		end

		v3 = v3 or instance:Clone()
		v3.Pants = 0
	end

	callback(v3 or instance)
end

local function GetConformedHumanoidDescription(p, p2)
	if p ~= v then
		return Promise.new(function(callback, callback2)
			coroutine.wrap(function()
				local success, result = pcall(function()
					return AvatarEditorService:ConformToAvatarRulesAsync(p)
				end)

				if not success then
					callback2(result)

					return
				end

				v = p
				v2 = result

				if p2 then
					callback(result)
				else
					removeDefaultClothing(result, callback, callback2)
				end
			end)()
		end)
	end

	if p2 then
		return Promise.resolve(v2)
	end

	return Promise.new(function(p3, p4)
		removeDefaultClothing(v2, p3, p4)
	end)
end

return GetConformedHumanoidDescription
