local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState

local dependencyArray = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/RoactUtils").Hooks.dependencyArray

local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/RobloxAppLocales").Localization.new(LocalizationService.RobloxLocaleId)

local function formatCountdown(p2)
	if p2 <= 0 then
		return nil
	end

	local v5 = math.ceil(p2 / 60) * 60

	if not (v5 >= 86400) then
		return localization:Format("Feature.InExperienceIntervention.Label.TimeLeft.Hours", {
			time = DateTime.fromUnixTimestamp(v5):FormatUniversalTime(
				"HH:mm",
				LocalizationService.RobloxLocaleId
			)
		})
	end

	local v6 = math.ceil(v5 / 86400)

	if v6 == 1 then
		return (localization:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Singular"))
	end

	return (localization:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Plural", {
		number = v6
	}))
end

local function useRestrictionEndDateInfo(p2)
	local dateTime = if p2 and p2 ~= "" then DateTime.fromIsoDate(p2) else nil

	local v5 = useMemo(function()
		if dateTime then
			return (dateTime:FormatLocalTime("LLL", LocalizationService.RobloxLocaleId))
		end

		return nil
	end, dependencyArray(dateTime))

	local state, setState = useState(function()
		if dateTime == nil then
			return nil
		end

		return formatCountdown(math.max(dateTime.UnixTimestamp - DateTime.now().UnixTimestamp, 0))
	end)

	useEffect(function()
		if dateTime == nil then
			setState(nil)
			return
		end

		local now = DateTime.now()
		local v6 = dateTime.UnixTimestamp - now.UnixTimestamp

		if v6 <= 0 then
			setState(nil)
			return
		end

		setState(formatCountdown(v6))

		local v7 = 0
		local heartbeatConnection = nil

		heartbeatConnection = RunService.Heartbeat:Connect(function()
			local now2 = os.clock()

			if now2 - v7 < 1 then
				return
			end

			v7 = now2

			local v8 = math.max(dateTime.UnixTimestamp - DateTime.now().UnixTimestamp, 0)
			setState(formatCountdown(v8))

			if v8 <= 0 and heartbeatConnection then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end)

		return function()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end
	end, dependencyArray(dateTime, setState))

	return { formattedEndDate = v5, countdownText = state }
end

return useRestrictionEndDateInfo
