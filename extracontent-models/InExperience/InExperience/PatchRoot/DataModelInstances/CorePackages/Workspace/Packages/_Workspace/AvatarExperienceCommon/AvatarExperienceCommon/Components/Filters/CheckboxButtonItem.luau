local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local Checkbox = Foundation.Checkbox
local FoundationText = Foundation.Text
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local Focusable = require(Parent.RoactGamepad).Focusable
local ExpandingFrame = require(script.Parent.ExpandingFrame)

local function CheckboxButtonItem(t1: {[any]: any}) -- line: 62
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationText (copy), Focusable (copy), Checkbox (copy), InputSize (copy), ExpandingFrame (copy)
	local v14 = useTokens()
	local v15 = React.useCallback(function() -- line: 64
		-- upvalues: t1 (copy)
		if t1.onActivated then
			t1.onActivated(t1.id)
		end
	end, {
		t1.onActivated,
		t1.id
	})
	local v16 = t1.itemHeight or v14.Size.Size_900
	local v17 = React.useRef(nil)
	local v18, v19 = React.useBinding(v16)
	local v20 = React.useCallback(function(p1) -- line: 76
		-- upvalues: v16 (copy), t1 (copy), v14 (copy), v19 (copy)
		local v25 = v16

		if p1 then
			v25 += p1.AbsoluteSize.Y
		end

		if not t1.hideDivider then
			v25 += v14.Size.Size_50
		end

		v19(v25)

		if t1.onHeightChanged then
			t1.onHeightChanged(v25)
		end
	end, {
		v16,
		t1.hideDivider,
		v19,
		t1.onHeightChanged
	})

	React.useEffect(function() -- line: 90
		-- upvalues: v20 (copy), v17 (copy)
		v20(v17.current)
	end, {})

	local v21 = t1.expandedView and t1.isSelected == true

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = v18:map(function(p2) -- line: 97
			return UDim2.new(1, 0, 0, p2)
		end),
		LayoutOrder = t1.layoutOrder,
		ref = t1.frameRef,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}),
		Contents = React.createElement(View, {
			tag = "size-full row items-center padding-left-large padding-y-medium padding-right-none",
			LayoutOrder = 1,
			ref = t1.defaultChildRef,
			NextSelectionDown = if not v21 then nil else v17,
			SelectionImageObject = t1.SelectionImageObject
		}, {
			ClickableTextArea = React.createElement("TextButton", {
				Size = UDim2.new(1, -v14.Size.Size_400 - v14.Size.Size_400, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				Active = not t1.isDisabled,
				[React.Event.Activated] = if t1.isDisabled then nil else v15,
				LayoutOrder = 1
			}, {
				CustomViewFrame = t1.customView and React.createElement(View, {
					tag = "gui-object-defaults",
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					CustomView = t1.customView
				}),
				TitleText = t1.text and (not t1.customView and React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "text-title-medium content-default text-align-x-left auto-y",
					Size = UDim2.new(1, 0, 1, 0),
					Text = t1.text
				}))
			}),
			RightContent = React.createElement(Focusable[Checkbox], {
				label = "",
				LayoutOrder = 3,
				isChecked = t1.isSelected,
				isDisabled = t1.isDisabled,
				onActivated = v15,
				size = InputSize.Medium
			})
		}),
		ExpandingFrame = t1.expandedView and React.createElement(Focusable[ExpandingFrame], {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, t1.expandedViewHeight or 0),
			isExpanded = t1.isSelected == true,
			onAbsoluteSizeChanged = v20,
			ref = v17,
			NextSelectionUp = t1.defaultChildRef
		}, {
			ExpandedView = t1.expandedView
		})
	})
end

return React.forwardRef(function(p3, p4) -- line: 165
	-- upvalues: React (copy), CheckboxButtonItem (copy), Cryo (copy)
	return React.createElement(CheckboxButtonItem, Cryo.Dictionary.join(p3, {
		frameRef = p4
	}))
end)
