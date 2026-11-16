local parent = script:FindFirstAncestor("EditProfileBackground").Parent
local Promise = require(parent.Promise)

local Players = game:GetService("Players")

local v = {}

local AvatarModelPrefetch = {}

function AvatarModelPrefetch.prefetch(p: number)
	if v[p] then
		return
	end

	v[p] = Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return Players:CreateHumanoidModelFromUserIdAsync(p)
		end)

		if success and result then
			callback(result)
		else
			callback2("CharacterModelCreationFailed")
		end
	end)
end

function AvatarModelPrefetch.get(p: number)
	if v[p] then
		return v[p]
	end

	AvatarModelPrefetch.prefetch(p)
	return v[p]
end

function AvatarModelPrefetch.clear(p: number)
	v[p] = nil
end

return AvatarModelPrefetch
