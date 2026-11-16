local parent = script:FindFirstAncestor("InterventionShared").Parent

local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")

local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local v

if FFlagAppChatReactiveFeatureRestrictions then
	v = Localization.new(LocalizationService.RobloxLocaleId)
else
	v = nil
end

local function useCountdownBinding(p: number?, value: string?)
	local v2, v3 = React.useBinding(value or "")
	local v4 = React.useCallback(function()
		if p == nil then
			v3(value or "")

			return 0
		end

		local v4 = math.max(p - DateTime.now().UnixTimestamp, 0)
		local v5

		if FFlagAppChatReactiveFeatureRestrictions and v ~= nil and v4 >= 86400 then
			local number = math.ceil(v4 / 86400)

			if number == 1 then
				v5 = v:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Singular")
			else
				v5 = v:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Plural", {
					number = number
				})
			end
		elseif v4 >= 3600 then
			v5 = DateTime.fromUnixTimestamp(v4):FormatUniversalTime(
				FFlagAppChatReactiveFeatureRestrictions and "HH:mm:ss" or "h:mm:ss",
				LocalizationService.RobloxLocaleId
			)
		else
			v5 = DateTime.fromUnixTimestamp(v4):FormatUniversalTime("m:ss", LocalizationService.RobloxLocaleId)
		end

		v3(v5)
		return v4
	end, { value, p })

	React.useEffect(function()
		v4()
	end, { v4 })

	React.useEffect(function()
		local heartbeatConnection = nil

		if p ~= nil then
			local v5 = p - DateTime.now().UnixTimestamp

			if v5 > 0 then
				local v6 = 0

				heartbeatConnection = RunService.Heartbeat:Connect(function()
					local now = os.clock()

					if now - v6 < 1 then
						return
					end

					v6 = now
					v5 = v4()

					if v5 <= 0 and heartbeatConnection then
						heartbeatConnection:Disconnect()
						heartbeatConnection = nil
					end
				end)
			end
		end

		return function()
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end
	end, { p, v4 })

	return v2
end

return useCountdownBinding
