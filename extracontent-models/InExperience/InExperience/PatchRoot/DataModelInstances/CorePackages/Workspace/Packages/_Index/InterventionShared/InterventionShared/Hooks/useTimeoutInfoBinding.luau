local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local RunService = game:GetService("RunService")
local React = require(InterventionSharedParent.React)
local useBinding = React.useBinding
local useEffect = React.useEffect
local determineChatTimeoutInfo = require(InterventionShared.Utils.determineChatTimeoutInfo)

local function useTimeoutInfoBinding(s1: string?, n1: number?) -- line: 24
	-- upvalues: useBinding (copy), useEffect (copy), determineChatTimeoutInfo (copy), RunService (copy)
	local v11, v12 = useBinding("")
	local v13, v14 = useBinding("")
	local v15 = if not s1 or s1 == "" then nil else DateTime.fromIsoDate(s1)

	useEffect(function() -- line: 30
		-- upvalues: determineChatTimeoutInfo (copy), v15 (copy), n1 (copy), v12 (copy), v14 (copy)
		local _, v17, v18 = determineChatTimeoutInfo(v15, n1)

		v12(v17)
		v14(v18)
	end, {
		v15,
		n1
	})
	useEffect(function() -- line: 36
		-- upvalues: v15 (copy), RunService (copy), determineChatTimeoutInfo (copy), n1 (copy), v12 (copy), v14 (copy)
		local connection = nil

		if v15 == nil then
			return
		end

		local dateTime = DateTime.now()

		if v15.UnixTimestamp - dateTime.UnixTimestamp <= 0 then
			return
		end

		local n2 = 0

		connection = RunService.Heartbeat:Connect(function() -- line: 52
			-- upvalues: n2 (ref), determineChatTimeoutInfo (copy), v15 (copy), n1 (copy), v12 (copy), v14 (copy), connection (ref)
			local elapsed = os.clock()

			if elapsed - n2 < 1 then
				return
			end

			n2 = elapsed

			local v23, v24, v25 = determineChatTimeoutInfo(v15, n1)

			v12(v24)
			v14(v25)

			if v23 <= 0 and connection then
				connection:Disconnect()
			end
		end)

		return function() -- line: 72
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v15 })

	return {
		heading = v11,
		description = v13
	}
end

return useTimeoutInfoBinding
