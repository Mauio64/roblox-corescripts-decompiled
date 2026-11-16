local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local Popover = Foundation.Popover
local View = Foundation.View
local Text = Foundation.Text
local Enums = Foundation.Enums
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local NumberLocalization = Localization.NumberLocalization

local WearTimeList = require(script.Parent.WearTimeList)
require(script.Parent.useWearTimeSelectedOptionViewModel)
local useWearTimePopoverFocusNavigationBindings = require(script.Parent.useWearTimePopoverFocusNavigationBindings)

local function WearTimeSelectedOptionView(props)
	local tokens = props.tokens

	local ref = useWearTimePopoverFocusNavigationBindings(React.useCallback(function()
		props.setIsOpen(false)
	end, { props.setIsOpen }), props.isOpen, props.anchorRef)

	local createElement = React.createElement
	local v = {
		Text = "",
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ref = props.anchorRef,
		[React.Event.Activated] = function()
			props.setIsOpen(not props.isOpen)
		end
	}
	local v2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TopRow = 0,
		SubLabel = 0
	}

	local createElement2 = React.createElement

	local v3 = {
		RobuxIcon = React.createElement(Foundation.Icon, {
			name = Enums.IconName.Robux,
			variant = Enums.IconVariant.Filled,
			size = Enums.IconSize.Small,
			style = tokens.Color.Content.Emphasis,
			LayoutOrder = 1
		}),
		PriceLabel = React.createElement(Text, {
			tag = "auto-xy",
			Text = NumberLocalization.localize(props.price, props.localization:GetLocale()),
			textStyle = tokens.Color.Content.Emphasis,
			fontStyle = {
				Font = tokens.Typography.TitleSmall.Font,
				FontSize = tokens.FontSize.FontSize_400
			},
			LayoutOrder = 2
		}),
		ChevronIcon = 0
	}
	local chevronIcon

	if not props.disableOptionSelection then
		chevronIcon = React.createElement(Foundation.Icon, {
			name = Enums.IconName.ChevronLargeDown,
			variant = Enums.IconVariant.Regular,
			size = Enums.IconSize.Small,
			style = tokens.Color.Content.Emphasis,
			LayoutOrder = 3
		})
	end

	v3.ChevronIcon = chevronIcon
	v2.TopRow = createElement2(
		View,
		{ tag = "row align-y-center gap-xsmall auto-xy padding-top-xxsmall", LayoutOrder = 1 },
		v3
	)

	v2.SubLabel = props.subLabelText and React.createElement(Text, {
		tag = "auto-xy padding-top-xxsmall",
		Text = props.subLabelText,
		textStyle = tokens.Color.Content.Muted,
		fontStyle = {
			Font = tokens.Typography.CaptionMedium.Font,
			FontSize = tokens.FontSize.FontSize_300
		},
		LayoutOrder = 2
	})
	local element = createElement("TextButton", v, v2)

	if props.disableOptionSelection then
		return element
	end

	return React.createElement(View, { tag = "auto-xy" }, {
		TriggerButton = element,
		Popover = React.createElement(Popover.Root, { isOpen = props.isOpen }, {
			Anchor = React.createElement(Popover.Anchor, { anchorRef = props.anchorRef }),
			Content = React.createElement(Popover.Content, {
				align = PopoverAlign.Start,
				side = PopoverSide.Top,
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

return WearTimeSelectedOptionView
