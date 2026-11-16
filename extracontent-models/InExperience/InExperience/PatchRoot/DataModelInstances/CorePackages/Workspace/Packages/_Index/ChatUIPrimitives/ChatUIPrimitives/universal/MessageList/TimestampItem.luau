local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useRobloxLocale = require(ChatUIPrimitives.Hooks.useRobloxLocale)
require(script.Parent.groupMessages)
local formatTimestamp = require(script.Parent.formatTimestamp)
local Sizing = require(script.Parent.Parent.Sizing)
local FFlagExpChatLocalizeMessageTimestamp = require(ChatUIPrimitives.Flags.FFlagExpChatLocalizeMessageTimestamp)

local function TimestampText(p)
	local v = Sizing.useSizing()
	local tag = Foundation.Hooks.useDefaultTags(v.timestamp.tag, "size-full-0 auto-y text-align-x-center")
	return React.createElement(Foundation.Text, { tag = tag, Text = p.label })
end

local function TimestampItemLocalized(p)
	local v = useRobloxLocale()
	local itemSignal = p.itemSignal
	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local v2 = itemSignal(p2)
			return formatTimestamp(v2.displayUnixMilliseconds, v2.referenceUnixMilliseconds, v)
		end)
	end, { itemSignal, v })
	local label = SignalsReact.useSignalBinding(v2)
	return React.createElement(TimestampText, { label = label })
end

local function TimestampItemDefault(p)
	local label = SignalsReact.useSignalBinding(function(p2)
		local itemSignal = p.itemSignal(p2)
		return formatTimestamp(itemSignal.displayUnixMilliseconds, itemSignal.referenceUnixMilliseconds)
	end)

	return React.createElement(TimestampText, { label = label })
end

if FFlagExpChatLocalizeMessageTimestamp then
	return TimestampItemLocalized
end

return TimestampItemDefault
