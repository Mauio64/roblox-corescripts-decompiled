local InsertService = game:GetService("InsertService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Promise")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/types")

local function createAssetSource(object)
	return function(p2)
		return Promise.new(function(callback, callback2)
			task.spawn(function()
				local success, result = pcall(function()
					return object:LoadAsset(p2)
				end)

				if not (success and result) then
					return callback2(`loadAsset failed for asset {p2}: {tostring(result)}`)
				end

				local avatarBackground = result:FindFirstChild("AvatarBackground")
				local imageId = avatarBackground and avatarBackground:FindFirstChild("ImageId")
				local color = avatarBackground and avatarBackground:FindFirstChild("Color")

				if not (avatarBackground and imageId and color) then
					result:Destroy()
					return callback2(`asset {p2} missing AvatarBackground/ImageId/Color`)
				end

				local value = imageId.Value
				local value2 = color.Value
				result:Destroy()

				return callback({ imageId = value, backgroundColor = value2 })
			end)
		end)
	end
end
return {
	create = createAssetSource,
	default = function(p2)
		return Promise.new(function(callback, callback2)
			task.spawn(function()
				local success, result = pcall(function()
					return InsertService:LoadAsset(p2)
				end)

				if not (success and result) then
					return callback2(`loadAsset failed for asset {p2}: {tostring(result)}`)
				end

				local avatarBackground = result:FindFirstChild("AvatarBackground")
				local imageId = avatarBackground and avatarBackground:FindFirstChild("ImageId")
				local color = avatarBackground and avatarBackground:FindFirstChild("Color")

				if not (avatarBackground and imageId and color) then
					result:Destroy()
					return callback2(`asset {p2} missing AvatarBackground/ImageId/Color`)
				end

				local value = imageId.Value
				local value2 = color.Value
				result:Destroy()

				return callback({ imageId = value, backgroundColor = value2 })
			end)
		end)
	end
}
