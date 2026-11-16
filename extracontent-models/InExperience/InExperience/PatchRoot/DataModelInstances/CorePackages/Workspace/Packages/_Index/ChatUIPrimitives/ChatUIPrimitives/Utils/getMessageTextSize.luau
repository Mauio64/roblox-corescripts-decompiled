local function getMessageTextSize(p, flag: boolean?)
	if p == nil then
		return nil
	end

	return if flag then p.SpatialPanelTextSize else p.TextSize
end

return getMessageTextSize
