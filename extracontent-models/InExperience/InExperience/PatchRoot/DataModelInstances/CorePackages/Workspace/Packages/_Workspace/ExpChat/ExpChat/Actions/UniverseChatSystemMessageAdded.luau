local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)
local SharedFlags = require(parent.SharedFlags)

local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation

return Rodux.makeActionCreator(
	script.Name,
	function(text: string, channelNameOverride: string, metadata: string?, isError: boolean?, postProcessMessage)
		if not FFlagExpChatDictation then
			isError = nil
		end

		return {
			text = text,
			channelNameOverride = channelNameOverride,
			metadata = metadata,
			isError = isError,
			postProcessMessage = postProcessMessage
		}
	end
)
