local function getLocalUserId(p1) -- line: 1
	if p1.LocalPlayer then
		return (tostring(p1.LocalPlayer.UserId))
	end

	return nil
end

return getLocalUserId
