local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")

local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/RobloxAppLocales").Localization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/SharedFlags").FFlagAppChatReactiveFeatureRestrictions
local v5

if fFlagAppChatReactiveFeatureRestrictions then
	v5 = localization.new(LocalizationService.RobloxLocaleId)
else
	v5 = nil
end

local function useCountdownBinding(p2, value)
	local v6, v7 = React.useBinding(value or "")
	local v8 = React.useCallback(function()
		if p2 == nil then
			v7(value or "")

			return 0
		end

		local now = DateTime.now()
		local v9 = math.max(p2 - now.UnixTimestamp, 0)
		local v10

		if fFlagAppChatReactiveFeatureRestrictions and v5 ~= nil and v9 >= 86400 then
			local v11 = math.ceil(v9 / 86400)

			if v11 == 1 then
				v10 = v5:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Singular")
			else
				v10 = v5:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Plural", {
					number = v11
				})
			end
		elseif v9 >= 3600 then
			v10 = DateTime.fromUnixTimestamp(v9):FormatUniversalTime(
				fFlagAppChatReactiveFeatureRestrictions and "HH:mm:ss" or "h:mm:ss",
				LocalizationService.RobloxLocaleId
			)
		else
			v10 = DateTime.fromUnixTimestamp(v9):FormatUniversalTime(
				"m:ss",
				LocalizationService.RobloxLocaleId
			)
		end

		v7(v10)
		return v9
	end, { value, p2 })

	React.useEffect(function()
		v8()
	end, { v8 })

	React.useEffect(function()
		local heartbeatConnection = nil

		if p2 ~= nil then
			local v9 = p2 - DateTime.now().UnixTimestamp

			if v9 > 0 then
				local v10 = 0

				heartbeatConnection = RunService.Heartbeat:Connect(function()
					local now2 = os.clock()

					if now2 - v10 < 1 then
						return
					end

					v10 = now2
					v9 = v8()

					if v9 <= 0 and heartbeatConnection then
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
	end, { p2, v8 })

	return v6
end

return useCountdownBinding
