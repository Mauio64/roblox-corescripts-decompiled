local InsertService = game:GetService("InsertService")

local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Promise = require(parent.Promise)

require(script.Parent.types)

local function createAssetSource(InsertService2) -- 1 equivalent call inferred from this helper
	return function(p: number)
		return Promise.new(function(callback, callback2)
			task.spawn(function()
				local success, result = pcall(function()
					return InsertService2:LoadAsset(p)
				end)

				if not (success and result) then
					return callback2(`loadAsset failed for asset {p}: {tostring(result)}`)
				end

				local avatarBackground = result:FindFirstChild("AvatarBackground")
				local imageId = avatarBackground and avatarBackground:FindFirstChild("ImageId")
				local color = avatarBackground and avatarBackground:FindFirstChild("Color")

				if not (avatarBackground and imageId and color) then
					result:Destroy()
					return callback2(`asset {p} missing AvatarBackground/ImageId/Color`)
				end

				local imageId2 = imageId.Value
				local backgroundColor = color.Value
				result:Destroy()

				return callback({ imageId = imageId2, backgroundColor = backgroundColor })
			end)
		end)
	end
end

return {
	create = createAssetSource,
	default = createAssetSource(InsertService) -- inferred equivalent call
}
