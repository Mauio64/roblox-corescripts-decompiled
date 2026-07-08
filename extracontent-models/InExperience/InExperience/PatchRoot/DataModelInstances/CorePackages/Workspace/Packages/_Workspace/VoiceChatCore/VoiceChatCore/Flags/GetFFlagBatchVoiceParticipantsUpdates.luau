local Parent = script:FindFirstAncestor("VoiceChatCore").Parent
local IXPServiceWrapper = require(Parent.IXPServiceWrapper).IXPServiceWrapper

game:DefineFastFlag("BatchVoiceParticipantsUpdates", false)

local v3 = game:DefineFastString("ThrottleVoiceParticipantsUpdateLayerName", "Voice.Performance")
local v4 = game:DefineFastString("ThrottleVoiceParticipantsUpdateLayerValue", "BatchVoiceParticipantsUpdates")
local u5 = nil
local u6 = nil

if game:GetFastFlag("BatchVoiceParticipantsUpdates") then
	local ok, result = pcall(function() -- line: 12
		-- upvalues: IXPServiceWrapper (copy), v3 (copy)
		return IXPServiceWrapper:GetLayerData(v3)
	end)

	u5 = ok
	u6 = result
end

return function() -- line: 17
	-- upvalues: u5 (ref), u6 (ref), v4 (copy)
	return game:GetFastFlag("BatchVoiceParticipantsUpdates") and (u5 and (u6 and u6[v4]))
end
