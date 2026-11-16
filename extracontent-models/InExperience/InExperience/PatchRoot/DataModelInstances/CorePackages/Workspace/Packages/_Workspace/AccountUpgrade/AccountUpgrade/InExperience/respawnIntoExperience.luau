local v = {
	getPlaceId = function()
		return game.PlaceId
	end,
	teleport = function(p: number)
		local TeleportService = game:GetService("TeleportService")
		TeleportService:Teleport(p)
	end
}

local function respawnIntoExperience(p)
	local v2 = p or v
	local placeId = v2.getPlaceId()

	if placeId == 0 then
		warn("AccountUpgrade: cannot rejoin, PlaceId is 0")
		return false
	end

	local success, result = pcall(function()
		v2.teleport(placeId)
	end)

	if not success then
		warn(`AccountUpgrade: rejoin failed, {tostring(result)}`)
	end

	return success
end

return respawnIntoExperience
