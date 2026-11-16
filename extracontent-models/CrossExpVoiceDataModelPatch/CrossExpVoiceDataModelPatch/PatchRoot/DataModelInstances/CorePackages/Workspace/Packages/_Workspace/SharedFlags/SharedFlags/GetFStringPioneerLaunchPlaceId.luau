game:DefineFastString("PioneerLaunchPlaceId", "")

return function()
	local fastString = tonumber(game:GetFastString("PioneerLaunchPlaceId"))

	if fastString and not (fastString <= 0) then
		return fastString
	end

	return nil
end
