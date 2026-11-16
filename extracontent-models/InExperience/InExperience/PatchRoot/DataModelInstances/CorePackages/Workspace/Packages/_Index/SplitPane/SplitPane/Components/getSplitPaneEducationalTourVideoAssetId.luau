require(script.Parent.SplitPaneEducationalTourSteps)

local function getSplitPaneEducationalTourVideoAssetId(data, flag: boolean, flag2: boolean)
	if flag2 then
		if flag and data.collapsedGamepadVideoAssetId ~= nil then
			return data.collapsedGamepadVideoAssetId
		end

		if data.collapsedVideoAssetId ~= nil then
			return data.collapsedVideoAssetId
		end
	end

	if flag and data.gamepadVideoAssetId ~= nil then
		return data.gamepadVideoAssetId
	end

	return data.videoAssetId
end

return getSplitPaneEducationalTourVideoAssetId
