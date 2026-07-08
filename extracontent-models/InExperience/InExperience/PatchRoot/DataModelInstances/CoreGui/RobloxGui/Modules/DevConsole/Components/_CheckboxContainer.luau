local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Components
local _Checkbox = require(Components._Checkbox)
local _CheckboxDropdown = require(Components._CheckboxDropdown)
local Constants = require(script.Parent.Parent.Constants)
local CheckboxHeight = Constants.UtilityBarFormatting.CheckboxHeight
local v9 = Constants.UtilityBarFormatting.CheckboxInnerPadding * 2
local FilterUnfilled = Constants.Image.FilterUnfilled
local FilterFilled = Constants.Image.FilterFilled
local v12 = Roact.PureComponent:extend("CheckboxContainer")

function v12.init(p1) -- line: 20
	-- upvalues: TextService (copy), Constants (copy), CheckboxHeight (copy), v9 (copy), Roact (copy)
	function p1.onCheckboxClicked(p2, p3) -- line: 21
		-- upvalues: p1 (copy)
		p1.props.onCheckboxChanged(p2, p3)
	end
	function p1.onCheckboxExpanded(_, p5) -- line: 27
		-- upvalues: p1 (copy)
		if p5.UserInputType == Enum.UserInputType.MouseButton1 or p5.UserInputType == Enum.UserInputType.Touch and p5.UserInputState == Enum.UserInputState.End then
			p1:setState({
				expanded = true
			})
		end
	end
	function p1.onCloseCheckbox(_, p7) -- line: 39
		-- upvalues: p1 (copy)
		if p7.UserInputType == Enum.UserInputType.MouseButton1 or p7.UserInputType == Enum.UserInputType.Touch and p7.UserInputState == Enum.UserInputState.End then
			p1:setState({
				expanded = false
			})
		end
	end

	if not p1.props.orderedCheckboxState then
		warn("CheckboxContainer must be passed a list of Box Names or else it only creates an empty frame")
	end

	local t1 = {}
	local n1 = 0
	local n2 = 0

	for i, v in ipairs(p1.props.orderedCheckboxState) do
		local TextSize = TextService:GetTextSize(v.name, Constants.DefaultFontSize.UtilBar, Constants.Font.UtilBar, Vector2.new(0, 0))

		t1[i] = TextSize.X
		n1 = n1 + TextSize.X + CheckboxHeight + v9
		n2 += 1
	end

	p1.ref = Roact.createRef()
	p1.state = {
		expanded = false,
		textWidths = t1,
		numCheckboxes = n2,
		minFullLength = n1
	}
end
function v12.render(p8) -- line: 79
	-- upvalues: Roact (copy), _Checkbox (copy), Constants (copy), CheckboxHeight (copy), FilterFilled (copy), FilterUnfilled (copy), _CheckboxDropdown (copy)
	local t2 = {}
	local frameWidth = p8.props.frameWidth
	local frameHeight = p8.props.frameHeight
	local pos = p8.props.pos
	local layoutOrder = p8.props.layoutOrder
	local orderedCheckboxState = p8.props.orderedCheckboxState
	local minFullLength = p8.state.minFullLength
	local expanded = p8.state.expanded
	local numCheckboxes = p8.state.numCheckboxes
	local v30 = false

	for i, v in ipairs(orderedCheckboxState) do
		t2[v.name] = Roact.createElement(_Checkbox, {
			name = v.name,
			font = Constants.Font.UtilBar,
			fontSize = Constants.DefaultFontSize.UtilBar,
			checkboxHeight = CheckboxHeight,
			frameHeight = frameHeight,
			layoutOrder = i,
			isSelected = v.state,
			selectedColor = Constants.Color.SelectedBlue,
			unselectedColor = Constants.Color.UnselectedGray,
			onCheckboxClicked = p8.onCheckboxClicked
		})
		v30 = v30 or v.state
	end

	if frameWidth < minFullLength then
		t2.CheckboxLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Vertical
		})

		local v33 = p8.ref.current and expanded
		local uDim2 = nil

		if v33 then
			local AbsolutePosition = p8.ref.current.AbsolutePosition

			uDim2 = UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y + frameHeight + 3)
		end

		return Roact.createElement("ImageButton", {
			Size = UDim2.new(0, frameHeight, 0, frameHeight),
			LayoutOrder = layoutOrder,
			Image = v33 and FilterFilled or FilterUnfilled,
			BackgroundTransparency = 1,
			BorderColor3 = Constants.Color.Text,
			[Roact.Event.InputEnded] = p8.onCheckboxExpanded,
			[Roact.Ref] = p8.ref
		}, {
			DropDown = v33 and Roact.createElement(_CheckboxDropdown, {
				absolutePosition = uDim2,
				frameWidth = frameWidth,
				elementHeight = frameHeight,
				numElements = numCheckboxes,
				onCloseCheckbox = p8.onCloseCheckbox
			}, t2)
		})
	end

	t2.CheckboxLayout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		FillDirection = Enum.FillDirection.Horizontal
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, frameWidth, 0, frameHeight),
		Position = pos,
		LayoutOrder = layoutOrder
	}, t2)
end

return v12
