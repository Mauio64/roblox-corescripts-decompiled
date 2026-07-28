local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local Signals = require(ChatUIPrimitivesParent.Signals)
local SignalsReact = require(ChatUIPrimitivesParent.SignalsReact)
local Foundation = require(ChatUIPrimitivesParent.Foundation)

require(ChatUIPrimitives.Types)

local useStableSignal = require(ChatUIPrimitives.Hooks.useStableSignal)
local RewriteToggle = require(script.Parent.RewriteToggle)
local TextChannelWindowPerfTracker = require(ChatUIPrimitives.Telemetry.TextChannelWindowPerfTracker)
local useSignalBinding = SignalsReact.useSignalBinding

local function TextLineEntry(t1: {[any]: any}) -- line: 24
	-- upvalues: Foundation (copy), React (copy), Signals (copy), useStableSignal (copy), SignalsReact (copy), TextChannelWindowPerfTracker (copy), useSignalBinding (copy), RewriteToggle (copy)
	local v13 = Foundation.Hooks.useTokens()
	local v14 = React.useMemo(function() -- line: 29
		-- upvalues: v13 (copy)
		local MutedColor3 = v13.DarkMode.Content.Muted.Color3

		return string.format("<font color=\"rgb(%d,%d,%d)\">", math.round(MutedColor3.R * 255), math.round(MutedColor3.G * 255), (math.round(MutedColor3.B * 255)))
	end, { v13 })
	local v15 = React.useMemo(function() -- line: 39
		-- upvalues: Signals (copy), t1 (copy)
		return Signals.createComputed(function(p1) -- line: 40
			-- upvalues: t1 (copy)
			local v30 = t1.getMessageId(p1)

			if not v30 then
				return nil
			end

			return t1.getMessagesMap(p1)[v30]
		end)
	end, {
		t1.getMessageId,
		t1.getMessagesMap
	})
	local v16, v17 = useStableSignal(false)
	local v18 = SignalsReact.useSignalState(t1.getMessageId)

	React.useEffect(function() -- line: 54
		-- upvalues: v17 (copy)
		v17(false)
	end, {
		v18,
		v17
	})
	React.useEffect(function() -- line: 57
		-- upvalues: v18 (copy), TextChannelWindowPerfTracker (copy)
		if v18 then
			TextChannelWindowPerfTracker.finishMessageIntervals(v18)
		end
	end, { v18 })

	local v19 = useSignalBinding(v15)
	local v20 = useSignalBinding(t1.getLayoutOrder)
	local v21 = SignalsReact.useSignalState(v16)
	local v22 = v19:map(function(p2) -- line: 67
		return p2 ~= nil
	end)
	local v23 = v19:map(function(p3) -- line: 74
		-- upvalues: v14 (copy)
		if not p3 then
			return ""
		end

		local v28 = p3.prefixText or ""

		if p3.messageType == "user" then
			return v28 .. " " .. p3.content
		end

		if p3.messageType == "system-roblox" then
			return p3.content
		end

		return v14 .. p3.content .. "</font>"
	end)
	local v24 = React.useCallback(function() -- line: 88
		-- upvalues: v17 (copy), v16 (copy)
		v17(not v16())
	end, {
		v16,
		v17
	})

	return React.createElement(Foundation.View, {
		tag = "col gap-xsmall auto-y",
		Size = UDim2.new(1, 0, 0, 0),
		backgroundStyle = {
			Transparency = 1,
			Color3 = Color3.new(0, 0, 0)
		},
		LayoutOrder = v20,
		Visible = v22
	}, {
		label = React.createElement(Foundation.Text, {
			tag = "text-body-large text-wrap text-align-x-left text-align-y-top content-emphasis",
			RichText = true,
			LayoutOrder = 1,
			Text = v23,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}),
		rewriteToggle = React.createElement(RewriteToggle, {
			LayoutOrder = 2,
			messageBinding = v19,
			showOriginal = v21,
			onToggle = v24
		})
	})
end

return React.memo(TextLineEntry)
