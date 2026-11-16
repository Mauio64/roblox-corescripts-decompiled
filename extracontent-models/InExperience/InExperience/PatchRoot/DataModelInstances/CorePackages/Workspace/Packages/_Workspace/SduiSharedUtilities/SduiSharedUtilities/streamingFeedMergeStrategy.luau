local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
require(SduiSharedUtilities.SduiIntegrationTypes)

local function streamingFeedMergeStrategy(list, _, _): nil | string
	if #list == 1 and (list[1] == "entry_map" or list[1] == "entry_order") then
		return "merge"
	end

	return nil
end

return streamingFeedMergeStrategy
