local function getLocalUserId(p)
	local localPlayer = p.LocalPlayer

	if localPlayer then
		return (tostring(localPlayer.UserId))
	end

	return nil
end

return getLocalUserId
