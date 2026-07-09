local function getMessageTextSize(t1: {[any]: any}?, b1: boolean?) -- line: 13
	if t1 == nil then
		return nil
	end

	if b1 then
		return t1.SpatialPanelTextSize
	end

	return t1.TextSize
end

return getMessageTextSize
