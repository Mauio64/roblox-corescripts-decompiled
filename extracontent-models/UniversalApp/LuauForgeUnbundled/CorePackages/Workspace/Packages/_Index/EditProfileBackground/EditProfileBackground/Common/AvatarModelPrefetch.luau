local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Promise")

local Players = game:GetService("Players")

local v5 = {}

local v6 = {}

function v6.prefetch(p2)
	if v5[p2] then
		return
	end

	v5[p2] = Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return Players:CreateHumanoidModelFromUserIdAsync(p2)
		end)

		if success and result then
			callback(result)
		else
			callback2("CharacterModelCreationFailed")
		end
	end)
end

function v6.get(p2)
	if v5[p2] then
		return v5[p2]
	end

	v6.prefetch(p2)
	return v5[p2]
end

function v6.clear(p2)
	v5[p2] = nil
end

return v6
