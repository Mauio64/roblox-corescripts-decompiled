local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function findFirstImageInMedia(t1: {[any]: any}) -- line: 15
	for _, v5 in t1 do
		if v5.assetType == "Image" and v5.imageId then
			return ("rbxassetid://%s"):format(v5.imageId)
		end
	end

	return nil
end

return findFirstImageInMedia
