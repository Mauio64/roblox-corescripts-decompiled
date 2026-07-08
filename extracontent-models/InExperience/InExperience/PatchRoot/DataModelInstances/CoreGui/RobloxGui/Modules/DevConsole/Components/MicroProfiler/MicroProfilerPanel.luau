local CorePackages = game:GetService("CorePackages")
local BoxButton = require(script.Parent.Parent.BoxButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local Immutable = require(script.Parent.Parent.Parent.Immutable)
local Roact = require(CorePackages.Packages.Roact)
local v6 = Roact.Component:extend("MicroProfilerPanel")

function v6.createTabSelector(p1, p2) -- line: 10
	-- upvalues: Roact (copy), Constants (copy), BoxButton (copy)
	local p2Size = p2.Size
	local v10 = p2.Position or UDim2.new(0, 0, 0, 0)
	local ButtonSize = p2.ButtonSize
	local p2LayoutOrder = p2.LayoutOrder

	local function createHighlight(s1: string, n1: number) -- line: 16
		-- upvalues: p1 (copy), Roact (copy), Constants (copy)
		if s1 == p1.state.CurrentSection then
			return (Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 10,
				Size = UDim2.new(0, Constants.MicroProfilerFormatting.TabButtonWidth, 0, Constants.MicroProfilerFormatting.TabButtonPad),
				Position = UDim2.new(0, Constants.MicroProfilerFormatting.TabButtonWidth * (n1 - 1), 0, Constants.MicroProfilerFormatting.TabsHeight - Constants.MicroProfilerFormatting.TabButtonPad),
				BackgroundColor3 = Constants.Color.HighlightBlue
			}))
		end

		return nil
	end

	local t1 = {}

	for v15, v16 in p1.props.Sections do
		t1[`Button_{ string.format("%02d", v15) }`] = Roact.createElement(BoxButton, {
			text = v16.Name,
			size = ButtonSize,
			pos = UDim2.new(0, (v15 - 1) * ButtonSize.X.Offset, 0, 0),
			onClicked = function() -- line: 44
				-- upvalues: p1 (copy), v16 (copy)
				p1:setState({
					CurrentSection = v16.Name
				})
			end
		})
		t1[`ButtonHighlight_{ string.format("%02d", v15) }`] = createHighlight(v16.Name, v15)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = p2Size,
		Position = v10,
		LayoutOrder = p2LayoutOrder
	}, t1)
end
function v6.init(p3) -- line: 59
	assert(p3.props.Sections[1] ~= nil, "MicroProfilerPanel requires at least one section.")
	p3.state = {
		CurrentSection = p3.props.Sections[1].Name
	}
end
function v6.render(p4) -- line: 67
	-- upvalues: Roact (copy), Constants (copy), Immutable (copy)
	assert(p4.props.Sections[1] ~= nil, "MicroProfilerPanel requires at least one section.")

	local Sections = p4.props.Sections
	local t2 = {}

	for _, v22 in Sections do
		t2[v22.Name] = {}

		for v23, v24 in v22.Rows do
			t2[v22.Name][`Row_{ string.format("%02d", v23) }`] = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Constants.MicroProfilerFormatting.OptionRowHeight),
				LayoutOrder = v23 * 2
			}, v24)

			if v23 < #v22.Rows then
				t2[v22.Name][`HorizontalLine_{ string.format("%02d", v23) }`] = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Color3.new(1, 1, 1),
					LayoutOrder = v23 * 2 + 1
				})
			end
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = p4.props.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, Constants.MicroProfilerFormatting.PanelTitleHeight),
			Text = p4.props.Title,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = Constants.Font.MainWindowBold,
			TextSize = Constants.MicroProfilerFormatting.TextSizePanelTitle,
			TextColor3 = Color3.new(1, 1, 1)
		}),
		Tabs = if not (#Sections > 1) then nil else p4:createTabSelector({
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, Constants.MicroProfilerFormatting.TabsHeight),
			Position = UDim2.new(0, 0, 0, 0),
			ButtonSize = UDim2.new(0, Constants.MicroProfilerFormatting.TabButtonWidth, 1, 0)
		}),
		[`Table_{ p4.state.CurrentSection }`] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, Immutable.JoinDictionaries({
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			UIStroke = Roact.createElement("UIStroke", {
				Thickness = 1,
				Color = Color3.new(1, 1, 1),
				BorderStrokePosition = Enum.BorderStrokePosition.Inner
			})
		}, t2[p4.state.CurrentSection]))
	})
end

return v6
