local function isPresetMessage(p): boolean
	if p == nil then
		return false
	end

	local presetId = p.presetId
	return presetId ~= nil and presetId ~= ""
end

return isPresetMessage
