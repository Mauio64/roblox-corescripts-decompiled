local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Localization = require(Parent.Localization)
local Popover = Foundation.Popover
local View = Foundation.View
local FoundationText = Foundation.Text
local Enums = Foundation.Enums
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local NumberLocalization = Localization.NumberLocalization
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local WearTimeList = require(script.Parent.WearTimeList)

require(script.Parent.useWearTimeSelectedOptionViewModel)

local useWearTimePopoverFocusNavigationBindings = require(script.Parent.useWearTimePopoverFocusNavigationBindings)
local FFlagAXFixIaBTimedOptionsPopoverFocus = AvatarExperienceFlags.FFlagAXFixIaBTimedOptionsPopoverFocus

local function WearTimeSelectedOptionView(p1) -- line: 24
	-- upvalues: React (copy), useWearTimePopoverFocusNavigationBindings (copy), FFlagAXFixIaBTimedOptionsPopoverFocus (copy), View (copy), Foundation (copy), Enums (copy), FoundationText (copy), NumberLocalization (copy), Popover (copy), PopoverAlign (copy), PopoverSide (copy), WearTimeList (copy)
	local tokens = p1.tokens
	local v19 = React.useCallback(function() -- line: 27
		-- upvalues: p1 (copy)
		p1.setIsOpen(false)
	end, { p1.setIsOpen })
	local v20 = useWearTimePopoverFocusNavigationBindings(v19, p1.isOpen, if not FFlagAXFixIaBTimedOptionsPopoverFocus then nil else p1.anchorRef)
	local v21 = React.createElement("TextButton", {
		Text = "",
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ref = p1.anchorRef,
		[React.Event.Activated] = function() -- line: 46
			-- upvalues: p1 (copy)
			p1.setIsOpen(not p1.isOpen)
		end
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TopRow = React.createElement(View, {
			tag = "row align-y-center gap-xsmall auto-xy padding-top-xxsmall",
			LayoutOrder = 1
		}, {
			RobuxIcon = React.createElement(Foundation.Icon, {
				LayoutOrder = 1,
				name = Enums.IconName.Robux,
				variant = Enums.IconVariant.Filled,
				size = Enums.IconSize.Small,
				style = tokens.Color.Content.Emphasis
			}),
			PriceLabel = React.createElement(FoundationText, {
				tag = "auto-xy",
				LayoutOrder = 2,
				Text = NumberLocalization.localize(p1.price, p1.localization:GetLocale()),
				textStyle = tokens.Color.Content.Emphasis,
				fontStyle = {
					Font = tokens.Typography.TitleSmall.Font,
					FontSize = tokens.FontSize.FontSize_400
				}
			}),
			ChevronIcon = if p1.disableOptionSelection then nil else React.createElement(Foundation.Icon, {
				LayoutOrder = 3,
				name = Enums.IconName.ChevronLargeDown,
				variant = Enums.IconVariant.Regular,
				size = Enums.IconSize.Small,
				style = tokens.Color.Content.Emphasis
			})
		}),
		SubLabel = p1.subLabelText and React.createElement(FoundationText, {
			tag = "auto-xy padding-top-xxsmall",
			LayoutOrder = 2,
			Text = p1.subLabelText,
			textStyle = tokens.Color.Content.Muted,
			fontStyle = {
				Font = tokens.Typography.CaptionMedium.Font,
				FontSize = tokens.FontSize.FontSize_300
			}
		})
	})

	if p1.disableOptionSelection then
		return v21
	end

	return React.createElement(View, {
		tag = "auto-xy"
	}, {
		TriggerButton = v21,
		Popover = React.createElement(Popover.Root, {
			isOpen = p1.isOpen
		}, {
			Anchor = React.createElement(Popover.Anchor, {
				anchorRef = p1.anchorRef
			}),
			Content = React.createElement(Popover.Content, {
				hasArrow = false,
				align = PopoverAlign.Start,
				side = PopoverSide.Top,
				onPressedOutside = function() -- line: 114
					-- upvalues: p1 (copy)
					p1.setIsOpen(false)
				end
			}, {
				ContentWrapper = React.createElement(View, {
					tag = "auto-y",
					Size = UDim2.new(0, tokens.Size.Size_2900 * 2, 0, 0),
					ref = v20
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

return WearTimeSelectedOptionView
