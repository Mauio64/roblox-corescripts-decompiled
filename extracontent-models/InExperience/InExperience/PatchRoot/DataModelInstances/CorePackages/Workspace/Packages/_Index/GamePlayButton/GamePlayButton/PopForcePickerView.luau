local parent = script:FindFirstAncestor("GamePlayButton").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local PopForcePickerModel = require(script.Parent.PopForcePickerModel)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Popover = Foundation.Popover
local IconName = Foundation.Enums.IconName

local v = { Color3 = Color3.fromRGB(66, 49, 17), Transparency = 0 }
local v2 = { Color3 = Color3.fromRGB(255, 222, 128), Transparency = 0 }
local color = Color3.fromRGB(255, 205, 77)

local function PickerRow(props)
	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		testId = props.testId,
		onActivated = props.onActivated,
		selection = { Selectable = true },
		backgroundStyle = 0,
		stroke = 0,
		tag = "row align-y-center gap-small size-full-0 auto-y padding-small radius-small"
	}
	local backgroundStyle

	if props.selected then
		backgroundStyle = v
	else
		backgroundStyle = props.tokens.Color.Surface.Surface_100
	end

	v3.backgroundStyle = backgroundStyle
	local color2

	if props.selected then
		color2 = color
	else
		color2 = props.tokens.Color.Stroke.Default.Color3
	end

	v3.stroke = {
		Color = color2,
		Transparency = props.selected and 0 or 1,
		Thickness = props.tokens.Stroke.Standard
	}

	local v4 = {
		Choice = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.Check,
			size = props.tokens.Size.Size_400,
			style = not props.selected and { Transparency = 1 } or v2,
			testId = props.testId .. "-check"
		}),
		Location = 0,
		Ping = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v5 = {
		LayoutOrder = 1,
		Text = props.name,
		textStyle = 0,
		tag = "size-full-0 auto-y text-label-medium text-wrap"
	}
	local textStyle

	if props.selected then
		textStyle = v2
	else
		textStyle = props.tokens.Color.Content.Emphasis
	end

	v5.textStyle = textStyle
	v4.Location = createElement2(View, {
		LayoutOrder = 2,
		tag = "col fill gap-xxsmall size-0-0 auto-y"
	}, {
		Name = createElement3(Text, v5),
		Detail = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.detail,
			tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
		})
	})
	local ping

	if props.ping then
		ping = React.createElement(Text, {
			LayoutOrder = 3,
			Text = props.ping,
			textStyle = props.pingStyle,
			tag = "auto-xy text-label-small"
		})
	end

	v4.Ping = ping
	return createElement(View, v3, v4)
end

local function PopForcePickerView(props)
	local tokens = props.tokens
	local v3 = props.forcedPop ~= ""
	local displayCode = PopForcePickerModel.getDisplayCode(props.forcedPop)
	local children = {
		Auto = React.createElement(PickerRow, {
			LayoutOrder = 0,
			name = "Automatic matchmaking",
			detail = "Let Roblox choose a server",
			selected = not v3,
			tokens = tokens,
			testId = "pop-picker-auto",
			onActivated = function()
				props.onSelect("")
			end
		})
	}

	for k, row in props.rows do
		local pingStyle

		if row.rttMs == nil then
			pingStyle = tokens.Color.Content.Muted
		elseif row.rttMs < 80 then
			pingStyle = tokens.Color.System.Success
		elseif row.rttMs < 160 then
			pingStyle = tokens.Color.System.Warning
		else
			pingStyle = tokens.Color.System.Alert
		end

		children[row.popCode] = React.createElement(PickerRow, {
			LayoutOrder = k,
			name = PopForcePickerModel.getLocationName(row.popCode),
			detail = PopForcePickerModel.getDisplayCode(row.popCode),
			ping = PopForcePickerModel.formatPing(row.rttMs),
			pingStyle = pingStyle,
			selected = row.popCode == props.forcedPop,
			tokens = tokens,
			testId = "pop-picker-row-" .. row.popCode,
			onActivated = function()
				props.onSelect(row.popCode)
			end
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = props.LayoutOrder,
		testId = "pop-force-picker",
		ref = props.anchorRef,
		onActivated = props.onToggleMenu,
		selection = { Selectable = true },
		backgroundStyle = 0,
		stroke = 0,
		tag = "row align-y-center gap-xsmall auto-xy padding-small radius-small"
	}
	local backgroundStyle

	if v3 then
		backgroundStyle = v
	else
		backgroundStyle = tokens.Color.Surface.Surface_200
	end

	v4.backgroundStyle = backgroundStyle
	local color2

	if v3 then
		color2 = color
	else
		color2 = tokens.Color.Stroke.Default.Color3
	end

	v4.stroke = {
		Color = color2,
		Transparency = v3 and 0 or tokens.Color.Stroke.Default.Transparency,
		Thickness = tokens.Stroke.Standard
	}

	local createElement3 = React.createElement
	local v6 = {
		LayoutOrder = 1,
		Text = not v3 and (props.compact and "Auto" or "Server: Auto") or displayCode,
		textStyle = 0,
		tag = "auto-xy text-label-small"
	}
	local textStyle = if v3 then v2 else tokens.Color.Content.Emphasis
	v6.textStyle = textStyle
	local children2 = { Label = createElement3(Text, v6), Chevron = 0 }

	local createElement4 = React.createElement
	local v7 = {
		LayoutOrder = 2,
		name = IconName.ChevronSmallDown,
		size = tokens.Size.Size_400,
		style = 0
	}
	local style = if v3 then v2 else tokens.Color.Content.Emphasis
	v7.style = style
	children2.Chevron = createElement4(Icon, v7)
	local v5 = {
		Trigger = createElement2(View, v4, children2),
		Menu = 0
	}
	local menu

	if props.isOpen then
		local createElement5 = React.createElement
		local root = Popover.Root
		local v8 = {
			Anchor = React.createElement(Popover.Anchor, { anchorRef = props.anchorRef }),
			Content = 0
		}
		local createElement6 = React.createElement
		local content = Popover.Content
		local v9 = {
			side = { position = Foundation.Enums.PopoverSide.Bottom, offset = tokens.Padding.Small },
			align = Foundation.Enums.PopoverAlign.End,
			hasArrow = false,
			onPressedOutside = props.onClose,
			backgroundStyle = tokens.Color.Surface.Surface_200,
			radius = Foundation.Enums.Radius.Medium,
			ref = props.focusRef
		}

		local createElement7 = React.createElement
		local scrollView = Foundation.ScrollView
		local v10 = {
			testId = "pop-picker-menu",
			Size = UDim2.fromOffset(props.menuSize.X, props.menuSize.Y),
			onAbsoluteCanvasSizeChanged = props.onCanvasSizeChanged,
			scroll = {
				CanvasSize = UDim2.fromOffset(0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}

		local createElement8 = React.createElement

		local v11 = {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = "Choose your server location",
				tag = "size-full-0 auto-y text-label-large text-wrap content-emphasis"
			}),
			Subtitle = React.createElement(Text, {
				LayoutOrder = 2,
				Text = "Server ping · lowest first",
				tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
			}),
			Rows = React.createElement(
				View,
				{
					LayoutOrder = 3,
					tag = "col gap-small size-full-0 auto-y",
					padding = UDim.new(0, tokens.Stroke.Standard)
				},
				children
			),
			More = 0,
			Empty = 0,
			Error = 0,
			Hint = 0
		}
		local more

		if props.hasMore then
			more = React.createElement(Foundation.Button, {
				LayoutOrder = 4,
				text = props.showAll and "Show closest five" or "Show all locations",
				variant = Foundation.Enums.ButtonVariant.Utility,
				size = Foundation.Enums.InputSize.Small,
				onActivated = props.onToggleShowAll,
				testId = "pop-picker-show-all"
			})
		end

		v11.More = more
		local empty

		if #props.rows == 0 then
			empty = React.createElement(Text, {
				LayoutOrder = 5,
				Text = "No server ping samples yet. Reopen to refresh.",
				tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
			})
		end

		v11.Empty = empty
		local err

		if props.errorText then
			err = React.createElement(Text, {
				LayoutOrder = 6,
				Text = props.errorText,
				tag = "size-full-0 auto-y text-body-small text-wrap content-alert"
			})
		end

		v11.Error = err

		v11.Hint = React.createElement(Text, {
			LayoutOrder = 7,
			Text = "Applies to all experiences until you choose Auto or restart Roblox.",
			tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
		})
		v8.Content = createElement6(content, v9, {
			MenuScroll = createElement7(scrollView, v10, {
				Panel = createElement8(View, {
					tag = "col gap-small size-full-0 auto-y padding-medium"
				}, v11)
			})
		})
		menu = createElement5(root, { isOpen = true }, v8)
	end

	v5.Menu = menu
	return createElement(fragment, nil, v5)
end

return React.memo(PopForcePickerView)
