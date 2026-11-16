local parent = script:FindFirstAncestor("InterventionShared").Parent

local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")

local React = require(parent.React)
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState

local RoactUtils = require(parent.RoactUtils)
local dependencyArray = RoactUtils.Hooks.dependencyArray

local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)

local function formatCountdown(p: number)
	if p <= 0 then
		return nil
	end

	local v = math.ceil(p / 60) * 60

	if not (v >= 86400) then
		return localization:Format("Feature.InExperienceIntervention.Label.TimeLeft.Hours", {
			time = DateTime.fromUnixTimestamp(v):FormatUniversalTime("HH:mm", LocalizationService.RobloxLocaleId)
		})
	end

	local number = math.ceil(v / 86400)

	if number == 1 then
		return (localization:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Singular"))
	end

	return (localization:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Plural", {
		number = number
	}))
end

local function useRestrictionEndDateInfo(p: string?)
	local dateTime

	if p and p ~= "" then
		dateTime = DateTime.fromIsoDate(p)
	else
		dateTime = nil
	end

	local formattedEndDate = useMemo(function()
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
		local v = dateTime.UnixTimestamp - now.UnixTimestamp

		if v <= 0 then
			setState(nil)
			return
		end

		setState(formatCountdown(v))

		local v2 = 0
		local heartbeatConnection = nil

		heartbeatConnection = RunService.Heartbeat:Connect(function()
			local now2 = os.clock()

			if now2 - v2 < 1 then
				return
			end

			v2 = now2

			local v3 = math.max(dateTime.UnixTimestamp - DateTime.now().UnixTimestamp, 0)
			setState(formatCountdown(v3))

			if v3 <= 0 and heartbeatConnection then
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

	return { formattedEndDate = formattedEndDate, countdownText = state }
end

return useRestrictionEndDateInfo
