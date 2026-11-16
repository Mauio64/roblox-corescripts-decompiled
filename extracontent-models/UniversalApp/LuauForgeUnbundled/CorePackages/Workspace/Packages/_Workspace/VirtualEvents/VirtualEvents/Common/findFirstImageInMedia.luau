require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")

local function findFirstImageInMedia(items)
	for k, item in items do
		if item.assetType == "Image" and item.imageId then
			return ("rbxassetid://%s"):format(item.imageId)
		end
	end

	return nil
end

return findFirstImageInMedia
