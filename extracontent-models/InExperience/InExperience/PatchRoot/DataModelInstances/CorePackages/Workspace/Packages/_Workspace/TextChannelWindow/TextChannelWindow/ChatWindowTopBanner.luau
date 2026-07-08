local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection
local Foundation = require(ParentParent.Foundation)

require(ParentParent.Signals)

local ChatLineReporting = require(ParentParent.ChatLineReporting)
local ChatLineReportRoot = ChatLineReporting.ChatLineReportRoot
local Constants = ChatLineReporting.Constants
local useInExperienceLocalization = require(script.Parent.useInExperienceLocalization)
local View = Foundation.View
local Icon = Foundation.Icon
local Menu = Foundation.Menu
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local function mapMessagesForReport(t1: {[any]: any}, p1) -- line: 35
	local t2 = table.create(#t1)

	for _, v24 in t1 do
		if v24.messageType == "user" then
			table.insert(t2, {
				userId = v24.senderUserId,
				text = v24.content,
				textChannel = p1,
				messageId = v24.messageId,
				prefixText = v24.prefixText
			})
		end
	end

	return t2
end
local function ChatWindowTopBanner(t3: {[any]: any}) -- line: 51
	-- upvalues: useInExperienceLocalization (copy), React (copy), useEventConnection (copy), GuiService (copy), ChatLineReportRoot (copy), mapMessagesForReport (copy), IconName (copy), Constants (copy), Menu (copy), InputSize (copy), PopoverSide (copy), PopoverAlign (copy), View (copy), Icon (copy), IconSize (copy)
	local v26 = useInExperienceLocalization()
	local v27, v28 = React.useState(false)

	useEventConnection(GuiService:GetPropertyChangedSignal("MenuIsOpen"), function() -- line: 55
		-- upvalues: GuiService (copy), v28 (copy)
		if GuiService.MenuIsOpen then
			v28(false)
		end
	end)

	local v29 = v26("Feature.ReportAbuse.Action.EnterChatLineReporting")
	local v30 = React.useCallback(function() -- line: 63
		-- upvalues: v28 (copy), v27 (copy)
		v28(not v27)
	end, { v27 })
	local v31 = React.useCallback(function() -- line: 67
		-- upvalues: v28 (copy)
		v28(false)
	end, {})
	local v32 = React.useCallback(function() -- line: 71
		-- upvalues: t3 (copy), ChatLineReportRoot (copy), mapMessagesForReport (copy), v28 (copy)
		local v34 = if not t3.messagesSignal then {} else t3.messagesSignal(false)

		ChatLineReportRoot.initialize((mapMessagesForReport(v34, t3.targetChannel)))
		v28(false)
	end, {
		t3.messagesSignal,
		t3.targetChannel
	})
	local v33 = React.useMemo(function() -- line: 77
		-- upvalues: IconName (copy), v29 (copy), v32 (copy)
		return {{
			id = "report",
			icon = IconName.SpeechBubbleExclamation,
			text = v29,
			onActivated = v32
		}}
	end, {
		v29,
		v32
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Constants.TopBannerSize),
		ZIndex = t3.ZIndex
	}, {
		Menu = React.createElement(Menu, {
			isOpen = v27,
			items = v33,
			size = InputSize.Medium,
			side = PopoverSide.Right,
			align = PopoverAlign.Start,
			onPressedOutside = v31,
			Position = UDim2.new(1, Constants.IconButtonPositionXOffset, 0, 0)
		}, {
			Button = React.createElement(View, {
				tag = "align-x-center align-y-center radius-medium",
				Size = UDim2.fromOffset(Constants.IconButtonSize, Constants.IconButtonSize),
				onActivated = v30
			}, {
				icon = React.createElement(Icon, {
					name = IconName.ThreeDotsHorizontal,
					size = IconSize.Large
				})
			})
		})
	})
end

return ChatWindowTopBanner
