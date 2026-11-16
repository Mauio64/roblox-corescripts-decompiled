local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Localization")
local popover = Foundation.Popover
local view = Foundation.View
local text = Foundation.Text
local enums = Foundation.Enums
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign
local numberLocalization = Localization.NumberLocalization

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/WearTimeList")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/useWearTimeSelectedOptionViewModel")
local useWearTimePopoverFocusNavigationBindings = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/useWearTimePopoverFocusNavigationBindings")

local function WearTimeSelectedOptionView(props)
	local tokens = props.tokens

	local v6 = useWearTimePopoverFocusNavigationBindings(React.useCallback(function()
		props.setIsOpen(false)
	end, { props.setIsOpen }), props.isOpen, props.anchorRef)

	local createElement = React.createElement
	local v8 = {
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
	local v9 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TopRow = 0,
		SubLabel = 0
	}

	local createElement2 = React.createElement

	local v12 = {
		RobuxIcon = React.createElement(Foundation.Icon, {
			name = enums.IconName.Robux,
			variant = enums.IconVariant.Filled,
			size = enums.IconSize.Small,
			style = tokens.Color.Content.Emphasis,
			LayoutOrder = 1
		}),
		PriceLabel = React.createElement(text, {
			tag = "auto-xy",
			Text = numberLocalization.localize(props.price, props.localization:GetLocale()),
			textStyle = tokens.Color.Content.Emphasis,
			fontStyle = {
				Font = tokens.Typography.TitleSmall.Font,
				FontSize = tokens.FontSize.FontSize_400
			},
			LayoutOrder = 2
		}),
		ChevronIcon = 0
	}

	local v13 = if not props.disableOptionSelection then React.createElement(Foundation.Icon, {
		name = enums.IconName.ChevronLargeDown,
		variant = enums.IconVariant.Regular,
		size = enums.IconSize.Small,
		style = tokens.Color.Content.Emphasis,
		LayoutOrder = 3
	}) else nil
	v12.ChevronIcon = v13
	v9.TopRow = createElement2(
		view,
		{
			tag = "row align-y-center gap-xsmall auto-xy padding-top-xxsmall",
			LayoutOrder = 1
		},
		v12
	)

	v9.SubLabel = props.subLabelText and React.createElement(text, {
		tag = "auto-xy padding-top-xxsmall",
		Text = props.subLabelText,
		textStyle = tokens.Color.Content.Muted,
		fontStyle = {
			Font = tokens.Typography.CaptionMedium.Font,
			FontSize = tokens.FontSize.FontSize_300
		},
		LayoutOrder = 2
	})
	local element = createElement("TextButton", v8, v9)

	if props.disableOptionSelection then
		return element
	end

	return React.createElement(view, { tag = "auto-xy" }, {
		TriggerButton = element,
		Popover = React.createElement(popover.Root, { isOpen = props.isOpen }, {
			Anchor = React.createElement(popover.Anchor, {
				anchorRef = props.anchorRef
			}),
			Content = React.createElement(popover.Content, {
				align = popoverAlign.Start,
				side = popoverSide.Top,
				hasArrow = false,
				onPressedOutside = function()
					props.setIsOpen(false)
				end
			}, {
				ContentWrapper = React.createElement(view, {
					Size = UDim2.new(0, tokens.Size.Size_2900 * 2, 0, 0),
					tag = "auto-y",
					ref = v6
				}, {
					WearTimeList = React.createElement(module4, {
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
