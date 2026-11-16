local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui
local Roact = require(CorePackages.Packages.Roact)

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local Constants = require(script.Parent.Parent.Constants)
local DropDownEntryHeight = Constants.GeneralFormatting.DropDownEntryHeight
local DropDownArrowHeight = Constants.GeneralFormatting.DropDownArrowHeight
local halfDropDownArrowHeight = DropDownArrowHeight / 2
local DownArrow = Constants.Image.DownArrow

local extended = Roact.Component:extend("FullScreenDropDownButton")

function extended:init()
	function self.startDropDownView()
		self:setState({ selectionScreenExpanded = true })
	end

	function self.noSelection(_, p)
		if
			p.UserInputType == Enum.UserInputType.MouseButton1
			or p.UserInputType == Enum.UserInputType.Touch and p.UserInputState == Enum.UserInputState.End
		then
			self:setState({ selectionScreenExpanded = false })
		end
	end

	self.state = { selectionScreenExpanded = false, guiSizeY = RobloxGui.AbsoluteSize.Y }
end

function extended.render(props)
	local buttonSize = props.props.buttonSize
	local dropDownList = props.props.dropDownList
	local selectedIndex = props.props.selectedIndex
	local onSelection = props.props.onSelection
	local layoutOrder = props.props.layoutOrder

	local selectionView = props.state.selectionScreenExpanded
	local target = props.props.portalTarget

	local children = {}
	local total = 16

	if selectionView then
		children.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Vertical
		})

		if dropDownList then
			for i, dropDown in ipairs(dropDownList) do
				local selectedGray = i == selectedIndex and Constants.Color.SelectedGray
					or Constants.Color.UnselectedGray

				children[i] = Roact.createElement("TextButton", {
					Text = dropDown,
					Font = Constants.Font.TabBar,
					TextSize = Constants.DefaultFontSize.DropDownTabBar,
					TextColor3 = Constants.Color.Text,
					AutoButtonColor = false,
					Size = UDim2.new(1, 0, 0, DropDownEntryHeight),
					BackgroundColor3 = selectedGray,
					LayoutOrder = i,
					BorderSizePixel = 0,
					[Roact.Event.Activated] = function(_)
						props:setState({ selectionScreenExpanded = false })

						onSelection(i)
					end
				})

				total += DropDownEntryHeight
			end
		end
	end

	local v = total - 16 - props.state.guiSizeY

	local createElement = Roact.createElement
	local startDropDownViewsByActivated = {
		Size = buttonSize,
		BackgroundColor3 = Constants.Color.UnselectedGray,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = props.startDropDownView
	}
	local v2 = {
		SizeChangeEvent = Roact.createElement(ExternalEventConnection, {
			event = RobloxGui:GetPropertyChangedSignal("AbsoluteSize"),
			callback = function()
				props:setState({ guiSizeY = RobloxGui.AbsoluteSize.Y })
			end
		}),
		text = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, -DropDownArrowHeight - halfDropDownArrowHeight, 1, 0),
			Text = dropDownList[selectedIndex],
			Font = Constants.Font.TabBar,
			TextSize = Constants.DefaultFontSize.DropDownTabBar,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1
		}),
		arrow = Roact.createElement("ImageLabel", {
			Image = DownArrow,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, DropDownArrowHeight, 0, DropDownArrowHeight),
			Position = UDim2.new(1, -DropDownArrowHeight - halfDropDownArrowHeight, 0.5, -halfDropDownArrowHeight)
		}),
		selectionView = 0
	}

	if selectionView then
		local createElement2 = Roact.createElement
		local portal = Roact.Portal

		if target == nil or not target then
			local CoreGui2 = game:GetService("CoreGui")
			target = CoreGui2.DevConsoleMaster
		end

		selectionView = createElement2(portal, { target = target }, {
			GreyOutFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Constants.Color.Black,
				BackgroundTransparency = 0.36,
				Active = true,
				[Roact.Event.InputEnded] = props.noSelection
			}, {
				BorderFrame = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(0, 375, 0, total),
						Position = UDim2.new(0.5, -187.5, 0, 0),
						BackgroundColor3 = Constants.Color.UnselectedGray,
						BorderSizePixel = 0
					},
					{
						SelectionFrame = Roact.createElement("ScrollingFrame", {
							Size = UDim2.new(1, -30, 1, -16),
							Position = UDim2.new(0, 15, 0, 8),
							BackgroundTransparency = 1,
							CanvasSize = UDim2.new(1, -30, 1, v),
							BorderSizePixel = 0,
							ScrollBarThickness = 0
						}, children)
					}
				)
			})
		})
	end

	v2.selectionView = selectionView
	return createElement("TextButton", startDropDownViewsByActivated, v2)
end

return extended
