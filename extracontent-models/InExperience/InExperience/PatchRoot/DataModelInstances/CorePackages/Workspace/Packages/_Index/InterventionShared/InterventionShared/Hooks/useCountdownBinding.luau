local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("InterventionShared").Parent
local React = require(Parent.React)

local function useCountdownBinding(n1: number?, s1: string?) -- line: 15
	-- upvalues: React (copy), LocalizationService (copy), RunService (copy)
	local v8, v9 = React.useBinding(s1 or "")
	local v10 = React.useCallback(function() -- line: 17
		-- upvalues: n1 (copy), LocalizationService (copy), v9 (copy), s1 (copy)
		if n1 ~= nil then
			local dateTime = DateTime.now()
			local v12 = math.max(n1 - dateTime.UnixTimestamp, 0)
			local v13 = if not (v12 >= 3600) then DateTime.fromUnixTimestamp(v12):FormatUniversalTime("m:ss", LocalizationService.RobloxLocaleId) else DateTime.fromUnixTimestamp(v12):FormatUniversalTime("h:mm:ss", LocalizationService.RobloxLocaleId)

			v9(v13)

			return v12
		end

		v9(s1 or "")

		return 0
	end, {
		s1,
		n1
	})

	React.useEffect(function() -- line: 38
		-- upvalues: v10 (copy)
		v10()
	end, { v10 })
	React.useEffect(function() -- line: 43
		-- upvalues: n1 (copy), RunService (copy), v10 (copy)
		local u14 = nil

		if n1 ~= nil then
			local dateTime = DateTime.now()
			local u16 = n1 - dateTime.UnixTimestamp

			if u16 > 0 then
				local n2 = 0

				u14 = RunService.Heartbeat:Connect(function() -- line: 52
					-- upvalues: n2 (ref), u16 (ref), v10 (copy), u14 (ref)
					local elapsed = os.clock()

					if elapsed - n2 < 1 then
						return
					end

					n2 = elapsed
					u16 = v10()

					if u16 <= 0 and u14 then
						u14:Disconnect()
						u14 = nil
					end
				end)
			end
		end

		return function() -- line: 66
			-- upvalues: u14 (ref)
			if u14 ~= nil then
				u14:Disconnect()
				u14 = nil
			end
		end
	end, {
		n1,
		v10
	})

	return v8
end

return useCountdownBinding
