local function getLocalUserId(p2)
	local localPlayer = p2.LocalPlayer

	if localPlayer then
		return (tostring(localPlayer.UserId))
	end

	return nil
end

return getLocalUserId
