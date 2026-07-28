local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local ChatUIPrimitives = require(ParentParent.ChatUIPrimitives)
local TextChannelWindowAnalytics = require(script.Parent.TextChannelWindowAnalytics)
local useInExperienceLocalization = require(script.Parent.useInExperienceLocalization)
local useCanSendToChannel = require(script.Parent.useCanSendToChannel).useCanSendToChannel
local Logger = require(script.Parent.Logger)
local Message = require(script.Parent.Message)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local runVirtualChatCommands = require(script.Parent.runVirtualChatCommands)
local getFFlagExpChatProtectedChatInternalAPIs = require(ParentParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs
local getFFlagExpChatUseChatMuteStore = require(script.Parent.getFFlagExpChatUseChatMuteStore)
local ChatInputBarView = ChatUIPrimitives.ChatInputBarView

local function TextChatWindowInputBarHost(t1: {[any]: any}) -- line: 29
	-- upvalues: Foundation (copy), useCanSendToChannel (copy), useInExperienceLocalization (copy), React (copy), MessageWriterContext (copy), getFFlagExpChatUseChatMuteStore (copy), runVirtualChatCommands (copy), Message (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), TextChannelWindowAnalytics (copy), Logger (copy), ChatInputBarView (copy)
	local targetChannel = t1.targetChannel
	local v18 = Foundation.Hooks.useTokens()
	local v19 = useCanSendToChannel(targetChannel, t1.localUserId)
	local v20 = useInExperienceLocalization()
	local v21 = React.useMemo(function() -- line: 36
		-- upvalues: v20 (copy)
		return {
			placeholder = v20("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v20("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled"),
			chatUnavailable = v20("CoreScripts.TextChat.InputBar.Hint.ChatUnavailable"),
			readOnly = v20("CoreScripts.TextChat.Error.ReadOnlyChannel")
		}
	end, { v20 })
	local v22 = MessageWriterContext.useMessageWriter()
	local v23 = if not targetChannel then nil else targetChannel.Name
	local v24 = React.useCallback(function(s1: string) -- line: 49
		-- upvalues: v19 (copy), targetChannel (copy), getFFlagExpChatUseChatMuteStore (copy), t1 (copy), runVirtualChatCommands (copy), v22 (copy), Message (copy), v20 (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), TextChannelWindowAnalytics (copy), v23 (copy), Logger (copy)
		if not v19 then
			return
		end

		if targetChannel and s1 ~= "" then
			if getFFlagExpChatUseChatMuteStore() and t1.localUserId then
				local v29 = runVirtualChatCommands(s1, t1.localUserId)

				if v29 then
					if v22 then
						v22.write(Message.createSystemMessage(v20(v29.key, if not next(v29.args) then nil else v29.args)))
					end

					return
				end
			end

			task.spawn(function() -- line: 70
				-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), targetChannel (copy), s1 (copy), TextChannelWindowAnalytics (copy), v23 (copy), Logger (copy)
				local ok, result = pcall(function() -- line: 71
					-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), targetChannel (copy), s1 (copy)
					if getFFlagExpChatProtectedChatInternalAPIs() then
						targetChannel:SendInternalAsync(s1)

						return
					end

					targetChannel:SendAsync(s1)
				end)

				if ok then
					TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Send, {
						result = "success",
						has_target = v23 ~= nil,
						target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(v23)
					})

					return
				end

				Logger:warning("SendAsync failed: {}", result)
				TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Send, {
					result = "failure",
					has_target = v23 ~= nil,
					target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(v23)
				})
			end)
		end
	end, {
		targetChannel,
		v19,
		v20,
		t1.localUserId,
		v22,
		v23
	})
	local v25 = (t1.canLocalUserChat == nil or t1.canLocalUserChat) and (targetChannel ~= nil and v19)
	local v26 = if targetChannel ~= nil then if v19 then v21.disabled else v21.readOnly else v21.chatUnavailable
	local v27 = React.useMemo(function() -- line: 117
		return {
			commands = nil,
			emojis = true
		}
	end, {})

	return React.createElement(ChatInputBarView, {
		maximumCharacterLimit = 200,
		onSend = v24,
		canLocalUserChat = v25,
		textSize = v18.Typography.CaptionMedium.FontSize,
		placeholderText = v21.placeholder,
		disabledChatPlaceholderText = v26,
		autocomplete = v27
	})
end

return TextChatWindowInputBarHost
