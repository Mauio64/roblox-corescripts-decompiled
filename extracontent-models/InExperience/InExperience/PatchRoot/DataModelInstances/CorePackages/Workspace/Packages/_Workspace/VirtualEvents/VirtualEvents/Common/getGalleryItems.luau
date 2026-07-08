local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local constants = require(VirtualEvents.constants)

require(VirtualEvents.Parent.AppBlox)

local FFlagLuaAppLimitEventThumbnailToOne = require(VirtualEvents.Flags.FFlagLuaAppLimitEventThumbnailToOne)

local function getGalleryItems(t1: {[any]: any}?) -- line: 21
	-- upvalues: FFlagLuaAppLimitEventThumbnailToOne (copy), constants (copy)
	local t2 = {}

	if t1 then
		for _, v8 in t1 do
			if v8.assetType == "Image" and v8.imageId then
				table.insert(t2, {
					isYouTubeVideo = false,
					imageId = ("rbxassetid://%s"):format(v8.imageId)
				})
			end
		end
	end

	if #t2 > 0 then
		if FFlagLuaAppLimitEventThumbnailToOne then
			return { t2[1] }
		end

		return t2
	end

	return {{
		isYouTubeVideo = false,
		imageId = constants.DEFAULT_EVENT_THUMBNAIL
	}}
end

return getGalleryItems
