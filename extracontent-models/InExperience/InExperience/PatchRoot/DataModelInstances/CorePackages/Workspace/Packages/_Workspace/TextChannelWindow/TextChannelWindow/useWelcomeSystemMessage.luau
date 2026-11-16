local parent = script.Parent.Parent

local Players = game:GetService("Players")

local React = require(parent.React)
local Message = require(script.Parent.Message)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local getWhisperChannelOtherDisplayName = require(script.Parent.getWhisperChannelOtherDisplayName)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local useInExperienceLocalization = ChatUIPrimitives.Hooks.useInExperienceLocalization

local FFlagExpChatTextChannelWindowWelcomeAndSummary = require(script.Parent.Flags.FFlagExpChatTextChannelWindowWelcomeAndSummary)

local object = setmetatable({}, { __mode = "k" })

local function isWhisperChannel(p): boolean -- 1 equivalent call inferred from this helper
	return string.find(p.Name, "^RBXWhisper") ~= nil
end

local function useWelcomeSystemMessage(p, p2: string)
	local v = MessageWriterContext.useMessageWriter()
	local v2 = useInExperienceLocalization()

	React.useEffect(function()
		if not FFlagExpChatTextChannelWindowWelcomeAndSummary or (not v or p == nil) then
			return
		end

		local v3 = p

		if not isWhisperChannel(v3) or object[v3] then -- inferred equivalent call
			return
		end

		local function trySend(): boolean
			if object[v3] then
				return true
			end

			local whisperChannelOtherDisplayName = getWhisperChannelOtherDisplayName(v3, p2)

			if not whisperChannelOtherDisplayName then
				return false
			end

			local v4 = v2("CoreScripts.TextChat.Notification.WhisperChat.Created", {
				RBX_NAME = whisperChannelOtherDisplayName
			})

			if v4 == "" then
				return false
			end

			object[v3] = true
			v.write(Message.createSystemMessage(v4, "Roblox.Whisper.Welcome.Sent:" .. v3.Name))
			return true
		end

		if trySend() then
			return
		end

		local childAddedConnection = nil
		local playerAddedConnection = nil
		local function cleanup() -- 1 equivalent call inferred from this helper
			childAddedConnection:Disconnect()
			playerAddedConnection:Disconnect()
		end
		local function retry()
			if trySend() then
				cleanup() -- inferred equivalent call
			end
		end
		childAddedConnection = v3.ChildAdded:Connect(retry)
		playerAddedConnection = Players.PlayerAdded:Connect(retry)
		return cleanup
	end, { v, v2, p, p2 })
end

return useWelcomeSystemMessage
