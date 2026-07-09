local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local Signals = require(ChatUIPrimitivesParent.Signals)
local SignalsReact = require(ChatUIPrimitivesParent.SignalsReact)
local Foundation = require(ChatUIPrimitivesParent.Foundation)

require(ChatUIPrimitives.Types)

local useStableSignal = require(ChatUIPrimitives.Hooks.useStableSignal)
local RewriteToggle = require(script.Parent.RewriteToggle)
local useSignalBinding = SignalsReact.useSignalBinding

local function TextLineEntry(t1: {[any]: any}) -- line: 23
	-- upvalues: Foundation (copy), React (copy), Signals (copy), useStableSignal (copy), SignalsReact (copy), useSignalBinding (copy), RewriteToggle (copy)
	local v12 = Foundation.Hooks.useTokens()
	local v13 = React.useMemo(function() -- line: 28
		-- upvalues: v12 (copy)
		local MutedColor3 = v12.DarkMode.Content.Muted.Color3

		return string.format("<font color=\"rgb(%d,%d,%d)\">", math.round(MutedColor3.R * 255), math.round(MutedColor3.G * 255), (math.round(MutedColor3.B * 255)))
	end, { v12 })
	local v14 = React.useMemo(function() -- line: 38
		-- upvalues: Signals (copy), t1 (copy)
		return Signals.createComputed(function(p1) -- line: 39
			-- upvalues: t1 (copy)
			local v29 = t1.getMessageId(p1)

			if not v29 then
				return nil
			end

			return t1.getMessagesMap(p1)[v29]
		end)
	end, {
		t1.getMessageId,
		t1.getMessagesMap
	})
	local v15, v16 = useStableSignal(false)
	local v17 = SignalsReact.useSignalState(t1.getMessageId)

	React.useEffect(function() -- line: 53
		-- upvalues: v16 (copy)
		v16(false)
	end, {
		v17,
		v16
	})

	local v18 = useSignalBinding(v14)
	local v19 = useSignalBinding(t1.getLayoutOrder)
	local v20 = SignalsReact.useSignalState(v15)
	local v21 = v18:map(function(p2) -- line: 61
		return p2 ~= nil
	end)
	local v22 = v18:map(function(p3) -- line: 68
		-- upvalues: v13 (copy)
		if not p3 then
			return ""
		end

		local v27 = p3.prefixText or ""

		if p3.messageType == "user" then
			return v27 .. " " .. p3.content
		end

		if p3.messageType == "system-roblox" then
			return p3.content
		end

		return v13 .. p3.content .. "</font>"
	end)
	local v23 = React.useCallback(function() -- line: 82
		-- upvalues: v16 (copy), v15 (copy)
		v16(not v15())
	end, {
		v15,
		v16
	})

	return React.createElement(Foundation.View, {
		tag = "col gap-xsmall auto-y",
		Size = UDim2.new(1, 0, 0, 0),
		backgroundStyle = {
			Transparency = 1,
			Color3 = Color3.new(0, 0, 0)
		},
		LayoutOrder = v19,
		Visible = v21
	}, {
		label = React.createElement(Foundation.Text, {
			tag = "text-body-large text-wrap text-align-x-left text-align-y-top content-emphasis",
			RichText = true,
			LayoutOrder = 1,
			Text = v22,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}),
		rewriteToggle = React.createElement(RewriteToggle, {
			LayoutOrder = 2,
			messageBinding = v18,
			showOriginal = v20,
			onToggle = v23
		})
	})
end

return React.memo(TextLineEntry)
