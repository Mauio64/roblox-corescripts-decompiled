local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Popover = Foundation.Popover
local View = Foundation.View
local Text = Foundation.Text
local Enums = Foundation.Enums
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local WearTimeList = require(script.Parent.WearTimeList)
require(script.Parent.useWearTimeSelectedOptionViewModel)
local useWearTimePopoverFocusNavigationBindings = require(script.Parent.useWearTimePopoverFocusNavigationBindings)

local function WearTimeSelectedOptionInListView(props)
	local tokens = props.tokens

	local ref = useWearTimePopoverFocusNavigationBindings(React.useCallback(function()
		props.setIsOpen(false)
	end, { props.setIsOpen }), props.isOpen, props.anchorRef)

	local element = React.createElement("TextButton", {
		Text = "",
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BorderSizePixel = 0,
		Transparency = props.tokens.Color.Shift.Shift_200.Transparency,
		BackgroundColor3 = props.tokens.Color.Shift.Shift_200.Color3,
		ref = props.anchorRef,
		[React.Event.Activated] = function()
			props.setIsOpen(not props.isOpen)
		end
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, tokens.Radius.Circle)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, tokens.Padding.XXSmall)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, tokens.Padding.Medium),
			PaddingRight = UDim.new(0, tokens.Padding.Medium),
			PaddingTop = UDim.new(0, tokens.Padding.Small),
			PaddingBottom = UDim.new(0, tokens.Padding.Small)
		}),
		TopRow = React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 1
		}, {
			Duration = React.createElement(Text, {
				tag = "auto-xy",
				Text = props.listLabelText,
				textStyle = tokens.Color.Content.Emphasis,
				fontStyle = {
					Font = tokens.Typography.TitleSmall.Font,
					FontSize = tokens.FontSize.FontSize_300
				},
				LayoutOrder = 2
			}),
			ChevronIcon = React.createElement(Foundation.Icon, {
				name = Enums.IconName.ChevronLargeDown,
				variant = Enums.IconVariant.Regular,
				size = Enums.IconSize.Small,
				LayoutOrder = 3
			})
		})
	})

	return React.createElement(View, { tag = "auto-xy" }, {
		TriggerButton = element,
		Popover = React.createElement(Popover.Root, { isOpen = props.isOpen }, {
			Anchor = React.createElement(Popover.Anchor, { anchorRef = props.anchorRef }),
			Content = React.createElement(Popover.Content, {
				align = PopoverAlign.Start,
				side = PopoverSide.Bottom,
				hasArrow = false,
				onPressedOutside = function()
					props.setIsOpen(false)
				end
			}, {
				ContentWrapper = React.createElement(View, {
					Size = UDim2.new(0, tokens.Size.Size_2900 * 2, 0, 0),
					tag = "auto-y",
					ref = ref
				}, {
					WearTimeList = React.createElement(WearTimeList, {
						options = props.updatedOptions,
						selectedIndex = props.selectedIndex,
						onOptionActivated = props.handleOptionActivated
					})
				})
			})
		})
	})
end

return WearTimeSelectedOptionInListView
