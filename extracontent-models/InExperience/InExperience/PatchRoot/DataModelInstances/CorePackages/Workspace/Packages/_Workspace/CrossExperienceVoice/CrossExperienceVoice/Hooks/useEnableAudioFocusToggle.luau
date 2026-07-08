local EngineFeature = game:GetEngineFeature("AudioFocusManagement")
local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local SharedFlags = dependencies.SharedFlags
local v5 = SharedFlags.GetFFlagEnableCrossExperienceVoiceCaptureMute()
local v6 = SharedFlags.GetFFlagEnableVoiceChatMuteForVideoCaptures()
local v7 = if not v6 then nil else game:GetService("CaptureService")
local React = dependencies.React
local Cryo = dependencies.Cryo

local function useIsCapturingVideo() -- line: 18
	-- upvalues: React (copy), v7 (copy)
	local v12, v13 = React.useState(v7 and v7:IsCapturingVideo())

	React.useEffect(function() -- line: 21
		-- upvalues: v7 (copy), v13 (copy)
		if not v7 then
			return
		end

		local connection = v7.VideoCaptureInProgress:Connect(function(b1: boolean) -- line: 26
			-- upvalues: v13 (copy)
			v13(b1)
		end)

		return function() -- line: 30
			-- upvalues: v7 (copy), connection (copy)
			if v7 then
				connection:Disconnect()
			end
		end
	end, {})

	return v12
end
local function useEnableAudioFocusToggle() -- line: 40
	-- upvalues: React (copy), v5 (copy), v6 (copy), useIsCapturingVideo (copy), Cryo (copy), EngineFeature (copy)
	local v14, v15 = React.useState({})
	local v16 = false

	if v5 and v6 then
		v16 = useIsCapturingVideo()
	end

	local v17 = React.useCallback(function(p1) -- line: 48
		-- upvalues: v14 (copy), Cryo (copy), v15 (copy)
		if not v14[p1] then
			local v21 = Cryo.Dictionary.join(v14, {
				[p1] = true
			})

			v15(v21)
		end
	end, { v14 })
	local v18 = React.useCallback(function(p2) -- line: 57
		-- upvalues: v14 (copy), Cryo (copy), v15 (copy)
		if v14[p2] then
			local v23 = Cryo.Dictionary.join(v14, {
				[p2] = nil
			})

			v15(v23)
		end
	end, { v14 })

	React.useEffect(function() -- line: 66
		-- upvalues: EngineFeature (copy), v15 (copy), v17 (copy), v18 (copy)
		if not EngineFeature then
			return
		end

		local ok, result = pcall(function() -- line: 71
			return game:GetService("AudioFocusService")
		end)

		if not ok or not result then
			return
		end

		local t1 = {}
		local RegisteredContexts = result:GetRegisteredContexts()

		for k, _ in pairs(RegisteredContexts) do
			t1[k] = true
		end

		v15(t1)

		local connection = result.OnContextRegistered:Connect(v17)
		local connection2 = result.OnContextUnregistered:Connect(v18)

		return function() -- line: 88
			-- upvalues: connection (copy), connection2 (copy)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {})

	return v14[1] and (v14[2] and not v16)
end

return useEnableAudioFocusToggle
