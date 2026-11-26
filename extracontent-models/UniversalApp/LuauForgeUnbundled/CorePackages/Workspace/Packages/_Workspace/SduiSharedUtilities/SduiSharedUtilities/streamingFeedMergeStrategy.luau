require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local function streamingFeedMergeStrategy(list, p2, p3): nil | string
	if #list == 1 and (list[1] == "entry_map" or list[1] == "entry_order") then
		return "merge"
	end

	return nil
end

return streamingFeedMergeStrategy
