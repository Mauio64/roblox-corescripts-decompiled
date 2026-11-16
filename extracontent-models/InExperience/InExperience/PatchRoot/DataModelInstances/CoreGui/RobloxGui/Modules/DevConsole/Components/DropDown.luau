local CorePackages = game:GetService("CorePackages")
local v = game:GetService("CoreGui")
v = v.RobloxGui
local Roact = require(CorePackages.Packages.Roact)

local defineFastFlag = game:DefineFastFlag("DevConsoleDropdownFlipFix", false)
local defineFastFlag2 = game:DefineFastFlag("DevConsoleDropdownMultiSelect", false)

local Constants = require(script.Parent.Parent.Constants)
local UtilBar = Constants.Font.UtilBar
local utilBar = Constants.DefaultFontSize.UtilBar
local DropDownArrowHeight = Constants.GeneralFormatting.DropDownArrowHeight
local halfDropDownArrowHeight = DropDownArrowHeight / 2
local DownArrow = Constants.Image.DownArrow

local extended = Roact.Component:extend("DropDown")

function extended:init()
	if defineFastFlag then
		local GuiService = game:GetService("GuiService")
		self.guiInset = GuiService:GetGuiInset()
	end

	function self.onMainButtonPressed(_, _)
		self:setState({ showDropDown = true })
	end

	function self.nonDropDownSelection(_, p)
		if
			p.UserInputType == Enum.UserInputType.MouseButton1
			or p.UserInputType == Enum.UserInputType.Touch and p.UserInputState == Enum.UserInputState.End
		then
			self:setState({ showDropDown = false })
		end
	end

	self.state = { showDropDown = false }

	self.ref = Roact.createRef()
end

function extended.render(props)
	local buttonSize = props.props.buttonSize
	local dropDownList = props.props.dropDownList
	local selectedIndex = props.props.selectedIndex

	local onSelection = props.props.onSelection
	local layoutOrder = props.props.layoutOrder

	local selectedSet = props.props.selectedSet
	local onToggle = props.props.onToggle
	local v2 = defineFastFlag2 and onToggle ~= nil
	local target = props.props.dropDownTargetParent

	local dropDown2 = props.ref.current and props.state.showDropDown

	local children = {}

	local total = 0
	local v3, udim, udim2

	if props.ref.current and dropDown2 then
		local absolutePosition = props.ref.current.AbsolutePosition
		local absoluteSize = props.ref.current.AbsoluteSize

		v3 = absoluteSize.X

		children.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})

		for k, dropDown in pairs(dropDownList) do
			local v4

			if v2 then
				if selectedSet == nil then
					v4 = false
				else
					v4 = selectedSet[k] == true
				end
			else
				v4 = k == selectedIndex
			end

			local selectedGray = v4 and Constants.Color.SelectedGray or Constants.Color.UnselectedGray

			children[dropDown] = Roact.createElement("TextButton", {
				Size = buttonSize,
				Text = dropDown,
				TextColor3 = Constants.Color.Text,
				TextSize = utilBar,
				Font = UtilBar,
				AutoButtonColor = false,
				BackgroundColor3 = selectedGray,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				LayoutOrder = k,
				[Roact.Event.Activated] = function()
					if v2 then
						onToggle(k)
						return
					end

					onSelection(k)
					props:setState({ showDropDown = false })
				end
			})

			total += absoluteSize.Y
		end

		local v4 = total + 24

		if defineFastFlag then
			local currentCamera = workspace.CurrentCamera
			local v5 = (currentCamera and currentCamera.ViewportSize.Y or 1e999) - props.guiInset.Y - (absolutePosition.Y + absoluteSize.Y)
			local y = absolutePosition.Y
			local v6

			if v5 < v4 then
				v6 = v5 < y
			else
				v6 = false
			end

			udim = UDim2.new(0, v3 + 24, 0, v4)

			if v6 then
				udim2 = UDim2.new(0, absolutePosition.X, 0, absolutePosition.Y - v4)
			else
				udim2 = UDim2.new(0, absolutePosition.X, 0, absolutePosition.Y + absoluteSize.Y)
			end
		else
			udim = UDim2.new(0, v3 + 24, 0, total + 24)
			udim2 = UDim2.new(0, absolutePosition.X, 0, absolutePosition.Y + absoluteSize.Y)
		end
	else
		v3 = 0
	end

	local createElement = Roact.createElement
	local position

	if defineFastFlag then
		position = props.props.position or UDim2.new() or nil
	end

	local text

	if v2 then
		text = props.props.summaryText or ""
	else
		text = dropDownList[selectedIndex]
	end

	local v4 = {
		Size = buttonSize,
		Position = position,
		Text = text,
		TextColor3 = Constants.Color.Text,
		TextSize = utilBar,
		Font = UtilBar,
		AutoButtonColor = false,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		BackgroundTransparency = 0,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = props.onMainButtonPressed,
		[Roact.Ref] = props.ref
	}
	local v5 = {
		arrow = Roact.createElement("ImageLabel", {
			Image = DownArrow,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, DropDownArrowHeight, 0, DropDownArrowHeight),
			Position = UDim2.new(1, -DropDownArrowHeight - halfDropDownArrowHeight, 0.5, -halfDropDownArrowHeight)
		}),
		DropDown = 0
	}

	if dropDown2 then
		local createElement2 = Roact.createElement
		local portal = Roact.Portal

		if target == nil or not target then
			local CoreGui = game:GetService("CoreGui")
			target = CoreGui.DevConsoleMaster
		end

		dropDown2 = createElement2(portal, { target = target }, {
			InputCatcher = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					[Roact.Event.InputEnded] = props.nonDropDownSelection
				},
				{
					OuterFrame = Roact.createElement("ImageButton", {
						Size = udim,
						AutoButtonColor = false,
						Position = udim2,
						BackgroundColor3 = Constants.Color.TextBoxGray,
						BackgroundTransparency = 0
					}, {
						innerFrame = Roact.createElement(
							"Frame",
							{
								Position = UDim2.new(0, 12, 0, 12),
								Size = UDim2.new(0, v3, 0, total),
								BackgroundTransparency = 1
							},
							children
						)
					})
				}
			)
		})
	end

	v5.DropDown = dropDown2
	return createElement("TextButton", v4, v5)
end

return extended
