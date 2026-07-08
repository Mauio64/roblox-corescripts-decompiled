local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)

require(script.Parent.LuauHeapTypes)

local Constants = require(script.Parent.Parent.Parent.Constants)
local _ = Constants.GeneralFormatting.LineWidth
local _ = Constants.GeneralFormatting.LineColor
local PathEntryFrameHeight = Constants.LuauHeapFormatting.PathEntryFrameHeight
local DepthIndent = Constants.LuauHeapFormatting.DepthIndent
local _ = Constants.LuauHeapFormatting.ValueCellWidth
local CellPadding = Constants.LuauHeapFormatting.CellPadding
local _ = Constants.LuauHeapFormatting.ValuePadding
local v14 = Roact.PureComponent:extend("LuauHeapViewPathEntry")

function v14.init(p1) -- line: 25
	p1.state = {
		expanded = false
	}

	function p1.onButtonPress() -- line: 30
		-- upvalues: p1 (copy)
		p1:setState(function(p2) -- line: 31
			return {
				expanded = not p2.expanded
			}
		end)
	end
end
function v14.renderChildren(p3, p4) -- line: 39
	-- upvalues: DepthIndent (copy), CellPadding (copy), Roact (copy), CellLabel (copy), PathEntryFrameHeight (copy)
	local t1 = {}
	local v19 = 2 * DepthIndent + CellPadding

	if p3.state.expanded and (p4 and #p4) then
		for i, v in ipairs(p4) do
			t1[i] = Roact.createElement(CellLabel, {
				text = v,
				layoutOrder = i,
				size = UDim2.new(UDim.new(1, -v19), UDim.new(0, PathEntryFrameHeight)),
				pos = UDim2.new(0, v19, 0, 0)
			})
		end
	end

	return t1
end
function v14.render(p5) -- line: 58
	-- upvalues: PathEntryFrameHeight (copy), DepthIndent (copy), Roact (copy), BannerButton (copy), CellLabel (copy), CellPadding (copy)
	local props = p5.props
	local v24 = props.size or UDim2.new(1, 0, 0, PathEntryFrameHeight)
	local v25 = props.layoutOrder or 0
	local name = props.name
	local data = props.data
	local v28 = props.depth * DepthIndent

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v24,
		LayoutOrder = v25,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		button = Roact.createElement(BannerButton, {
			layoutOrder = -1,
			size = UDim2.new(1, 0, 0, PathEntryFrameHeight),
			inset = v28,
			isExpanded = p5.state.expanded,
			isExpandable = #data ~= 0,
			onButtonPress = p5.onButtonPress
		}, {
			name = Roact.createElement(CellLabel, {
				text = name,
				size = UDim2.new(UDim.new(1, -v28), UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding + v28, 0, 0)
			})
		}),
		children = Roact.createFragment(p5:renderChildren(data))
	})
end

return v14
