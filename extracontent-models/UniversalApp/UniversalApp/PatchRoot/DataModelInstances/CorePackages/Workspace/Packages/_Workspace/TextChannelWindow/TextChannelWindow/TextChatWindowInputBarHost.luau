local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local ChatUIPrimitives = require(ParentParent.ChatUIPrimitives)
local useInExperienceLocalization = require(script.Parent.useInExperienceLocalization)
local useCanSendToChannel = require(script.Parent.useCanSendToChannel).useCanSendToChannel
local Logger = require(script.Parent.Logger)
local getFFlagExpChatProtectedChatInternalAPIs = require(ParentParent.SharedFlags).getFFlagExpChatProtectedChatInternalAPIs
local ChatInputBarView = ChatUIPrimitives.ChatInputBarView

local function TextChatWindowInputBarHost(t1: {[any]: any}) -- line: 23
	-- upvalues: Foundation (copy), useCanSendToChannel (copy), useInExperienceLocalization (copy), React (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), Logger (copy), ChatInputBarView (copy)
	local targetChannel = t1.targetChannel
	local v13 = Foundation.Hooks.useTokens()
	local v14 = useCanSendToChannel(targetChannel, t1.localUserId)
	local v15 = useInExperienceLocalization()
	local v16 = React.useMemo(function() -- line: 30
		-- upvalues: v15 (copy)
		return {
			placeholder = v15("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v15("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled"),
			viewOnly = v15("CoreScripts.TextChat.ChatWindow.ChatDisabled.OnlyViewSystemMessages")
		}
	end, { v15 })
	local v17 = React.useCallback(function(s1: string) -- line: 38
		-- upvalues: v14 (copy), targetChannel (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), Logger (copy)
		if not v14 then
			return
		end

		if targetChannel and s1 ~= "" then
			task.spawn(function() -- line: 43
				-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), targetChannel (copy), s1 (copy), Logger (copy)
				local ok, result = pcall(function() -- line: 44
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
		v14
	})
	local v18 = t1.canLocalUserChat == nil or t1.canLocalUserChat
	local v19 = v18 and not v14
	local v20 = v18 and v14
	local v21 = if not v19 then v16.disabled else v16.viewOnly

	return React.createElement(ChatInputBarView, {
		maximumCharacterLimit = 200,
		onSend = v17,
		canLocalUserChat = v20,
		textSize = v13.Typography.CaptionMedium.FontSize,
		placeholderText = v16.placeholder,
		disabledChatPlaceholderText = v21
	})
end

return TextChatWindowInputBarHost
