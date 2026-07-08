local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local EngineFeature = game:GetEngineFeature("AudioFocusManagement")
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local v6 = if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then nil else require(Chrome.Service)
local Constants = require(Chrome.Integrations.Party.Constants)
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected

local function PartyMicBinder() -- line: 15
	-- upvalues: useIsVoiceFocused (copy), useIsVoiceConnected (copy), React (copy), v6 (copy), Constants (copy), EngineFeature (copy)
	local v11 = useIsVoiceFocused()
	local v12 = useIsVoiceConnected()
	local v13 = React.useMemo(function() -- line: 18
		-- upvalues: v6 (copy), Constants (copy)
		if v6 then
			return v6:integrations()[Constants.TOGGLE_MIC_INTEGRATION_ID]
		end

		return nil
	end, {})

	React.useEffect(function() -- line: 25
		-- upvalues: v13 (copy), v12 (copy), v11 (copy), EngineFeature (copy)
		if v13 then
			if v12 and (v11 or not EngineFeature) then
				v13.availability:available()

				return
			end

			v13.availability:unavailable()
		end
	end, {
		v12,
		v11,
		v13
	})

	return nil
end

return PartyMicBinder
