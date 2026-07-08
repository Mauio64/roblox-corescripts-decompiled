local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local VOICE_JOIN_PROGRESS = require(Parent.VoiceChatCore).Constants.VOICE_JOIN_PROGRESS

return {
	useIsVoiceChatReportable = function(t1: {[any]: any}) -- line: 25
		-- upvalues: VOICE_JOIN_PROGRESS (copy), React (copy)
		local function computeIsVoiceChatReportable() -- line: 26
			-- upvalues: t1 (copy), VOICE_JOIN_PROGRESS (copy)
			return t1:UserVoiceEnabled() and t1:GetVoiceJoinProgress() ~= VOICE_JOIN_PROGRESS.Suspended
		end

		local v6, v7 = React.useState(computeIsVoiceChatReportable)

		React.useEffect(function() -- line: 34
			-- upvalues: v7 (copy), t1 (copy), VOICE_JOIN_PROGRESS (copy)
			local u8 = true

			local function recheck() -- line: 36
				-- upvalues: u8 (ref), v7 (copy), t1 (copy), VOICE_JOIN_PROGRESS (copy)
				if not u8 then
					return
				end

				v7(t1:UserVoiceEnabled() and t1:GetVoiceJoinProgress() ~= VOICE_JOIN_PROGRESS.Suspended)
			end

			t1:asyncInit():andThen(recheck):catch(recheck)

			local connection = t1.VoiceJoinProgressChanged.Event:Connect(recheck)

			return function() -- line: 50
				-- upvalues: u8 (ref), connection (copy)
				u8 = false
				connection:Disconnect()
			end
		end, { t1 })

		return v6
	end
}
