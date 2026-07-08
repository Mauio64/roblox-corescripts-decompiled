local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Popover = Foundation.Popover
local View = Foundation.View
local FoundationText = Foundation.Text
local Enums = Foundation.Enums
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local FFlagAXFixIaBTimedOptionsPopoverFocus = require(Parent.AvatarExperienceFlags).FFlagAXFixIaBTimedOptionsPopoverFocus
local WearTimeList = require(script.Parent.WearTimeList)

require(script.Parent.useWearTimeSelectedOptionViewModel)

local useWearTimePopoverFocusNavigationBindings = require(script.Parent.useWearTimePopoverFocusNavigationBindings)

local function WearTimeSelectedOptionInListView(p1) -- line: 22
	-- upvalues: React (copy), useWearTimePopoverFocusNavigationBindings (copy), FFlagAXFixIaBTimedOptionsPopoverFocus (copy), View (copy), FoundationText (copy), Foundation (copy), Enums (copy), Popover (copy), PopoverAlign (copy), PopoverSide (copy), WearTimeList (copy)
	local tokens = p1.tokens
	local v16 = React.useCallback(function() -- line: 25
		-- upvalues: p1 (copy)
		p1.setIsOpen(false)
	end, { p1.setIsOpen })
	local v17 = useWearTimePopoverFocusNavigationBindings(v16, p1.isOpen, if not FFlagAXFixIaBTimedOptionsPopoverFocus then nil else p1.anchorRef)
	local v18 = React.createElement("TextButton", {
		Text = "",
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BorderSizePixel = 0,
		Transparency = p1.tokens.Color.Shift.Shift_200.Transparency,
		BackgroundColor3 = p1.tokens.Color.Shift.Shift_200.Color3,
		ref = p1.anchorRef,
		[React.Event.Activated] = function() -- line: 45
			-- upvalues: p1 (copy)
			p1.setIsOpen(not p1.isOpen)
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
			Duration = React.createElement(FoundationText, {
				tag = "auto-xy",
				LayoutOrder = 2,
				Text = p1.listLabelText,
				textStyle = tokens.Color.Content.Emphasis,
				fontStyle = {
					Font = tokens.Typography.TitleSmall.Font,
					FontSize = tokens.FontSize.FontSize_300
				}
			}),
			ChevronIcon = React.createElement(Foundation.Icon, {
				LayoutOrder = 3,
				name = Enums.IconName.ChevronLargeDown,
				variant = Enums.IconVariant.Regular,
				size = Enums.IconSize.Small
			})
		})
	})

	return React.createElement(View, {
		tag = "auto-xy"
	}, {
		TriggerButton = v18,
		Popover = React.createElement(Popover.Root, {
			isOpen = p1.isOpen
		}, {
			Anchor = React.createElement(Popover.Anchor, {
				anchorRef = p1.anchorRef
			}),
			Content = React.createElement(Popover.Content, {
				hasArrow = false,
				align = PopoverAlign.Start,
				side = PopoverSide.Bottom,
				onPressedOutside = function() -- line: 100
					-- upvalues: p1 (copy)
					p1.setIsOpen(false)
				end
			}, {
				ContentWrapper = React.createElement(View, {
					tag = "auto-y",
					Size = UDim2.new(0, tokens.Size.Size_2900 * 2, 0, 0),
					ref = v17
				}, {
					WearTimeList = React.createElement(WearTimeList, {
						options = p1.updatedOptions,
						selectedIndex = p1.selectedIndex,
						onOptionActivated = p1.handleOptionActivated
					})
				})
			})
		})
	})
end

return WearTimeSelectedOptionInListView
