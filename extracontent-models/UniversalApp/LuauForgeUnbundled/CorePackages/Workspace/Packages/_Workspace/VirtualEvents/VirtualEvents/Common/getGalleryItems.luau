require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/constants")

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/AppBlox")

local FFlagLuaAppLimitEventThumbnailToOne = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Flags/FFlagLuaAppLimitEventThumbnailToOne")

local function getGalleryItems(items)
	local result = {}

	if items then
		for k, item in items do
			if item.assetType == "Image" and item.imageId then
				table.insert(result, {
					imageId = ("rbxassetid://%s"):format(item.imageId),
					isYouTubeVideo = false
				})
			end
		end
	end

	if #result > 0 then
		if FFlagLuaAppLimitEventThumbnailToOne then
			return { result[1] }
		end

		return result
	end

	return {
		{ imageId = constants.DEFAULT_EVENT_THUMBNAIL, isYouTubeVideo = false }
	}
end

return getGalleryItems
