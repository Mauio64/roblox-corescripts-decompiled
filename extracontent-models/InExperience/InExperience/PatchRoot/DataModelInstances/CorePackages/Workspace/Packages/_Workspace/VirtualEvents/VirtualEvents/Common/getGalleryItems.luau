local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)
local constants = require(VirtualEvents.constants)

require(VirtualEvents.Parent.AppBlox)

local FFlagLuaAppLimitEventThumbnailToOne = require(VirtualEvents.Flags.FFlagLuaAppLimitEventThumbnailToOne)

local function getGalleryItems(items)
	local result = {}

	if items then
		for _, item in items do
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
