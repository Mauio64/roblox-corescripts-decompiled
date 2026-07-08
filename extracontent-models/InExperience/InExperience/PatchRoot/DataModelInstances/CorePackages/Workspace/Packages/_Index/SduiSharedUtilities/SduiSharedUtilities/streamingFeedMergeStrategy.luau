local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

require(SduiSharedUtilities.SduiIntegrationTypes)

local function streamingFeedMergeStrategy(t1: {[any]: any}, _, _) -- line: 9
	if #t1 == 1 and (t1[1] == "entry_map" or t1[1] == "entry_order") then
		return "merge"
	end

	return nil
end

return streamingFeedMergeStrategy
