require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourSteps")

local function getSplitPaneEducationalTourVideoAssetId(data, p2, p3)
	if p3 then
		if p2 and data.collapsedGamepadVideoAssetId ~= nil then
			return data.collapsedGamepadVideoAssetId
		end

		if data.collapsedVideoAssetId ~= nil then
			return data.collapsedVideoAssetId
		end
	end

	if p2 and data.gamepadVideoAssetId ~= nil then
		return data.gamepadVideoAssetId
	end

	return data.videoAssetId
end

return getSplitPaneEducationalTourVideoAssetId
