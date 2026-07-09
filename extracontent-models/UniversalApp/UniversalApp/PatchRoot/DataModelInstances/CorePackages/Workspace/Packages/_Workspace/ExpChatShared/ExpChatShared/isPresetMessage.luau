local function isPresetMessage(t1: {[any]: any}?) -- line: 5
	if t1 == nil then
		return false
	end

	local presetId = t1.presetId

	return presetId ~= nil and presetId ~= ""
end

return isPresetMessage
