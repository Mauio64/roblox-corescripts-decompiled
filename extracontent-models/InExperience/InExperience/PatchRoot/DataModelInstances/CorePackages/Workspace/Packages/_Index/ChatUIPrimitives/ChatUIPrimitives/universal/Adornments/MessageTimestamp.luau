local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useInExperienceLocalization = require(ChatUIPrimitives.Hooks.useInExperienceLocalization)
local useRobloxLocale = require(ChatUIPrimitives.Hooks.useRobloxLocale)
local formatTimestamp = require(script.Parent.Parent.MessageList.formatTimestamp)
local getRelativeTimestampLabel = require(script.Parent.getRelativeTimestampLabel)
local MessageClockContext = require(script.Parent.MessageClockContext)
local useMessageClock = require(script.Parent.useMessageClock)
local TimestampFormatContext = require(script.Parent.TimestampFormatContext)

local function MessageTimestamp(props)
	local v = useInExperienceLocalization()
	local v2 = useRobloxLocale()
	local v3 = React.useContext(MessageClockContext)
	local v4 = useMessageClock({
		enabled = v3 == nil
	})

	if v3 == nil then
		v3 = v4
	end

	local getSentAtUnixMilliseconds = props.getSentAtUnixMilliseconds
	local v5 = React.useContext(TimestampFormatContext) == "absolute"

	local v6 = React.useMemo(function()
		local function formatAbsolute(sentAtUnixMilliseconds: number, p: number)
			return formatTimestamp(sentAtUnixMilliseconds, p, v2)
		end

		return Signals.createComputed(function(p)
			local sentAtUnixMilliseconds = getSentAtUnixMilliseconds(p)
			local v6 = v3(p)

			if v5 then
				return formatAbsolute(sentAtUnixMilliseconds, v6)
			end

			return getRelativeTimestampLabel(sentAtUnixMilliseconds, v6, v, formatAbsolute)
		end)
	end, { getSentAtUnixMilliseconds, v3, v, v2, v5 })
	local text = SignalsReact.useSignalBinding(v6)

	local tag = Foundation.Hooks.useDefaultTags(props.tag, "auto-xy")
	return React.createElement(Foundation.Text, {
		tag = tag,
		Text = text,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return React.memo(MessageTimestamp)
