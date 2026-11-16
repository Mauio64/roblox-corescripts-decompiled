local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local Foundation = require(parent.Foundation)
require(parent.Signals)
local ChatLineReporting = require(parent.ChatLineReporting)
local ChatLineReportRoot = ChatLineReporting.ChatLineReportRoot
local Constants = ChatLineReporting.Constants

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local useInExperienceLocalization = ChatUIPrimitives.Hooks.useInExperienceLocalization
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local useDismissOnEscapeOrMenu = ChatUIPrimitives2.Hooks.useDismissOnEscapeOrMenu
local ReportMenuFocusRoot = require(script.Parent.ReportMenuFocusRoot)
local FFlagExpChatTextChannelWindowFocusNav = require(script.Parent.Flags.FFlagExpChatTextChannelWindowFocusNav)

local v = {
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop
}

local View = Foundation.View
local Icon = Foundation.Icon
local Menu = Foundation.Menu
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local function mapMessagesForReport(list, targetChannel)
	local result = table.create(#list)

	for _, item in list do
		if item.messageType == "user" then
			table.insert(result, {
				userId = item.senderUserId,
				text = item.content,
				textChannel = targetChannel,
				messageId = item.messageId,
				prefixText = item.prefixText
			})
		end
	end

	return result
end

local function TopBannerView(props)
	useDismissOnEscapeOrMenu(props.focusNavEnabled == true and props.isOpen, props.onPressedOutside)

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 0, Constants.TopBannerSize),
		BackgroundTransparency = 1,
		ZIndex = props.ZIndex
	}

	local createElement2 = React.createElement
	local v3 = {
		isOpen = props.isOpen,
		items = props.items,
		size = InputSize.Medium,
		side = PopoverSide.Right,
		align = PopoverAlign.Start,
		onPressedOutside = props.onPressedOutside,
		Position = UDim2.new(1, Constants.IconButtonPositionXOffset, 0, 0),
		ref = 0,
		selectionGroup = 0
	}
	local ref

	if props.focusNavEnabled then
		ref = props.menuContentRef
	end

	v3.ref = ref
	local selectionGroup

	if props.focusNavEnabled then
		selectionGroup = v
	end

	v3.selectionGroup = selectionGroup

	local createElement3 = React.createElement
	local v4 = {
		Size = UDim2.fromOffset(Constants.IconButtonSize, Constants.IconButtonSize),
		tag = "align-x-center align-y-center radius-medium",
		onActivated = props.onTriggerActivated,
		ref = 0
	}
	local ref2

	if props.focusNavEnabled then
		ref2 = props.triggerRef
	end

	v4.ref = ref2
	return createElement("Frame", v2, {
		Menu = createElement2(Menu, v3, {
			Button = createElement3(View, v4, {
				icon = React.createElement(Icon, {
					name = IconName.ThreeDotsHorizontal,
					size = IconSize.Large
				})
			})
		})
	})
end

local function TopBannerFocusNav(props)
	local isOpen = props.isOpen
	local onOpenChanged = props.onOpenChanged
	React.useEffect(function()
		if onOpenChanged then
			onOpenChanged(isOpen)
		end
	end, { isOpen, onOpenChanged })

	local render = React.useCallback(function(p)
		return React.createElement(TopBannerView, {
			ZIndex = props.ZIndex,
			isOpen = props.isOpen,
			items = props.items,
			onTriggerActivated = props.onTriggerActivated,
			onPressedOutside = props.onPressedOutside,
			focusNavEnabled = props.focusNavEnabled,
			menuContentRef = p.containerRef,
			triggerRef = p.triggerRef
		})
	end, {
		props.ZIndex,
		props.isOpen,
		props.items,
		props.onTriggerActivated,
		props.onPressedOutside,
		props.focusNavEnabled
	})

	return React.createElement(ReportMenuFocusRoot, { isOpen = props.isOpen, render = render })
end

local function ChatWindowTopBanner(props)
	local v2 = useInExperienceLocalization()
	local state, setState = React.useState(false)

	useEventConnection(GuiService:GetPropertyChangedSignal("MenuIsOpen"), function()
		if GuiService.MenuIsOpen then
			setState(false)
		end
	end)

	local text = v2("Feature.ReportAbuse.Action.EnterChatLineReporting")

	local onTriggerActivated = React.useCallback(function()
		setState(not state)
	end, { state })

	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})

	local onActivated = React.useCallback(function()
		local v3 = not props.messagesSignal and {} or props.messagesSignal(false)
		ChatLineReportRoot.initialize(mapMessagesForReport(v3, props.targetChannel))
		setState(false)
	end, { props.messagesSignal, props.targetChannel })

	local items = React.useMemo(function()
		return {
			{
				id = "report",
				icon = IconName.SpeechBubbleExclamation,
				text = text,
				onActivated = onActivated
			}
		}
	end, { text, onActivated })

	if FFlagExpChatTextChannelWindowFocusNav then
		return React.createElement(TopBannerFocusNav, {
			ZIndex = props.ZIndex,
			isOpen = state,
			items = items,
			onTriggerActivated = onTriggerActivated,
			onPressedOutside = onPressedOutside,
			focusNavEnabled = props.focusNavEnabled,
			onOpenChanged = props.onOpenChanged
		})
	end

	return React.createElement(TopBannerView, {
		ZIndex = props.ZIndex,
		isOpen = state,
		items = items,
		onTriggerActivated = onTriggerActivated,
		onPressedOutside = onPressedOutside,
		focusNavEnabled = props.focusNavEnabled
	})
end

return React.memo(ChatWindowTopBanner)
