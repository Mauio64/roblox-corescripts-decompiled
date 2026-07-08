local RunService = game:GetService("RunService")
local GameCollections = script:FindFirstAncestor("GameCollections")
local GameCollectionsParent = GameCollections.Parent
local React = require(GameCollectionsParent.React)
local calculateCountdownTime = require(GameCollections.calculateCountdownTime)

local function validateTimeValues(p1) -- line: 19
	if p1.days < 0 then
		return false
	end

	if p1.hours < 0 or p1.hours > 23 then
		return false
	end

	if p1.minutes < 0 or p1.minutes > 59 then
		return false
	end

	return true
end
local function getUpdateFrequency(n1: number) -- line: 35
	if n1 < 15 then
		return 1
	end

	return 15
end
local function useCountdownSubtitleTextBinding(n2: number?, s1: string?, s2: string?) -- line: 46
	-- upvalues: React (copy), calculateCountdownTime (copy), RunService (copy)
	local v14, v15 = React.useState("")
	local v16 = React.useCallback(function() -- line: 52
		-- upvalues: s2 (copy), n2 (copy), s1 (copy), calculateCountdownTime (copy), v15 (copy)
		if s2 ~= nil and (s2 ~= "" and n2 ~= nil and s1 ~= nil and s1 ~= "") then
			local v17 = s2
			local dateTime = DateTime.now()
			local v19 = n2 - dateTime.UnixTimestamp
			local v20 = calculateCountdownTime(v19)

			if not (v20.days < 0) and (not (v20.hours < 0) and (not (v20.hours > 23) and (not (v20.minutes < 0) and not (v20.minutes > 59)))) then
				v17 = if not (v20.days > 0) then s1:gsub("{hours}", (tostring(v20.hours))):gsub("{minutes}", (tostring(v20.minutes))) else s2
			end

			v15(v17)

			return v19
		end

		return 0
	end, {
		s2,
		n2,
		s1
	})

	React.useEffect(function() -- line: 79
		-- upvalues: v16 (copy)
		v16()
	end, { v16 })
	React.useEffect(function() -- line: 84
		-- upvalues: s2 (copy), n2 (copy), s1 (copy), RunService (copy), v16 (copy)
		local u21 = nil

		if s2 ~= nil and (s2 ~= "" and n2 ~= nil and s1 ~= nil and s1 ~= "") then
			local dateTime = DateTime.now()
			local u23 = n2 - dateTime.UnixTimestamp

			if u23 > 0 then
				local n3 = 0
				local u25 = not (u23 < 15) and 15 or 1

				u21 = RunService.Heartbeat:Connect(function() -- line: 99
					-- upvalues: n3 (ref), u25 (ref), u23 (ref), v16 (copy), u21 (ref)
					local elapsed = os.clock()

					if elapsed - n3 < u25 then
						return
					end

					n3 = elapsed
					u23 = v16()
					u25 = not (u23 < 15) and 15 or 1

					if u23 <= 0 and u21 then
						u21:Disconnect()
						u21 = nil
					end
				end)
			end
		end

		return function() -- line: 114
			-- upvalues: u21 (ref)
			if u21 ~= nil then
				u21:Disconnect()
				u21 = nil
			end
		end
	end, {
		n2,
		v16
	})

	return v14
end

return useCountdownSubtitleTextBinding
