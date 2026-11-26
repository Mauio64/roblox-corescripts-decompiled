local function isPresetMessage(p2): boolean
	if p2 == nil then
		return false
	end

	local presetId = p2.presetId
	return presetId ~= nil and presetId ~= ""
end

return isPresetMessage
