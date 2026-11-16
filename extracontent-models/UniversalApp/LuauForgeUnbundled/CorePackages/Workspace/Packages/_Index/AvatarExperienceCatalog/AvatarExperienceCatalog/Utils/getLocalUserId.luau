local function getLocalUserId(p2)
	if p2.LocalPlayer then
		return (tostring(p2.LocalPlayer.UserId))
	end

	return nil
end

return getLocalUserId
