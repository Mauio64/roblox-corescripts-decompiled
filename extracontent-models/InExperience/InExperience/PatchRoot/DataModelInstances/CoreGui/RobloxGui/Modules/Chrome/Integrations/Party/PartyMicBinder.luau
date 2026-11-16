local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local engineFeature = game:GetEngineFeature("AudioFocusManagement")

local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Service

if Chrome2.Enabled() then
	Service = require(Chrome.Service)
else
	Service = nil
end

local Constants = require(Chrome.Integrations.Party.Constants)
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected

local function PartyMicBinder(): nil
	local v = useIsVoiceFocused()
	local v2 = useIsVoiceConnected()
	local v3 = React.useMemo(function()
		if Service then
			return Service:integrations()[Constants.TOGGLE_MIC_INTEGRATION_ID]
		end

		return nil
	end, {})

	React.useEffect(function()
		if v3 then
			if v2 and (v or not engineFeature) then
				v3.availability:available()
			else
				v3.availability:unavailable()
			end
		end
	end, { v2, v, v3 })

	return nil
end

return PartyMicBinder
