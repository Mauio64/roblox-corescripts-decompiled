local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local VOICE_JOIN_PROGRESS = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/VoiceChatCore").Constants.VOICE_JOIN_PROGRESS

return {
	useIsVoiceChatReportable = function(object)
		local function computeIsVoiceChatReportable()
			return object:UserVoiceEnabled()
				and object:GetVoiceJoinProgress() ~= VOICE_JOIN_PROGRESS.Suspended
		end

		local state, setState = React.useState(computeIsVoiceChatReportable)

		React.useEffect(function()
			local v5 = true
			local function recheck()
				if not v5 then
					return
				end

				setState(object:UserVoiceEnabled() and object:GetVoiceJoinProgress() ~= VOICE_JOIN_PROGRESS.Suspended)
			end

			object:asyncInit():andThen(recheck):catch(recheck)

			local eventConnection = object.VoiceJoinProgressChanged.Event:Connect(recheck)

			return function()
				v5 = false
				eventConnection:Disconnect()
			end
		end, { object })

		return state
	end
}
