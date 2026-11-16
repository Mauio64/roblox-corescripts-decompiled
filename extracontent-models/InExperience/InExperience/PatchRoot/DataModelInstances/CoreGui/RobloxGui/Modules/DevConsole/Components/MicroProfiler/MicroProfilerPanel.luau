local CorePackages = game:GetService("CorePackages")

local BoxButton = require(script.Parent.Parent.BoxButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local Immutable = require(script.Parent.Parent.Parent.Immutable)
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("MicroProfilerPanel")

function extended:createTabSelector(props)
	local size = props.Size
	local position = props.Position or UDim2.new(0, 0, 0, 0)
	local buttonSize = props.ButtonSize
	local layoutOrder = props.LayoutOrder

	local function createHighlight(name: string, k: number)
		if self.state.CurrentSection == name then
			return (Roact.createElement("Frame", {
				Size = UDim2.new(
					0,
					Constants.MicroProfilerFormatting.TabButtonWidth,
					0,
					Constants.MicroProfilerFormatting.TabButtonPad
				),
				Position = UDim2.new(
					0,
					Constants.MicroProfilerFormatting.TabButtonWidth * (k - 1),
					0,
					Constants.MicroProfilerFormatting.TabsHeight - Constants.MicroProfilerFormatting.TabButtonPad
				),
				BorderSizePixel = 0,
				BackgroundColor3 = Constants.Color.HighlightBlue,
				ZIndex = 10
			}))
		end

		return nil
	end

	local children = {}

	for k, section in self.props.Sections do
		children[`Button_{string.format("%02d", k)}`] = Roact.createElement(BoxButton, {
			text = section.Name,
			size = buttonSize,
			pos = UDim2.new(0, (k - 1) * buttonSize.X.Offset, 0, 0),
			onClicked = function()
				self:setState({ CurrentSection = section.Name })
			end
		})

		children[`ButtonHighlight_{string.format("%02d", k)}`] = createHighlight(section.Name, k)
	end

	return Roact.createElement(
		"Frame",
		{ Size = size, Position = position, BackgroundTransparency = 1, LayoutOrder = layoutOrder },
		children
	)
end

function extended:init()
	assert(self.props.Sections[1] ~= nil, "MicroProfilerPanel requires at least one section.")

	self.state = { CurrentSection = self.props.Sections[1].Name }
end

function extended:render()
	assert(self.props.Sections[1] ~= nil, "MicroProfilerPanel requires at least one section.")

	local sections = self.props.Sections

	local v = {}

	for _, section in sections do
		v[section.Name] = {}

		for k, row in section.Rows do
			v[section.Name][`Row_{string.format("%02d", k)}`] = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, Constants.MicroProfilerFormatting.OptionRowHeight),
				BackgroundTransparency = 1,
				LayoutOrder = k * 2
			}, row)

			if k < #section.Rows then
				v[section.Name][`HorizontalLine_{string.format("%02d", k)}`] = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					LayoutOrder = k * 2 + 1
				})
			end
		end
	end

	local createElement = Roact.createElement

	local v2 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = self.props.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local v3 = {}
	v3.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top
	})

	v3.Title = Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, Constants.MicroProfilerFormatting.PanelTitleHeight),
		BackgroundTransparency = 1,
		Text = self.props.Title,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Constants.Font.MainWindowBold,
		TextSize = Constants.MicroProfilerFormatting.TextSizePanelTitle,
		TextColor3 = Color3.new(1, 1, 1),
		LayoutOrder = 1
	})
	local tabs

	if #sections > 1 then
		tabs = self:createTabSelector({
			Size = UDim2.new(1, 0, 0, Constants.MicroProfilerFormatting.TabsHeight),
			Position = UDim2.new(0, 0, 0, 0),
			LayoutOrder = 2,
			ButtonSize = UDim2.new(0, Constants.MicroProfilerFormatting.TabButtonWidth, 1, 0)
		})
	end

	v3.Tabs = tabs

	v3[`Table_{self.state.CurrentSection}`] = Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			AutomaticSize = Enum.AutomaticSize.Y
		},
		Immutable.JoinDictionaries({
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			UIStroke = Roact.createElement("UIStroke", {
				Color = Color3.new(1, 1, 1),
				Thickness = 1,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner
			})
		}, v[self.state.CurrentSection])
	)
	return createElement("Frame", v2, v3)
end

return extended
