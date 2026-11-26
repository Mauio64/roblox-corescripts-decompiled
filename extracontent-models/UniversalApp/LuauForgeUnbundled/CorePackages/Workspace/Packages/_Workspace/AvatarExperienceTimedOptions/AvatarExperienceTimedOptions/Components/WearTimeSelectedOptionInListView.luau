local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local popover = Foundation.Popover
local view = Foundation.View
local text = Foundation.Text
local enums = Foundation.Enums
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/WearTimeList")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/useWearTimeSelectedOptionViewModel")
local useWearTimePopoverFocusNavigationBindings = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/useWearTimePopoverFocusNavigationBindings")

local function WearTimeSelectedOptionInListView(props)
	local tokens = props.tokens

	local v6 = useWearTimePopoverFocusNavigationBindings(React.useCallback(function()
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
		TopRow = React.createElement(
			view,
			{ tag = "row align-y-center gap-small auto-xy", LayoutOrder = 1 },
			{
				Duration = React.createElement(text, {
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
					name = enums.IconName.ChevronLargeDown,
					variant = enums.IconVariant.Regular,
					size = enums.IconSize.Small,
					LayoutOrder = 3
				})
			}
		)
	})

	return React.createElement(view, { tag = "auto-xy" }, {
		TriggerButton = element,
		Popover = React.createElement(popover.Root, { isOpen = props.isOpen }, {
			Anchor = React.createElement(popover.Anchor, {
				anchorRef = props.anchorRef
			}),
			Content = React.createElement(popover.Content, {
				align = popoverAlign.Start,
				side = popoverSide.Bottom,
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
					WearTimeList = React.createElement(module3, {
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
