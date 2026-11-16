local v5 = {
	getPlaceId = function()
		return game.PlaceId
	end,
	teleport = function(p2)
		local TeleportService = game:GetService("TeleportService")
		TeleportService:Teleport(p2)
	end
}

local function respawnIntoExperience(p2)
	local v6 = p2 or v5
	local placeId = v6.getPlaceId()

	if placeId == 0 then
		warn("AccountUpgrade: cannot rejoin, PlaceId is 0")
		return false
	end

	local success, result = pcall(function()
		v6.teleport(placeId)
	end)

	if not success then
		warn(`AccountUpgrade: rejoin failed, {tostring(result)}`)
	end

	return success
end

return respawnIntoExperience
