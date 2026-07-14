local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local ChatUIPrimitives = require(ParentParent.ChatUIPrimitives)
local useInExperienceLocalization = require(script.Parent.useInExperienceLocalization)
local useCanSendToChannel = require(script.Parent.useCanSendToChannel).useCanSendToChannel
local Logger = require(script.Parent.Logger)
local Message = require(script.Parent.Message)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local runVirtualChatCommands = require(script.Parent.runVirtualChatCommands)
local getFFlagExpChatProtectedChatInternalAPIs = require(ParentParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs
local getFFlagExpChatUseChatMuteStore = require(script.Parent.getFFlagExpChatUseChatMuteStore)
local ChatInputBarView = ChatUIPrimitives.ChatInputBarView

local function TextChatWindowInputBarHost(t1: {[any]: any}) -- line: 27
	-- upvalues: Foundation (copy), useCanSendToChannel (copy), useInExperienceLocalization (copy), React (copy), MessageWriterContext (copy), getFFlagExpChatUseChatMuteStore (copy), runVirtualChatCommands (copy), Message (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), Logger (copy), ChatInputBarView (copy)
	local targetChannel = t1.targetChannel
	local v17 = Foundation.Hooks.useTokens()
	local v18 = useCanSendToChannel(targetChannel, t1.localUserId)
	local v19 = useInExperienceLocalization()
	local v20 = React.useMemo(function() -- line: 34
		-- upvalues: v19 (copy)
		return {
			placeholder = v19("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v19("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled"),
			chatUnavailable = v19("CoreScripts.TextChat.InputBar.Hint.ChatUnavailable"),
			readOnly = v19("CoreScripts.TextChat.Error.ReadOnlyChannel")
		}
	end, { v19 })
	local v21 = MessageWriterContext.useMessageWriter()
	local v22 = React.useCallback(function(s1: string) -- line: 45
		-- upvalues: v18 (copy), targetChannel (copy), getFFlagExpChatUseChatMuteStore (copy), t1 (copy), runVirtualChatCommands (copy), v21 (copy), Message (copy), v19 (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), Logger (copy)
		if not v18 then
			return
		end

		if targetChannel and s1 ~= "" then
			if getFFlagExpChatUseChatMuteStore() and t1.localUserId then
				local v27 = runVirtualChatCommands(s1, t1.localUserId)

				if v27 then
					if v21 then
						v21.write(Message.createSystemMessage(v19(v27.key, if not next(v27.args) then nil else v27.args)))
					end

					return
				end
			end

			task.spawn(function() -- line: 66
				-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), targetChannel (copy), s1 (copy), Logger (copy)
				local ok, result = pcall(function() -- line: 67
					-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), targetChannel (copy), s1 (copy)
					if getFFlagExpChatProtectedChatInternalAPIs() then
						targetChannel:SendInternalAsync(s1)

						return
					end

					targetChannel:SendAsync(s1)
				end)

				if not ok then
					Logger:warning("SendAsync failed: {}", result)
				end
			end)
		end
	end, {
		targetChannel,
		v18,
		v19,
		t1.localUserId,
		v21
	})
	local v23 = (t1.canLocalUserChat == nil or t1.canLocalUserChat) and (targetChannel ~= nil and v18)
	local v24 = if targetChannel ~= nil then if v18 then v20.disabled else v20.readOnly else v20.chatUnavailable
	local v25 = React.useMemo(function() -- line: 100
		return {
			commands = nil,
			emojis = true
		}
	end, {})

	return React.createElement(ChatInputBarView, {
		maximumCharacterLimit = 200,
		onSend = v22,
		canLocalUserChat = v23,
		textSize = v17.Typography.CaptionMedium.FontSize,
		placeholderText = v20.placeholder,
		disabledChatPlaceholderText = v24,
		autocomplete = v25
	})
end

return TextChatWindowInputBarHost
