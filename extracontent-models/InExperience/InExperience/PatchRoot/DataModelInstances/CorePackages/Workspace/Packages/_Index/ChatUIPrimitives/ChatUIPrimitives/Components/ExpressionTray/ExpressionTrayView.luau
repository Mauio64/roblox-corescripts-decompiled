local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ExpressionEntryButtonView = require(script.Parent.ExpressionEntryButtonView)
local ExpressionFlyOutView = require(script.Parent.ExpressionFlyOutView)
local ExpressionTrayFocusRoot = require(script.Parent.ExpressionTrayFocusRoot)
local ExpressionTabBar = require(script.Parent.ExpressionTabBar)
local ExpressionSheetView = require(script.Parent.ExpressionSheetView)
local ExpressionPillView = require(script.Parent.ExpressionPillView)
local expressionKey = require(script.Parent.expressionKey)
local expressionKey2 = expressionKey.expressionKey
require(ChatUIPrimitives.UniversalMessage.Types)
require(ChatUIPrimitives.Hooks.useLayoutMode)
local getDefaultCooldownKey = require(ChatUIPrimitives.getDefaultCooldownKey)
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

local function expressionText(data)
	if data.kind == "plain-text" then
		return data.text
	end

	if data.kind == "preset" then
		return data.text or ""
	end

	if data.kind == "emoji" then
		return data.unicode or data.name or data.altText or ""
	end

	return data.altText or ""
end

local function buildEntryButton(props, buttonRef) -- 1 equivalent call inferred from this helper
	return React.createElement(ExpressionEntryButtonView, {
		onActivated = props.onEntryActivated,
		isActive = props.isOpen,
		size = Foundation.Enums.InputSize.Medium,
		buttonRef = buttonRef
	})
end

local function buildContent(props, p)
	local v = nil

	for _, categoryGroup in props.categoryGroups do
		if categoryGroup.categoryGroupId == props.activeGroupId then
			v = categoryGroup
			break
		end
	end

	local tabs = {}

	for _, categoryGroup in props.categoryGroups do
		table.insert(tabs, {
			id = categoryGroup.categoryGroupId,
			text = categoryGroup.name or categoryGroup.categoryGroupId
		})
	end

	local nextOrder = createNextOrder()
	local children = {}
	local v2 = false

	if v then
		for _, category in v.categories do
			local children2 = {}

			for k, item in category.items do
				local content = item.content

				local defaultCooldownKey = getDefaultCooldownKey(content)
				local cooldownEndsAt

				if not (defaultCooldownKey == nil or props.cooldownEndsAtByKey == nil) then
					cooldownEndsAt = props.cooldownEndsAtByKey[defaultCooldownKey]
				end

				local v3

				if p == nil then
					v3 = false
				else
					v3 = not v2
				end

				v2 = v3 and true or v2
				local v4 = expressionKey2(content)
				local createElement = React.createElement
				local text

				if content.kind == "plain-text" then
					text = content.text
				elseif content.kind == "preset" then
					text = content.text or ""
				elseif content.kind == "emoji" then
					text = content.unicode or content.name or content.altText or ""
				else
					text = content.altText or ""
				end

				local v5 = {
					text = text,
					content = content,
					layoutOrder = k,
					cooldownDurationSeconds = props.cooldownDurationSeconds,
					cooldownEndsAt = cooldownEndsAt,
					onActivated = props.onExpressionActivated,
					buttonRef = 0
				}
				local buttonRef

				if v3 then
					buttonRef = p
				end

				v5.buttonRef = buttonRef
				children2[v4] = createElement(ExpressionPillView, v5)
			end

			local nextOrder2 = createNextOrder()
			children["Category_" .. category.categoryId] = React.createElement(
				Foundation.View,
				{ LayoutOrder = nextOrder(), tag = "col gap-small size-full-0 auto-y" },
				{
					Header = React.createElement(Foundation.Text, {
						LayoutOrder = nextOrder2(),
						Text = category.name or category.categoryId,
						tag = "size-full-0 auto-y text-label-medium text-align-x-left content-default"
					}),
					Messages = React.createElement(Foundation.View, {
						LayoutOrder = nextOrder2(),
						tag = "size-full-0 auto-y",
						layout = {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 8),
							Wraps = true
						}
					}, children2)
				}
			)
		end
	end

	local footerText

	if v and v.footerText then
		footerText = v.footerText
	else
		footerText = props.footerText
	end

	if footerText then
		children.Footer = React.createElement(Foundation.Text, {
			LayoutOrder = nextOrder(),
			Text = footerText,
			TextWrapped = true,
			tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted",
			selection = props.focusNavEnabled == true and { Selectable = true } or nil
		})
	end

	local nextOrder2 = createNextOrder()
	return React.createElement(Foundation.View, { tag = "col size-full" }, {
		Header = React.createElement(ExpressionTabBar, {
			LayoutOrder = nextOrder2(),
			tabs = tabs,
			activeTabId = props.activeGroupId,
			onTabActivated = props.onGroupActivated,
			onKeyboardActivated = props.onKeyboardActivated,
			showKeyboardButton = props.layoutMode == "Tray" and props.canLocalUserChat,
			focusNavEnabled = props.focusNavEnabled == true
		}),
		Divider = React.createElement(Foundation.Divider, { LayoutOrder = nextOrder2() }),
		Scroll = React.createElement(Foundation.ScrollView, {
			LayoutOrder = nextOrder2(),
			tag = "grow size-full-0",
			scroll = {
				scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.Always,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0)
			},
			selection = props.focusNavEnabled and { Selectable = false } or nil
		}, {
			Categories = React.createElement(
				Foundation.View,
				{ tag = "col gap-large size-full-0 auto-y padding-large" },
				children
			)
		})
	})
end

local function buildFlyOut(props, props2)
	local createElement = React.createElement
	local v = {
		isOpen = props.isOpen,
		focusNavEnabled = props.focusNavEnabled,
		onPressedOutside = props.onPressedOutside,
		anchorContent = 0,
		content = 0,
		contentRef = 0
	}
	local v2

	if props2 then
		v2 = props2.entryButtonRef
	end

	v.anchorContent = buildEntryButton(props, v2) -- inferred equivalent call
	local v3

	if props2 then
		v3 = props2.defaultFocusRef
	end

	v.content = buildContent(props, v3)
	local contentRef

	if props2 then
		contentRef = props2.containerRef
	end

	v.contentRef = contentRef
	return createElement(ExpressionFlyOutView, v)
end

local function ExpressionTrayView(props)
	if not props.isVisible then
		return nil
	end

	local layoutMode = props.layoutMode or "FlyOut"
	local variant = props.variant or "entry"

	if variant == "overlay" and layoutMode ~= "Tray" then
		return nil
	end

	if variant == "entry" and layoutMode == "Tray" then
		return buildEntryButton(props, nil)
	end

	if variant == "overlay" then
		return React.createElement(ExpressionSheetView, {
			isOpen = props.isOpen,
			onPressedOutside = props.onPressedOutside,
			content = buildContent(props, nil)
		})
	end

	if props.focusNavEnabled == true then
		return React.createElement(ExpressionTrayFocusRoot, {
			isOpen = props.isOpen,
			render = function(p)
				return buildFlyOut(props, p)
			end
		})
	end

	return buildFlyOut(props, nil)
end

return React.memo(ExpressionTrayView)
