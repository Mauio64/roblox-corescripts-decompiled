local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Components
local LabeledCheckbox = require(Components.LabeledCheckbox)
local CheckboxDropdown = require(Components.CheckboxDropdown)

local Constants = require(script.Parent.Parent.Constants)
local CheckboxHeight = Constants.UtilityBarFormatting.CheckboxHeight
local v = Constants.UtilityBarFormatting.CheckboxInnerPadding * 2
local FilterUnfilled = Constants.Image.FilterUnfilled
local FilterFilled = Constants.Image.FilterFilled

local extended = Roact.PureComponent:extend("CheckboxContainer")

function extended:init()
	function self.onCheckboxClicked(p, p2)
		self.props.onCheckboxChanged(p, p2)
	end

	function self.onCheckboxExpanded(_, p)
		if
			p.UserInputType == Enum.UserInputType.MouseButton1
			or p.UserInputType == Enum.UserInputType.Touch and p.UserInputState == Enum.UserInputState.End
		then
			self:setState({ expanded = true })
		end
	end

	function self.onCloseCheckbox(_, p)
		if
			p.UserInputType == Enum.UserInputType.MouseButton1
			or p.UserInputType == Enum.UserInputType.Touch and p.UserInputState == Enum.UserInputState.End
		then
			self:setState({ expanded = false })
		end
	end

	if not self.props.orderedCheckboxState then
		warn("CheckboxContainer must be passed a list of Box Names or else it only creates an empty frame")
	end

	local textWidths = {}
	local minFullLength = 0
	local count = 0

	for i, v2 in ipairs(self.props.orderedCheckboxState) do
		local textSize = TextService:GetTextSize(
			v2.name,
			Constants.DefaultFontSize.UtilBar,
			Constants.Font.UtilBar,
			Vector2.new(0, 0)
		)

		textWidths[i] = textSize.X
		minFullLength = minFullLength + textSize.X + CheckboxHeight + v
		count += 1
	end

	self.ref = Roact.createRef()

	self.state = {
		expanded = false,
		textWidths = textWidths,
		numCheckboxes = count,
		minFullLength = minFullLength
	}
end

function extended.render(props)
	local frameWidth = props.props.frameWidth
	local frameHeight = props.props.frameHeight
	local pos = props.props.pos

	local layoutOrder = props.props.layoutOrder
	local orderedCheckboxState = props.props.orderedCheckboxState

	local minFullLength = props.state.minFullLength
	local expanded = props.state.expanded
	local numCheckboxes = props.state.numCheckboxes
	local children = {}
	local v2 = false

	for i, v3 in ipairs(orderedCheckboxState) do
		children[v3.name] = Roact.createElement(LabeledCheckbox, {
			name = v3.name,
			font = Constants.Font.UtilBar,
			fontSize = Constants.DefaultFontSize.UtilBar,
			checkboxHeight = CheckboxHeight,
			frameHeight = frameHeight,
			layoutOrder = i,
			isSelected = v3.state,
			selectedColor = Constants.Color.SelectedBlue,
			unselectedColor = Constants.Color.UnselectedGray,
			onCheckboxClicked = props.onCheckboxClicked
		})

		v2 = v2 or v3.state
	end

	if not (frameWidth < minFullLength) then
		children.CheckboxLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Horizontal
		})

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(0, frameWidth, 0, frameHeight),
				Position = pos,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			},
			children
		)
	end

	children.CheckboxLayout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		FillDirection = Enum.FillDirection.Vertical
	})

	local v3 = props.ref.current and expanded
	local udim

	if v3 then
		local absolutePosition = props.ref.current.AbsolutePosition

		udim = UDim2.new(0, absolutePosition.X, 0, absolutePosition.Y + frameHeight + 3)
	end

	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0, frameHeight, 0, frameHeight),
		LayoutOrder = layoutOrder,
		Image = v3 and FilterFilled or FilterUnfilled,
		BackgroundTransparency = 1,
		BorderColor3 = Constants.Color.Text,
		[Roact.Event.InputEnded] = props.onCheckboxExpanded,
		[Roact.Ref] = props.ref
	}, {
		DropDown = v3 and Roact.createElement(CheckboxDropdown, {
			absolutePosition = udim,
			frameWidth = frameWidth,
			elementHeight = frameHeight,
			numElements = numCheckboxes,
			onCloseCheckbox = props.onCloseCheckbox
		}, children)
	})
end

return extended
