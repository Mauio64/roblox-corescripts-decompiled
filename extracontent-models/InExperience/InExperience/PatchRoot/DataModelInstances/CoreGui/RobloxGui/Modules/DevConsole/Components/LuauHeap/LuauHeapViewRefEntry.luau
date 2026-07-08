local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)

require(script.Parent.LuauHeapTypes)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local RefEntryFrameHeight = Constants.LuauHeapFormatting.RefEntryFrameHeight
local _ = Constants.LuauHeapFormatting.DepthIndent
local ValueCellWidth = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local ValuePadding = Constants.LuauHeapFormatting.ValuePadding
local LuauHeapViewPathEntry = require(script.Parent.LuauHeapViewPathEntry)
local v15 = Roact.PureComponent:extend("LuauHeapViewRefEntry")

local function BorderedCellLabel(t1: {[any]: any}) -- line: 33
	-- upvalues: Roact (copy), CellLabel (copy), LineWidth (copy), ValuePadding (copy), LineColor (copy)
	return Roact.createFragment({
		Label = Roact.createElement(CellLabel, {
			richText = true,
			text = t1.text,
			size = t1.size,
			pos = t1.pos
		}),
		LeftBorder = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(UDim.new(0, LineWidth), t1.size.Y),
			Position = UDim2.fromOffset(-ValuePadding, 0) + t1.pos,
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = LineColor
		})
	})
end

function v15.init(p1) -- line: 51
	p1.state = {
		expanded = false
	}

	function p1.onButtonPress() -- line: 56
		-- upvalues: p1 (copy)
		p1:setState(function(p2) -- line: 57
			return {
				expanded = not p2.expanded
			}
		end)
	end
end
function v15.renderValues(_, p4) -- line: 65
	-- upvalues: ValueCellWidth (copy), ValuePadding (copy), RefEntryFrameHeight (copy), Roact (copy), BorderedCellLabel (copy)
	local t2 = {}
	local uDim2 = UDim2.new(ValueCellWidth, -ValuePadding, 0, RefEntryFrameHeight)
	local uDim2_2 = UDim2.new(1 - ValueCellWidth * #p4, ValuePadding, 0, 0)

	for v24, v25 in p4 do
		t2[tostring(v24)] = Roact.createElement(BorderedCellLabel, {
			text = tostring(v25),
			size = uDim2,
			pos = uDim2_2 + UDim2.fromScale(ValueCellWidth * (v24 - 1), 0)
		})
	end

	return t2
end
function v15.renderChildren(t3: {[any]: any}, t4: {[any]: any}) -- line: 80
	-- upvalues: Roact (copy), LuauHeapViewPathEntry (copy)
	local t5 = {}

	if t3.state.expanded and (t4 and #t4) then
		for i, v in ipairs(t4) do
			t5[i] = Roact.createElement(LuauHeapViewPathEntry, {
				depth = 1,
				layoutOrder = i,
				name = `Path #{ i }`,
				data = v
			})
		end
	end

	return t5
end
function v15.render(p5) -- line: 97
	-- upvalues: RefEntryFrameHeight (copy), ValueCellWidth (copy), Roact (copy), BannerButton (copy), CellLabel (copy), CellPadding (copy)
	local props = p5.props
	local v33 = props.size or UDim2.new(1, 0, 0, RefEntryFrameHeight)
	local v34 = props.layoutOrder or 0
	local data = props.data
	local t6 = {
		`{ data.Count }`,
		`{ data.Instances }`
	}
	local uDim = UDim.new(1 - ValueCellWidth * #t6, 0)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v33,
		LayoutOrder = v34,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			inset = 0,
			layoutOrder = -1,
			size = UDim2.new(1, 0, 0, RefEntryFrameHeight),
			isExpanded = p5.state.expanded,
			isExpandable = data.Paths and #data.Paths ~= 0,
			onButtonPress = p5.onButtonPress
		}, {
			name = Roact.createElement(CellLabel, {
				text = data.Name,
				size = UDim2.new(uDim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding, 0, 0)
			}),
			values = Roact.createFragment(p5:renderValues(t6))
		}),
		children = Roact.createFragment(p5:renderChildren(data.Paths))
	})
end

return v15
