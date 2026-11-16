local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function findFirstImageInMedia(items)
	for _, item in items do
		if item.assetType == "Image" and item.imageId then
			return ("rbxassetid://%s"):format(item.imageId)
		end
	end

	return nil
end

return findFirstImageInMedia
