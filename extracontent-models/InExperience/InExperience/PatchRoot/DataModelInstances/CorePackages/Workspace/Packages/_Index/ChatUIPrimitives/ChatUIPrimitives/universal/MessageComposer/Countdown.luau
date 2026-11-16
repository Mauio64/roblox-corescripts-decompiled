local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local RunService = game:GetService("RunService")

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local useRobloxLocale = require(ChatUIPrimitives.Hooks.useRobloxLocale)

local function formatRemaining(untilTimestamp: number, p: string) -- 1 equivalent call inferred from this helper
	local v = math.max(math.floor(untilTimestamp - DateTime.now().UnixTimestamp), 0)
	local v2 = v >= 3600 and "HH:mm:ss" or "m:ss"
	return DateTime.fromUnixTimestamp(v):FormatUniversalTime(v2, p)
end

local function Countdown(props)
	local v = useRobloxLocale()
	local untilTimestamp = props.untilTimestamp
	local testHeartbeat = props.testHeartbeat or RunService.Heartbeat
	local text, v2 = React.useBinding(formatRemaining(untilTimestamp, v))

	useEventConnection(testHeartbeat, (React.useCallback(function()
		local v3 = formatRemaining(untilTimestamp, v) -- inferred equivalent call

		if v3 ~= text:getValue() then
			v2(v3)
		end
	end, { untilTimestamp, v, text, v2 })))

	return React.createElement(Foundation.Text, {
		tag = "auto-xy text-title-medium text-no-wrap content-default",
		Text = text,
		testId = "countdown",
		LayoutOrder = props.LayoutOrder
	})
end

return Countdown
