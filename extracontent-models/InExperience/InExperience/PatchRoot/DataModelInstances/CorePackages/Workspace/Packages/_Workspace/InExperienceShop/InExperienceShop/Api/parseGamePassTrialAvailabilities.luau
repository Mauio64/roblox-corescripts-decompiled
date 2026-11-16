local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function parseRedeemedEndTime(endTime) -- 1 equivalent call inferred from this helper
	if typeof(endTime) == "string" then
		return DateTime.fromIsoDate(endTime)
	end

	return nil
end

local function clearPass(gamePassTrialAvailabilities, gamePassId: string) -- 1 equivalent call inferred from this helper
	gamePassTrialAvailabilities.available[gamePassId] = nil
	gamePassTrialAvailabilities.active[gamePassId] = nil
	gamePassTrialAvailabilities.redeemed[gamePassId] = nil
end

local function parseGamePassTrialAvailabilities(items)
	local gamePassTrialAvailabilities = { available = {}, active = {}, redeemed = {} }

	for _, item in items do
		if not (typeof(item) == "table" and item.gamePassId ~= nil) then
			continue
		end

		local gamePassId = tostring(item.gamePassId)
		local status = item.status

		if not (status == "Available" or status == "Active" or status == "Redeemed") then
			continue
		end

		clearPass(gamePassTrialAvailabilities, gamePassId) -- inferred equivalent call

		if status == "Available" then
			gamePassTrialAvailabilities.available[gamePassId] = true
		elseif status == "Active" then
			gamePassTrialAvailabilities.active[gamePassId] = true
		else
			local redeemed = gamePassTrialAvailabilities.redeemed
			redeemed[gamePassId] = {
				gamePassId = gamePassId,
				endTime = parseRedeemedEndTime(item.endTime) -- inferred equivalent call
			}
		end
	end

	return gamePassTrialAvailabilities
end

return parseGamePassTrialAvailabilities
