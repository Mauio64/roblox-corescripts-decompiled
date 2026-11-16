local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local VoiceChatCore = require(parent.VoiceChatCore)
local VOICE_JOIN_PROGRESS = VoiceChatCore.Constants.VOICE_JOIN_PROGRESS

return {
	useIsVoiceChatReportable = function(object)
		local function computeIsVoiceChatReportable() -- 1 equivalent call inferred from this helper
			return object:UserVoiceEnabled() and object:GetVoiceJoinProgress() ~= VOICE_JOIN_PROGRESS.Suspended
		end

		local state, setState = React.useState(computeIsVoiceChatReportable)

		React.useEffect(function()
			local v = true
			local function recheck()
				if not v then
					return
				end

				setState(computeIsVoiceChatReportable()) -- inferred equivalent call
			end

			object:asyncInit():andThen(recheck):catch(recheck)

			local eventConnection = object.VoiceJoinProgressChanged.Event:Connect(recheck)

			return function()
				v = false
				eventConnection:Disconnect()
			end
		end, { object })

		return state
	end
}
