local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local scriptParentParentParentParentParent = scriptParentParentParentParent.Parent
local Cryo = require(scriptParentParentParentParentParent.Cryo)
local React = require(scriptParentParentParentParentParent.React)
local RoactGamepad = require(scriptParentParentParentParentParent.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local FitFrame = require(scriptParentParentParentParentParent.FitFrame)
local FitFrameHorizontal = FitFrame.FitFrameHorizontal
local IconSize = require(scriptParentParentParent.ImageSet.Enum.IconSize)
local Images = require(scriptParentParentParent.ImageSet.Images)
local useStyle = require(scriptParentParentParentParent.Core.Style.useStyle)
local IconButton = require(scriptParentParentParentParent.App.Button.IconButton)
local useIsGamepad = require(scriptParentParentParentParent.Utility.useIsGamepad)
local ScrollingListWithArrowsAndGradient = require(scriptParentParent.HorizontalNav.ScrollingListWithArrowsAndGradient)
local Pillv2 = require(scriptParent.Pillv2)

local function PillGroup(t1: {[any]: any}) -- line: 60
	-- upvalues: useIsGamepad (copy), React (copy), useStyle (copy), RoactGamepad (copy), Cryo (copy), IconButton (copy), IconSize (copy), Images (copy), Focusable (copy), Pillv2 (copy), FitFrameHorizontal (copy), FitFrame (copy), ScrollingListWithArrowsAndGradient (copy)
	local v21 = t1.isRoactGamepadEnabled == nil or t1.isRoactGamepadEnabled
	local v22 = useIsGamepad() and v21
	local v23 = React.useRef(nil)

	local function scrollToStart() -- line: 66
		-- upvalues: v23 (copy)
		local current = v23.current

		if current then
			current:ScrollToTop()
		end
	end

	local v25 = t1.leftPadding or 15
	local v26 = t1.rightPadding or 15
	local v27 = t1.selectedPills or {}
	local Theme = useStyle().Theme
	local v29 = React.useCallback(function(p1) -- line: 81
		-- upvalues: v23 (copy)
		if v23.current then
			v23.current.CanvasSize = UDim2.new(0, p1.AbsoluteSize.X, 1, 0)
		end
	end)
	local v30 = React.useRef({})
	local v31 = v21 and RoactGamepad.useRefCache() or v30.current
	local v32 = React.useCallback(function() -- line: 90
		-- upvalues: t1 (copy)
		if t1.onSelectionChanged then
			t1.onSelectionChanged({})
		end
	end)
	local v33 = React.useMemo(function() -- line: 96
		-- upvalues: t1 (copy), Cryo (copy), v27 (copy)
		local t2 = {}

		for _, v49 in t1.pills do
			if not Cryo.List.find(v27, v49) then
				table.insert(t2, v49)
			end
		end

		return Cryo.List.join(v27, t2)
	end, {
		t1.pills,
		v27
	})
	local v34 = #v27 > 1
	local t3 = {
		ClearButton = v34 and React.createElement(IconButton, {
			layoutOrder = 1,
			key = "0",
			size = UDim2.fromOffset(24, 24),
			iconSize = IconSize.Medium,
			icon = Images["icons/actions/reject"],
			onActivated = v32,
			buttonRef = v31[0],
			NextSelectionRight = v31[1]
		}) or nil
	}
	local isLoading = t1.isLoading

	for v37, v38 in v33 do
		local v39 = v37 <= #v27

		if v39 then
			isLoading = false
		end

		if not v21 then
			v31[v37] = v31[v37] or React.createRef()
		end

		t3[v37] = React.createElement(if not v21 then Pillv2 else Focusable[Pillv2], {
			layoutOrder = v37 + 1,
			key = tostring(v37),
			text = v38,
			isSelected = v39,
			isLoading = t1.isLoading and not v39,
			onActivated = function() -- line: 124
				-- upvalues: Cryo (copy), v27 (copy), v38 (copy), v23 (copy), t1 (copy)
				local v50 = Cryo.List.find(v27, v38) ~= nil
				local v51 = if not v50 then Cryo.List.join(v27, { v38 }) else Cryo.List.removeValue(v27, v38)

				if not v50 then
					local current = v23.current

					if current then
						current:ScrollToTop()
					end
				end

				if t1.onSelectionChanged then
					t1.onSelectionChanged(v51)
				end
			end,
			ref = v31[v37],
			NextSelectionLeft = if not (v37 > 1) and not v34 then nil else v31[v37 - 1],
			NextSelectionRight = if not (v37 < #v33) then nil else v31[v37 + 1]
		})
	end

	if isLoading and v22 and v21 then
		t3[1] = React.createElement(Focusable[Pillv2], {
			layoutOrder = 2,
			key = "1",
			text = "",
			ref = v31[1]
		})
	end

	local function getScrollingListChildren() -- line: 176
		-- upvalues: React (copy), FitFrameHorizontal (copy), FitFrame (copy), v26 (copy), v25 (copy), v29 (copy), t3 (copy)
		return {
			SubNavFrame = React.createElement(FitFrameHorizontal, {
				height = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				margin = FitFrame.Rect.quad(0, v26, 0, v25),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = v29
			}, t3)
		}
	end

	local t4 = {}

	for i = 1, #v33 do
		t4[i] = v31[i]
	end

	return React.createElement(not v21 and "Frame" or Focusable.Frame, {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		LayoutOrder = t1.layoutOrder,
		ref = t1.forwardRef,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		defaultChild = if not v21 then nil else v31[1]
	}, {
		ScrollingList = React.createElement(ScrollingListWithArrowsAndGradient, {
			listHeight = 52,
			buttonPadding = 8,
			padOutsideEdges = false,
			hideGradient = true,
			getScollingListContent = getScrollingListChildren,
			scrollingFrameRef = v23,
			buttonRefs = t4
		})
	})
end

return React.forwardRef(function(p2, p3) -- line: 221
	-- upvalues: React (copy), PillGroup (copy), Cryo (copy)
	return React.createElement(PillGroup, Cryo.Dictionary.join(p2, {
		forwardRef = p3
	}))
end)
