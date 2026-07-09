local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local BuilderIcons = require(AppChatParent.BuilderIcons)
local Cryo = require(AppChatParent.Cryo)
local OptionsEnum = require(script.Parent.OptionsEnum)
local FFlagAppChatEnableMessageContextMenu = require(AppChat.Flags.FFlagAppChatEnableMessageContextMenu)
local t1 = {
	LayoutOrder = 1,
	isIncoming = false,
	handleEvent = function(_, _, _) -- line: 22
	end,
	emitImpressionTelemetryEvent = function() -- line: 23
	end
}

function Options(t2: {[any]: any}) -- line: 35
	-- upvalues: Cryo (copy), t1 (copy), React (copy), OptionsEnum (copy), Foundation (copy), BuilderIcons (copy), FFlagAppChatEnableMessageContextMenu (copy)
	local v14 = Cryo.Dictionary.union(t1, t2)

	React.useEffect(function() -- line: 38
		-- upvalues: v14 (copy)
		v14.emitImpressionTelemetryEvent()
	end, {})

	local v15 = React.useCallback(function() -- line: 42
		-- upvalues: v14 (copy), React (copy), OptionsEnum (copy)
		v14.handleEvent(React.Event.Activated, nil, OptionsEnum.Reply)
	end, { v14.handleEvent })
	local v16 = React.useCallback(function() -- line: 46
		-- upvalues: v14 (copy), React (copy), OptionsEnum (copy)
		v14.handleEvent(React.Event.Activated, nil, OptionsEnum.MessageContextMenu)
	end, { v14.handleEvent })

	return React.createElement(Foundation.View, {
		tag = "row auto-xy gap-xxsmall",
		LayoutOrder = v14.LayoutOrder
	}, {
		Reply = React.createElement(Foundation.IconButton, {
			isCircular = true,
			onActivated = v15,
			icon = BuilderIcons.Icon.ArrowThickToRight,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Medium,
			LayoutOrder = not v14.isIncoming and -1 or 1
		}),
		MessageContextMenu = if not FFlagAppChatEnableMessageContextMenu then nil else React.createElement(Foundation.IconButton, {
			isCircular = true,
			onActivated = v16,
			icon = BuilderIcons.Icon.ThreeDotsHorizontal,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.InputSize.Medium,
			LayoutOrder = not v14.isIncoming and -2 or 2
		})
	})
end

return React.memo(Options)
