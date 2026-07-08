local v1 = game:GetEngineFeature("VoiceChatSupported") and Enum.VoiceChatState.Ended or nil
local t1 = {
	voiceEnabled = false,
	voiceState = v1
}
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local v8 = React.createContext(t1)

return {
	Provider = function(p1) -- line: 49
		-- upvalues: React (copy), t1 (copy), default (copy), v1 (copy), v8 (copy)
		local v10, v11 = React.useState(t1)

		local function updateVoiceState(_, p3) -- line: 52
			-- upvalues: v10 (copy), v11 (copy)
			if p3 ~= v10.voiceState then
				local v16 = p3 ~= Enum.VoiceChatState.Ended

				v11({
					voiceEnabled = v16,
					voiceState = p3
				})
			end
		end

		React.useEffect(function() -- line: 62
			-- upvalues: default (copy), v10 (copy), v11 (copy), updateVoiceState (copy), v1 (copy)
			local u17 = true
			local connection = nil

			if game:GetEngineFeature("VoiceChatSupported") then
				default:asyncInit():andThen(function() -- line: 67
					-- upvalues: u17 (ref), default (copy), v10 (copy), v11 (copy), connection (ref), updateVoiceState (copy)
					if u17 then
						default:SetupParticipantListeners()

						local v19 = default:getService()

						if v19 then
							local VoiceChatState = v19.VoiceChatState

							if VoiceChatState ~= v10.voiceState then
								local v21 = VoiceChatState ~= Enum.VoiceChatState.Ended

								v11({
									voiceEnabled = v21,
									voiceState = VoiceChatState
								})
							end

							connection = v19.StateChanged:Connect(updateVoiceState)
						end
					end
				end):catch(function() -- line: 77
					-- upvalues: v1 (copy), v10 (copy), v11 (copy)
					local v22 = v1

					if v22 ~= v10.voiceState then
						local v23 = v22 ~= Enum.VoiceChatState.Ended

						v11({
							voiceEnabled = v23,
							voiceState = v22
						})
					end
				end)
			end

			return function() -- line: 82
				-- upvalues: u17 (ref), connection (ref)
				u17 = false

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end, {})

		return React.createElement(v8.Provider, {
			value = v10
		}, p1.children)
	end,
	Consumer = v8.Consumer,
	Context = v8,
	withVoiceState = function(p4) -- line: 100
		-- upvalues: React (copy), v8 (copy)
		return React.createElement(v8.Consumer, {
			render = p4
		})
	end
}
