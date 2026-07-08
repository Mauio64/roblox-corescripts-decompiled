local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui").RobloxGui
local Roact = require(CorePackages.Packages.Roact)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local Constants = require(script.Parent.Parent.Constants)
local DropDownEntryHeight = Constants.GeneralFormatting.DropDownEntryHeight
local DropDownArrowHeight = Constants.GeneralFormatting.DropDownArrowHeight
local v8 = DropDownArrowHeight / 2
local DownArrow = Constants.Image.DownArrow
local v10 = Roact.Component:extend("FullScreenDropDownButton")

function v10.init(p1) -- line: 19
	-- upvalues: RobloxGui (copy)
	function p1.startDropDownView() -- line: 20
		-- upvalues: p1 (copy)
		p1:setState({
			selectionScreenExpanded = true
		})
	end
	function p1.noSelection(_, p3) -- line: 26
		-- upvalues: p1 (copy)
		if p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch and p3.UserInputState == Enum.UserInputState.End then
			p1:setState({
				selectionScreenExpanded = false
			})
		end
	end

	p1.state = {
		selectionScreenExpanded = false,
		guiSizeY = RobloxGui.AbsoluteSize.Y
	}
end
function v10.render(p4) -- line: 43
	-- upvalues: Roact (copy), Constants (copy), DropDownEntryHeight (copy), ExternalEventConnection (copy), RobloxGui (copy), DropDownArrowHeight (copy), v8 (copy), DownArrow (copy)
	local buttonSize = p4.props.buttonSize
	local dropDownList = p4.props.dropDownList
	local selectedIndex = p4.props.selectedIndex
	local onSelection = p4.props.onSelection
	local layoutOrder = p4.props.layoutOrder
	local selectionScreenExpanded = p4.state.selectionScreenExpanded
	local portalTarget = p4.props.portalTarget
	local t1 = {}
	local n1 = 16

	if selectionScreenExpanded then
		t1.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Vertical
		})

		if dropDownList then
			for i, v in ipairs(dropDownList) do
				local v24 = i == selectedIndex and Constants.Color.SelectedGray or Constants.Color.UnselectedGray

				t1[i] = Roact.createElement("TextButton", {
					Text = v,
					Font = Constants.Font.TabBar,
					TextSize = Constants.DefaultFontSize.DropDownTabBar,
					TextColor3 = Constants.Color.Text,
					AutoButtonColor = false,
					Size = UDim2.new(1, 0, 0, DropDownEntryHeight),
					BackgroundColor3 = v24,
					LayoutOrder = i,
					BorderSizePixel = 0,
					[Roact.Event.Activated] = function(_) -- line: 80
						-- upvalues: p4 (copy), onSelection (copy), i (copy)
						p4:setState({
							selectionScreenExpanded = false
						})
						onSelection(i)
					end
				})
				n1 += DropDownEntryHeight
			end
		end
	end

	local v25 = n1 - 16 - p4.state.guiSizeY

	return Roact.createElement("TextButton", {
		Size = buttonSize,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = p4.startDropDownView
	}, {
		SizeChangeEvent = Roact.createElement(ExternalEventConnection, {
			event = RobloxGui:GetPropertyChangedSignal("AbsoluteSize"),
			callback = function() -- line: 106
				-- upvalues: p4 (copy), RobloxGui (copy)
				p4:setState({
					guiSizeY = RobloxGui.AbsoluteSize.Y
				})
			end
		}),
		text = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -DropDownArrowHeight - v8, 1, 0),
			Text = dropDownList[selectedIndex],
			Font = Constants.Font.TabBar,
			TextSize = Constants.DefaultFontSize.DropDownTabBar,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextColor3 = Constants.Color.Text
		}),
		arrow = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = DownArrow,
			Size = UDim2.new(0, DropDownArrowHeight, 0, DropDownArrowHeight),
			Position = UDim2.new(1, -DropDownArrowHeight - v8, 0.5, -v8)
		}),
		selectionView = selectionScreenExpanded and Roact.createElement(Roact.Portal, {
			target = portalTarget ~= nil and portalTarget or game:GetService("CoreGui").DevConsoleMaster
		}, {
			GreyOutFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Constants.Color.Black,
				BackgroundTransparency = 0.36,
				Active = true,
				[Roact.Event.InputEnded] = p4.noSelection
			}, {
				BorderFrame = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, 375, 0, n1),
					Position = UDim2.new(0.5, -187.5, 0, 0),
					BackgroundColor3 = Constants.Color.UnselectedGray
				}, {
					SelectionFrame = Roact.createElement("ScrollingFrame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ScrollBarThickness = 0,
						Size = UDim2.new(1, -30, 1, -16),
						Position = UDim2.new(0, 15, 0, 8),
						CanvasSize = UDim2.new(1, -30, 1, v25)
					}, t1)
				})
			})
		})
	})
end

return v10
