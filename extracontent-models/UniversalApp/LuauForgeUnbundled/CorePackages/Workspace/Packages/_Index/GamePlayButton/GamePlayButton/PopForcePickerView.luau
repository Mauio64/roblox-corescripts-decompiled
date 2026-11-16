local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local PopForcePickerModel = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PopForcePickerModel")

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local popover = Foundation.Popover
local iconName = Foundation.Enums.IconName

local v5 = { Color3 = Color3.fromRGB(66, 49, 17), Transparency = 0 }
local v6 = { Color3 = Color3.fromRGB(255, 222, 128), Transparency = 0 }
local color = Color3.fromRGB(255, 205, 77)

local function PickerRow(props)
	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		testId = props.testId,
		onActivated = props.onActivated,
		selection = { Selectable = true },
		backgroundStyle = 0,
		stroke = 0,
		tag = "row align-y-center gap-small size-full-0 auto-y padding-small radius-small"
	}
	local v9 = if props.selected then v5 else props.tokens.Color.Surface.Surface_100
	v8.backgroundStyle = v9

	local v11 = if props.selected then color else props.tokens.Color.Stroke.Default.Color3
	v8.stroke = {
		Color = v11,
		Transparency = props.selected and 0 or 1,
		Thickness = props.tokens.Stroke.Standard
	}

	local v12 = {
		Choice = React.createElement(icon, {
			LayoutOrder = 1,
			name = iconName.Check,
			size = props.tokens.Size.Size_400,
			style = not props.selected and { Transparency = 1 } or v6,
			testId = props.testId .. "-check"
		}),
		Location = 0,
		Ping = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		Text = props.name,
		textStyle = 0,
		tag = "size-full-0 auto-y text-label-medium text-wrap"
	}
	local v17 = if props.selected then v6 else props.tokens.Color.Content.Emphasis
	v16.textStyle = v17
	v12.Location = createElement2(view, {
		LayoutOrder = 2,
		tag = "col fill gap-xxsmall size-0-0 auto-y"
	}, {
		Name = createElement3(text, v16),
		Detail = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.detail,
			tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
		})
	})

	local v18 = if props.ping then React.createElement(text, {
		LayoutOrder = 3,
		Text = props.ping,
		textStyle = props.pingStyle,
		tag = "auto-xy text-label-small"
	}) else nil
	v12.Ping = v18
	return createElement(view, v8, v12)
end

local function PopForcePickerView(props)
	local tokens = props.tokens
	local v7 = props.forcedPop ~= ""
	local displayCode = PopForcePickerModel.getDisplayCode(props.forcedPop)
	local children = {
		Auto = React.createElement(PickerRow, {
			LayoutOrder = 0,
			name = "Automatic matchmaking",
			detail = "Let Roblox choose a server",
			selected = not v7,
			tokens = tokens,
			testId = "pop-picker-auto",
			onActivated = function()
				props.onSelect("")
			end
		})
	}

	for k, row in props.rows do
		local v8

		if row.rttMs == nil then
			v8 = tokens.Color.Content.Muted
		elseif row.rttMs < 80 then
			v8 = tokens.Color.System.Success
		else
			v8 = if row.rttMs < 160 then tokens.Color.System.Warning else tokens.Color.System.Alert
		end

		children[row.popCode] = React.createElement(PickerRow, {
			LayoutOrder = k,
			name = PopForcePickerModel.getLocationName(row.popCode),
			detail = PopForcePickerModel.getDisplayCode(row.popCode),
			ping = PopForcePickerModel.formatPing(row.rttMs),
			pingStyle = v8,
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
	local v11 = {
		LayoutOrder = props.LayoutOrder,
		testId = "pop-force-picker",
		ref = props.anchorRef,
		onActivated = props.onToggleMenu,
		selection = { Selectable = true },
		backgroundStyle = 0,
		stroke = 0,
		tag = "row align-y-center gap-xsmall auto-xy padding-small radius-small"
	}
	local v12 = if v7 then v5 else tokens.Color.Surface.Surface_200
	v11.backgroundStyle = v12

	local v14 = if v7 then color else tokens.Color.Stroke.Default.Color3
	v11.stroke = {
		Color = v14,
		Transparency = v7 and 0 or tokens.Color.Stroke.Default.Transparency,
		Thickness = tokens.Stroke.Standard
	}

	local createElement3 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		Text = not v7 and (props.compact and "Auto" or "Server: Auto") or displayCode,
		textStyle = 0,
		tag = "auto-xy text-label-small"
	}
	local v17 = if v7 then v6 else tokens.Color.Content.Emphasis
	v16.textStyle = v17
	local children2 = { Label = createElement3(text, v16), Chevron = 0 }

	local createElement4 = React.createElement
	local v19 = {
		LayoutOrder = 2,
		name = iconName.ChevronSmallDown,
		size = tokens.Size.Size_400,
		style = 0
	}
	local v20 = if v7 then v6 else tokens.Color.Content.Emphasis
	v19.style = v20
	children2.Chevron = createElement4(icon, v19)
	local v9 = {
		Trigger = createElement2(view, v11, children2),
		Menu = 0
	}
	local v21

	if props.isOpen then
		local createElement5 = React.createElement
		local root = popover.Root
		local v23 = {
			Anchor = React.createElement(popover.Anchor, {
				anchorRef = props.anchorRef
			}),
			Content = 0
		}
		local createElement6 = React.createElement
		local content = popover.Content
		local v24 = {
			side = {
				position = Foundation.Enums.PopoverSide.Bottom,
				offset = tokens.Padding.Small
			},
			align = Foundation.Enums.PopoverAlign.End,
			hasArrow = false,
			onPressedOutside = props.onClose,
			backgroundStyle = tokens.Color.Surface.Surface_200,
			radius = Foundation.Enums.Radius.Medium,
			ref = props.focusRef
		}

		local createElement7 = React.createElement
		local scrollView = Foundation.ScrollView
		local v26 = {
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

		local v30 = {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = "Choose your server location",
				tag = "size-full-0 auto-y text-label-large text-wrap content-emphasis"
			}),
			Subtitle = React.createElement(text, {
				LayoutOrder = 2,
				Text = "Server ping · lowest first",
				tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
			}),
			Rows = React.createElement(
				view,
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

		local v31 = if props.hasMore then React.createElement(Foundation.Button, {
			LayoutOrder = 4,
			text = props.showAll and "Show closest five" or "Show all locations",
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.InputSize.Small,
			onActivated = props.onToggleShowAll,
			testId = "pop-picker-show-all"
		}) else nil
		v30.More = v31

		local v32 = if #props.rows == 0 then React.createElement(text, {
			LayoutOrder = 5,
			Text = "No server ping samples yet. Reopen to refresh.",
			tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
		}) else nil
		v30.Empty = v32

		local v33 = if props.errorText then React.createElement(text, {
			LayoutOrder = 6,
			Text = props.errorText,
			tag = "size-full-0 auto-y text-body-small text-wrap content-alert"
		}) else nil
		v30.Error = v33

		v30.Hint = React.createElement(text, {
			LayoutOrder = 7,
			Text = "Applies to all experiences until you choose Auto or restart Roblox.",
			tag = "size-full-0 auto-y text-body-small text-wrap content-muted"
		})
		v23.Content = createElement6(content, v24, {
			MenuScroll = createElement7(scrollView, v26, {
				Panel = createElement8(
					view,
					{ tag = "col gap-small size-full-0 auto-y padding-medium" },
					v30
				)
			})
		})
		v21 = createElement5(root, { isOpen = true }, v23)
	end

	v9.Menu = v21
	return createElement(fragment, nil, v9)
end

return React.memo(PopForcePickerView)
