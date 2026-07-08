local Parent = script:FindFirstAncestor("InterventionShared").Parent
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local React = require(Parent.React)
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState
local dependencyArray = require(Parent.RoactUtils).Hooks.dependencyArray
local v9 = require(Parent.RobloxAppLocales).Localization.new(LocalizationService.RobloxLocaleId)

local function formatCountdown(n1: number) -- line: 37
	-- upvalues: v9 (copy), LocalizationService (copy)
	if n1 <= 0 then
		return nil
	end

	local v13 = math.ceil(n1 / 60) * 60

	if v13 >= 86400 then
		local v14 = math.ceil(v13 / 86400)

		if v14 == 1 then
			return (v9:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Singular"))
		end

		return (v9:Format("Feature.InExperienceIntervention.Label.TimeLeft.Day.Plural", {
			number = v14
		}))
	end

	local v15 = DateTime.fromUnixTimestamp(v13):FormatUniversalTime("HH:mm", LocalizationService.RobloxLocaleId)

	return v9:Format("Feature.InExperienceIntervention.Label.TimeLeft.Hours", {
		time = v15
	})
end
local function useRestrictionEndDateInfo(s1: string?) -- line: 70
	-- upvalues: useMemo (copy), LocalizationService (copy), dependencyArray (copy), useState (copy), formatCountdown (copy), useEffect (copy), RunService (copy)
	local v17 = if not s1 or s1 == "" then nil else DateTime.fromIsoDate(s1)
	local v18 = useMemo(function() -- line: 73
		-- upvalues: v17 (copy), LocalizationService (copy)
		if v17 then
			return (v17:FormatLocalTime("LLL", LocalizationService.RobloxLocaleId))
		end

		return nil
	end, dependencyArray(v17))
	local v19, v20 = useState(function() -- line: 77
		-- upvalues: v17 (copy), formatCountdown (copy)
		if v17 == nil then
			return nil
		end

		local v21 = math.max(v17.UnixTimestamp - DateTime.now().UnixTimestamp, 0)

		return formatCountdown(v21)
	end)

	useEffect(function() -- line: 86
		-- upvalues: v17 (copy), v20 (copy), formatCountdown (copy), RunService (copy)
		if v17 == nil then
			v20(nil)

			return
		end

		local dateTime = DateTime.now()
		local v23 = v17.UnixTimestamp - dateTime.UnixTimestamp

		if v23 <= 0 then
			v20(nil)

			return
		end

		v20(formatCountdown(v23))

		local n2 = 0
		local u25 = nil

		u25 = RunService.Heartbeat:Connect(function() -- line: 107
			-- upvalues: n2 (ref), v17 (copy), v20 (copy), formatCountdown (copy), u25 (ref)
			local elapsed = os.clock()

			if elapsed - n2 < 1 then
				return
			end

			n2 = elapsed

			local v27 = math.max(v17.UnixTimestamp - DateTime.now().UnixTimestamp, 0)

			v20(formatCountdown(v27))

			if v27 <= 0 and u25 then
				u25:Disconnect()
				u25 = nil
			end
		end)

		return function() -- line: 125
			-- upvalues: u25 (ref)
			if u25 then
				u25:Disconnect()
				u25 = nil
			end
		end
	end, dependencyArray(v17, v20))

	return {
		formattedEndDate = v18,
		countdownText = v19
	}
end

return useRestrictionEndDateInfo
