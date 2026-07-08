local CorePackages = game:GetService("CorePackages")
local Immutable = require(script.Parent.Parent.Parent.Immutable)
local Roact = require(CorePackages.Packages.Roact)
local LocalActionsView = require(script.Parent.LocalActionsView)
local RecentlyCapturedDumpsView = require(script.Parent.RecentlyCapturedDumpsView)
local RecordAndDumpView = require(script.Parent.RecordAndDumpView)
local v7 = Roact.Component:extend("Column")
local v8 = Roact.Component:extend("MicroProfilerView")

function v7.render(p1) -- line: 13
	-- upvalues: Roact (copy), Immutable (copy)
	local v10 = p1.props[Roact.Children]

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		LayoutOrder = p1.props.LayoutOrder
	}, Immutable.JoinDictionaries({
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 12),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}, v10))
end
function v8.render(p2) -- line: 35
	-- upvalues: Roact (copy), v7 (copy), LocalActionsView (copy), RecordAndDumpView (copy), RecentlyCapturedDumpsView (copy)
	return Roact.createElement("Frame", {
		Size = p2.props.Size,
		BackgroundTransparency = p2.props.BackgroundTransparency,
		LayoutOrder = p2.props.LayoutOrder
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			VerticalFlex = Enum.UIFlexAlignment.Fill
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		LeftColumn = Roact.createElement(v7, {
			LayoutOrder = 1
		}, {
			LocalActionsView = Roact.createElement(LocalActionsView, {
				LayoutOrder = 1
			}),
			RecordAndDumpView = Roact.createElement(RecordAndDumpView, {
				LayoutOrder = 2
			})
		}),
		RightColumn = Roact.createElement(v7, {
			LayoutOrder = 2
		}, {
			RecentlyCapturedDumpsView = Roact.createElement(RecentlyCapturedDumpsView)
		})
	})
end

return v8
