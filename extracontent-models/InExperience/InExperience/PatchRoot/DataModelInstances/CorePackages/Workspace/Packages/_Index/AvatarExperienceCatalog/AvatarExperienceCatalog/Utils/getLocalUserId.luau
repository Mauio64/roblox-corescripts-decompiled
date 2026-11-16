local function getLocalUserId(p)
	if p.LocalPlayer then
		return (tostring(p.LocalPlayer.UserId))
	end

	return nil
end

return getLocalUserId
