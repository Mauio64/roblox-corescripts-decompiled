local CorePackages = game:GetService("CorePackages")
local _ = game:GetService("CoreGui").RobloxGui
local Roact = require(CorePackages.Packages.Roact)
local v4 = game:DefineFastFlag("DevConsoleDropdownFlipFix", false)
local Constants = require(script.Parent.Parent.Constants)
local UtilBar = Constants.Font.UtilBar
local UtilBar2 = Constants.DefaultFontSize.UtilBar
local DropDownArrowHeight = Constants.GeneralFormatting.DropDownArrowHeight
local v9 = DropDownArrowHeight / 2
local DownArrow = Constants.Image.DownArrow
local v11 = Roact.Component:extend("DropDown")

function v11.init(p1) -- line: 18
	-- upvalues: v4 (copy), Roact (copy)
	if v4 then
		p1.guiInset = game:GetService("GuiService"):GetGuiInset()
	end

	function p1.onMainButtonPressed(_, _) -- line: 23
		-- upvalues: p1 (copy)
		p1:setState({
			showDropDown = true
		})
	end
	function p1.nonDropDownSelection(_, p5) -- line: 29
		-- upvalues: p1 (copy)
		if p5.UserInputType == Enum.UserInputType.MouseButton1 or p5.UserInputType == Enum.UserInputType.Touch and p5.UserInputState == Enum.UserInputState.End then
			p1:setState({
				showDropDown = false
			})
		end
	end

	p1.state = {
		showDropDown = false
	}
	p1.ref = Roact.createRef()
end
function v11.render(p6) -- line: 47
	-- upvalues: Roact (copy), Constants (copy), UtilBar2 (copy), UtilBar (copy), v4 (copy), DownArrow (copy), DropDownArrowHeight (copy), v9 (copy)
	local buttonSize = p6.props.buttonSize
	local dropDownList = p6.props.dropDownList
	local selectedIndex = p6.props.selectedIndex
	local onSelection = p6.props.onSelection
	local layoutOrder = p6.props.layoutOrder
	local dropDownTargetParent = p6.props.dropDownTargetParent
	local v20 = p6.ref.current and p6.state.showDropDown
	local t1 = {}
	local v22 = nil
	local uDim2 = nil
	local n1 = 0
	local n2 = 0

	if p6.ref.current and v20 then
		local AbsolutePosition = p6.ref.current.AbsolutePosition
		local AbsoluteSize = p6.ref.current.AbsoluteSize

		n2 = AbsoluteSize.X
		t1.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})

		for k, v in pairs(dropDownList) do
			local v30 = k == selectedIndex and Constants.Color.SelectedGray or Constants.Color.UnselectedGray

			t1[v] = Roact.createElement("TextButton", {
				Size = buttonSize,
				Text = v,
				TextColor3 = Constants.Color.Text,
				TextSize = UtilBar2,
				Font = UtilBar,
				AutoButtonColor = false,
				BackgroundColor3 = v30,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				LayoutOrder = k,
				[Roact.Event.Activated] = function() -- line: 94
					-- upvalues: onSelection (copy), k (copy), p6 (copy)
					onSelection(k)
					p6:setState({
						showDropDown = false
					})
				end
			})
			n1 += AbsoluteSize.Y
		end

		local v31 = n1 + 24

		if v4 then
			local CurrentCamera = workspace.CurrentCamera
			local v33 = (CurrentCamera and CurrentCamera.ViewportSize.Y or 1e999) - p6.guiInset.Y - (AbsolutePosition.Y + AbsoluteSize.Y)
			local AbsolutePositionY = AbsolutePosition.Y
			local v35 = v33 < v31 and v33 < AbsolutePositionY

			uDim2 = UDim2.new(0, n2 + 24, 0, v31)
			v22 = if not v35 then UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y + AbsoluteSize.Y) else UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y - v31)
		else
			uDim2 = UDim2.new(0, n2 + 24, 0, n1 + 24)
			v22 = UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y + AbsoluteSize.Y)
		end
	end

	return Roact.createElement("TextButton", {
		Size = buttonSize,
		Position = v4 and (p6.props.position or UDim2.new()) or nil,
		Text = dropDownList[selectedIndex],
		TextColor3 = Constants.Color.Text,
		TextSize = UtilBar2,
		Font = UtilBar,
		AutoButtonColor = false,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		BackgroundTransparency = 0,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = p6.onMainButtonPressed,
		[Roact.Ref] = p6.ref
	}, {
		arrow = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = DownArrow,
			Size = UDim2.new(0, DropDownArrowHeight, 0, DropDownArrowHeight),
			Position = UDim2.new(1, -DropDownArrowHeight - v9, 0.5, -v9)
		}),
		DropDown = v20 and Roact.createElement(Roact.Portal, {
			target = dropDownTargetParent ~= nil and dropDownTargetParent or game:GetService("CoreGui").DevConsoleMaster
		}, {
			InputCatcher = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				[Roact.Event.InputEnded] = p6.nonDropDownSelection
			}, {
				OuterFrame = Roact.createElement("ImageButton", {
					AutoButtonColor = false,
					BackgroundTransparency = 0,
					Size = uDim2,
					Position = v22,
					BackgroundColor3 = Constants.Color.TextBoxGray
				}, {
					innerFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 12, 0, 12),
						Size = UDim2.new(0, n2, 0, n1)
					}, t1)
				})
			})
		})
	})
end

return v11
