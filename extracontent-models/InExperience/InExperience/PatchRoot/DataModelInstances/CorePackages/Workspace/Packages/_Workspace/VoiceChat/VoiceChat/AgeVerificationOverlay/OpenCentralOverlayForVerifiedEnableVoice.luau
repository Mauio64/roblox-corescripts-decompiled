local parent = script:FindFirstAncestor("VoiceChat").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(options)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.VerifiedEnableVoice, options or {}))
	end
end
