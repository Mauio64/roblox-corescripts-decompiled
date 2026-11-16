local parent = script:FindFirstAncestor("VoiceChat").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(isUserOptIn)
	return { isUserOptIn = isUserOptIn }
end)
