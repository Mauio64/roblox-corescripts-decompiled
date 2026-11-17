local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent
local parent5 = parent4.Parent

local Cryo = require(parent5.Cryo)
local React = require(parent5.React)
local RoactGamepad = require(parent5.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local FitFrame = require(parent5.FitFrame)
local FitFrameHorizontal = FitFrame.FitFrameHorizontal

local IconSize = require(parent3.ImageSet.Enum.IconSize)
local Images = require(parent3.ImageSet.Images)

local useStyle = require(parent4.Core.Style.useStyle)
local IconButton = require(parent4.App.Button.IconButton)
local useIsGamepad = require(parent4.Utility.useIsGamepad)
local ScrollingListWithArrowsAndGradient = require(parent2.HorizontalNav.ScrollingListWithArrowsAndGradient)
local Pillv2 = require(parent.Pillv2)

local function PillGroup(props)
	local v = props.isRoactGamepadEnabled == nil or props.isRoactGamepadEnabled
	local v2 = useIsGamepad() and v

	local ref = React.useRef(nil)

	local function scrollToStart()
		local current = ref.current

		if current then
			current:ScrollToTop()
		end
	end

	local leftPadding = props.leftPadding or 15
	local rightPadding = props.rightPadding or 15

	local selectedPills = props.selectedPills or {}

	local theme = useStyle().Theme

	local v3 = React.useCallback(function(p)
		if ref.current then
			ref.current.CanvasSize = UDim2.new(0, p.AbsoluteSize.X, 1, 0)
		end
	end)

	local ref2 = React.useRef({})
	local v4 = v and RoactGamepad.useRefCache() or ref2.current

	local onActivated2 = React.useCallback(function()
		if props.onSelectionChanged then
			props.onSelectionChanged({})
		end
	end)

	local v5 = React.useMemo(function()
		local pills = {}

		for _, pill in props.pills do
			if not Cryo.List.find(selectedPills, pill) then
				table.insert(pills, pill)
			end
		end

		return Cryo.List.join(selectedPills, pills)
	end, { props.pills, selectedPills })

	local v6 = #selectedPills > 1

	local children = { ClearButton = 0 }
	local clearButton

	if v6 then
		clearButton = React.createElement(IconButton, {
			layoutOrder = 1,
			size = UDim2.fromOffset(24, 24),
			iconSize = IconSize.Medium,
			icon = Images["icons/actions/reject"],
			onActivated = onActivated2,
			key = "0",
			buttonRef = v4[0],
			NextSelectionRight = v4[1]
		}) or nil
	end

	children.ClearButton = clearButton

	local v7 = props.isLoading

	for k, text in v5 do
		local function onActivated()
			local v8 = Cryo.List.find(selectedPills, text) ~= nil
			local v9

			if v8 then
				v9 = Cryo.List.removeValue(selectedPills, text)
			else
				v9 = Cryo.List.join(selectedPills, { text })
			end

			local current = not v8 and ref.current

			if current then
				current:ScrollToTop()
			end

			if props.onSelectionChanged then
				props.onSelectionChanged(v9)
			end
		end

		local isSelected = k <= #selectedPills

		if isSelected then
			v7 = false
		end

		if not v then
			v4[k] = v4[k] or React.createRef()
		end

		local createElement = React.createElement
		local v8

		if v then
			v8 = Focusable[Pillv2]
		else
			v8 = Pillv2
		end

		local v9 = {
			layoutOrder = k + 1,
			key = tostring(k),
			text = text,
			isSelected = isSelected,
			isLoading = props.isLoading and not isSelected,
			onActivated = onActivated,
			ref = v4[k],
			NextSelectionLeft = 0,
			NextSelectionRight = 0
		}
		local nextSelectionLeft

		if k > 1 or v6 then
			nextSelectionLeft = v4[k - 1]
		end

		v9.NextSelectionLeft = nextSelectionLeft
		local nextSelectionRight

		if k < #v5 then
			nextSelectionRight = v4[k + 1]
		end

		v9.NextSelectionRight = nextSelectionRight
		children[k] = createElement(v8, v9)
	end

	if v7 and v2 and v then
		children[1] = React.createElement(Focusable[Pillv2], {
			layoutOrder = 2,
			key = "1",
			ref = v4[1],
			text = ""
		})
	end

	local function getScrollingListChildren()
		return {
			SubNavFrame = React.createElement(FitFrameHorizontal, {
				height = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				margin = FitFrame.Rect.quad(0, rightPadding, 0, leftPadding),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = v3
			}, children)
		}
	end

	local buttonRefs = {}

	for i = 1, #v5 do
		buttonRefs[i] = v4[i]
	end

	local createElement = React.createElement
	local v8 = not v and "Frame" or Focusable.Frame
	local v9 = {
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		ref = props.forwardRef,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		defaultChild = 0
	}
	local defaultChild

	if v then
		defaultChild = v4[1]
	end

	v9.defaultChild = defaultChild
	return createElement(v8, v9, {
		ScrollingList = React.createElement(ScrollingListWithArrowsAndGradient, {
			getScollingListContent = getScrollingListChildren,
			listHeight = 52,
			scrollingFrameRef = ref,
			buttonRefs = buttonRefs,
			buttonPadding = 8,
			padOutsideEdges = false,
			hideGradient = true
		})
	})
end

return React.forwardRef(function(p, forwardRef)
	return React.createElement(PillGroup, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
