local parent = script.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local TextChannelWindowAnalytics = require(script.Parent.TextChannelWindowAnalytics)
local useTranslationToggleAvailable = require(script.Parent.useTranslationToggleAvailable)
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local useInExperienceLocalization = ChatUIPrimitives2.Hooks.useInExperienceLocalization

local FFlagTCWTranslationSupport = ChatUIPrimitives.Flags.FFlagTCWTranslationSupport

local MessageLayoutContainer = ChatUIPrimitives.MessageLayoutContainer

local function MessageListArea(props)
	local v = Foundation.Hooks.useTokens()
	local v2 = useInExperienceLocalization()
	local isTranslationSettingEnabled

	if FFlagTCWTranslationSupport then
		isTranslationSettingEnabled = useTranslationToggleAvailable()
	end

	local onScroll = React.useMemo(function()
		return TextChannelWindowAnalytics.createOnScrollCallback(props.windowName)
	end, { props.windowName })

	local contentPadding = React.useMemo(function()
		return {
			top = UDim.new(0, v.Size.Size_100),
			bottom = UDim.new(0, v.Size.Size_100),
			left = UDim.new(0, v.Size.Size_200),
			right = UDim.new(0, v.Size.Size_1400)
		}
	end, { v.Size.Size_100, v.Size.Size_200, v.Size.Size_1400 })

	if props.channelState == "no-channel" then
		return React.createElement(Foundation.Empty, {
			icon = { name = "icons/status/oof_xlarge" },
			text = v2("CoreScripts.TextChat.Error.NoChannelSelected")
		})
	end

	if props.channelState == "not-member" then
		return React.createElement(Foundation.Empty, {
			icon = { name = "icons/status/oof_xlarge" },
			text = v2("CoreScripts.TextChat.Error.NoChannelAccess")
		})
	end

	if props.channelState == "member" then
		return React.createElement(MessageLayoutContainer, {
			messagesSignal = props.messagesSignal,
			layoutStyle = "textLine",
			fontFace = props.fontFace,
			Size = UDim2.fromScale(1, 1),
			contentPadding = contentPadding,
			onScroll = onScroll,
			selectableRows = props.selectableRows,
			selectionCursor = props.selectionCursor,
			isTranslationSettingEnabled = isTranslationSettingEnabled,
			onLatestUsernameChanged = props.onLatestUsernameChanged
		})
	end

	return React.createElement(Foundation.Empty, {
		icon = { name = "icons/status/oof_xlarge" },
		text = v2("CoreScripts.TextChat.InputBar.Hint.ChatUnavailable")
	})
end

return React.memo(MessageListArea)
