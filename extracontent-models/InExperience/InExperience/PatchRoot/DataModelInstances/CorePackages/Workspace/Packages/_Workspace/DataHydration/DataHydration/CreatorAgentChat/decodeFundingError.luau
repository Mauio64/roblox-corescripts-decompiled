require(script.Parent.Types.model)
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)

local function isAmount(value): boolean -- 2 equivalent calls inferred from this helper
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

	if
		typeof(data2) == "table"
		and (data2.model == "default" or data2.model == "advanced")
		and isAmount(data2.requiredRobux) -- inferred equivalent call
		and isAmount(data2.availableRobux) -- inferred equivalent call
	then
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
