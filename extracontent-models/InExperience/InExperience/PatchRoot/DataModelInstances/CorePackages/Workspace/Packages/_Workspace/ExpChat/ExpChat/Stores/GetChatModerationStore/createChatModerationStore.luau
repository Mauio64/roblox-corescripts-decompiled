local Chat = game:GetService("Chat")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local parent = script:FindFirstAncestor("ExpChat").Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local GetChatStatusStore = require(script.Parent.Parent.GetChatStatusStore)

local engineFeature = game:GetEngineFeature("EnableChatModerationModeLoggingRefactor")

return function()
	local signal, v = createSignal(false)
	local signal2, v2 = createSignal(false)
	local chatStatusStore = GetChatStatusStore(false)

	local moderateChatSettingUpdated = nil

	local function setIsSettingEnabled(flag: boolean) -- 1 equivalent call inferred from this helper
		if engineFeature then
			Chat:RequestModerationModeEnabled(flag)
		elseif moderateChatSettingUpdated then
			moderateChatSettingUpdated:FireServer(flag)
		end
	end

	local function initialize()
		setIsSettingEnabled(false) -- inferred equivalent call
	end

	local moderationModeChangedConnection = nil

	if engineFeature then
		local function fn() -- 1 equivalent call inferred from this helper
			v(Chat.ModerationMode ~= "Unsupported")
			v2(Chat.ModerationMode == "Enabled")
		end
		moderationModeChangedConnection = Chat:GetPropertyChangedSignal("ModerationMode"):Connect(fn)
		fn() -- inferred equivalent call
	else
		coroutine.wrap(function()
			moderateChatSettingUpdated = RobloxReplicatedStorage:WaitForChild("ModerateChatSettingUpdated", 10)

			if moderateChatSettingUpdated then
				moderateChatSettingUpdated.OnClientEvent:Connect(function(flag: boolean)
					v(true)
					v2(flag)
				end)
			end
		end)()
	end

	return {
		getIsSettingVisible = createComputed(function(p)
			return signal(p) and chatStatusStore.getChatStatus(p) == "Enabled"
		end),
		getIsSettingEnabled = createComputed(function(p)
			return signal2(p) and chatStatusStore.getChatStatus(p) == "Enabled"
		end),
		setIsSettingEnabled = setIsSettingEnabled,
		initialize = initialize,
		cleanup = function()
			if moderationModeChangedConnection then
				moderationModeChangedConnection:Disconnect()
				moderationModeChangedConnection = nil
			end
		end
	}
end
