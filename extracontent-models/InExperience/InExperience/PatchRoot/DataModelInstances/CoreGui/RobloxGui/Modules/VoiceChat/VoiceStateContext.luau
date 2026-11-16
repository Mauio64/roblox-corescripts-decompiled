local ended = game:GetEngineFeature("VoiceChatSupported") and Enum.VoiceChatState.Ended or nil

local v = { voiceEnabled = false, voiceState = ended }

local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local context = React.createContext(v)
local VoiceStateContext = {}

function VoiceStateContext.Provider(p)
	local state, setState = React.useState(v)

	local function updateVoiceState(_, voiceState) -- 2 equivalent calls inferred from this helper
		if voiceState ~= state.voiceState then
			setState({
				voiceEnabled = voiceState ~= Enum.VoiceChatState.Ended,
				voiceState = voiceState
			})
		end
	end

	React.useEffect(function()
		local flag = true
		local stateChangedConnection = nil

		if game:GetEngineFeature("VoiceChatSupported") then
			default:asyncInit():andThen(function()
				if flag then
					default:SetupParticipantListeners()
					local service = default:getService()

					if service then
						updateVoiceState(nil, service.VoiceChatState) -- inferred equivalent call
						stateChangedConnection = service.StateChanged:Connect(updateVoiceState)
					end
				end
			end):catch(function()
				updateVoiceState(nil, ended) -- inferred equivalent call
			end)
		end

		return function()
			flag = false

			if stateChangedConnection then
				stateChangedConnection:Disconnect()
				stateChangedConnection = nil
			end
		end
	end, {})

	return React.createElement(context.Provider, { value = state }, p.children)
end

VoiceStateContext.Consumer = context.Consumer
VoiceStateContext.Context = context

function VoiceStateContext.withVoiceState(render)
	return React.createElement(context.Consumer, { render = render })
end

return VoiceStateContext
