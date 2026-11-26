require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/model")
local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")

local function isAmount(value): boolean
	return typeof(value) == "number" and value >= 0 and value <= 9007199254740991
end

local function decodeFundingError(data)
	if typeof(data) ~= "table" or data.code ~= AcpProtocol.ErrorCodes.OutOfCredits then
		return nil, nil
	end

	local message = data.message

	if message == "FreeTrialExhausted" then
		return "FreeTrialExhausted", nil
	end

	if message ~= "InsufficientRobuxBalance" and message ~= "DailyLimitReached" then
		return nil, nil
	end

	local data2 = data.data

	if typeof(data2) ~= "table" or data2.model ~= "default" and data2.model ~= "advanced" then
		return message, nil
	end

	local requiredRobux = data2.requiredRobux
	local v5

	if typeof(requiredRobux) == "number" and requiredRobux >= 0 then
		v5 = requiredRobux <= 9007199254740991
	else
		v5 = false
	end

	if not v5 then
		return message, nil
	end

	local availableRobux = data2.availableRobux
	local v6

	if typeof(availableRobux) == "number" and availableRobux >= 0 then
		v6 = availableRobux <= 9007199254740991
	else
		v6 = false
	end

	if v6 then
		return
			message,
			{
				model = data2.model,
				requiredRobux = data2.requiredRobux,
				availableRobux = data2.availableRobux
			}
	end

	return message, nil
end

return decodeFundingError
