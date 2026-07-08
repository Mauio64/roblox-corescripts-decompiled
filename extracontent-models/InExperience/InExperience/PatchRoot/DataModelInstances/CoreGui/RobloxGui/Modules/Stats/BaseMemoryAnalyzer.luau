local color3 = Color3.new(0.35, 0.55, 0.35)
local color3_2 = Color3.new(0.15, 0.35, 0.15)
local color3_3 = Color3.new(1, 1, 1)
local color3_4 = Color3.new(1, 1, 1)
local color3_5 = Color3.new(1, 1, 1)
local uDim2 = UDim2.new(0, 0, 0, 0)
local uDim2_2 = UDim2.new(1, -18, 0, 2)
local uDim2_3 = UDim2.new(0, 16, 0, 16)
local uDim2_4 = UDim2.new(1, -100, 0, 0)
local uDim2_5 = UDim2.new(0, 100, 0, 20)

game:GetService("CoreGui")

local function __StyleAndSizeButton(p1) -- line: 36
	-- upvalues: color3_3 (copy), color3_5 (copy), uDim2_2 (copy), uDim2_3 (copy)
	p1.TextXAlignment = Enum.TextXAlignment.Center
	p1.TextColor3 = color3_3
	p1.BackgroundTransparency = 1
	p1.BorderColor3 = color3_5
	p1.BorderSizePixel = 1
	p1.Position = uDim2_2
	p1.Size = uDim2_3
end
local function __StyleAndSizeLabel(p2) -- line: 47
	-- upvalues: color3_3 (copy)
	p2.TextXAlignment = Enum.TextXAlignment.Left
	p2.TextColor3 = color3_3
	p2.BackgroundTransparency = 1
	p2.Position = UDim2.new(0, 5, 0, 0)
	p2.Size = UDim2.new(1, -10, 1, 0)
end
local function __StyleRowCellFrame(p3) -- line: 56
	-- upvalues: color3_4 (copy)
	p3.BorderColor3 = color3_4
	p3.BorderSizePixel = 1
	p3.BackgroundTransparency = 0.6
end

local t1 = {}

t1.__index = t1

function t1.new(p4) -- line: 74
	-- upvalues: t1 (copy), uDim2 (copy), color3_4 (copy), color3_3 (copy), color3_5 (copy), uDim2_2 (copy), uDim2_3 (copy), uDim2_4 (copy), uDim2_5 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._treeViewItem = p4
	t2._expanded = true
	t2._expansionToggleCallback = nil
	t2._frame = Instance.new("Frame")
	t2._frame.Name = "MemoryAnalyzerRowClassFrame"
	t2._frame.BackgroundTransparency = 1
	t2._buttonFrame = Instance.new("Frame")
	t2._buttonFrame.Name = "ButtonFrame"
	t2._buttonFrame.Parent = t2._frame
	t2._buttonFrame.Position = uDim2

	local v21 = (1 + p4:getStackDepth()) * 20

	t2._buttonFrame.Size = UDim2.new(0, v21, 0, 20)

	local _buttonFrame = t2._buttonFrame

	_buttonFrame.BorderColor3 = color3_4
	_buttonFrame.BorderSizePixel = 1
	_buttonFrame.BackgroundTransparency = 0.6
	t2._button = Instance.new("TextButton")
	t2._button.Name = "Button"
	t2._button.Parent = t2._buttonFrame

	local _button = t2._button

	_button.TextXAlignment = Enum.TextXAlignment.Center
	_button.TextColor3 = color3_3
	_button.BackgroundTransparency = 1
	_button.BorderColor3 = color3_5
	_button.BorderSizePixel = 1
	_button.Position = uDim2_2
	_button.Size = uDim2_3
	t2._button.MouseButton1Click:connect(function() -- line: 102
		-- upvalues: t2 (copy)
		t2:__toggleExpansion()
	end)
	t2:__updateButtonState()
	t2._labelFrame = Instance.new("Frame")
	t2._labelFrame.Name = "LabelFrame"
	t2._labelFrame.Parent = t2._frame
	t2._labelFrame.Position = UDim2.new(0, v21, 0, 0)
	t2._labelFrame.Size = UDim2.new(1, -v21 - 100, 0, 20)

	local _labelFrame = t2._labelFrame

	_labelFrame.BorderColor3 = color3_4
	_labelFrame.BorderSizePixel = 1
	_labelFrame.BackgroundTransparency = 0.6
	t2._labelTextLabel = Instance.new("TextLabel")
	t2._labelTextLabel.Name = "Label"
	t2._labelTextLabel.Parent = t2._labelFrame

	local _labelTextLabel = t2._labelTextLabel

	_labelTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	_labelTextLabel.TextColor3 = color3_3
	_labelTextLabel.BackgroundTransparency = 1
	_labelTextLabel.Position = UDim2.new(0, 5, 0, 0)
	_labelTextLabel.Size = UDim2.new(1, -10, 1, 0)
	t2._labelTextLabel.Text = p4:getLabel()
	t2._valueFrame = Instance.new("Frame")
	t2._valueFrame.Name = "ValueFrame"
	t2._valueFrame.Parent = t2._frame
	t2._valueFrame.Position = uDim2_4
	t2._valueFrame.Size = uDim2_5

	local _valueFrame = t2._valueFrame

	_valueFrame.BorderColor3 = color3_4
	_valueFrame.BorderSizePixel = 1
	_valueFrame.BackgroundTransparency = 0.6
	t2._valueTextLabel = Instance.new("TextLabel")
	t2._valueTextLabel.Name = "Value"
	t2._valueTextLabel.Parent = t2._valueFrame

	local _valueTextLabel = t2._valueTextLabel

	_valueTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	_valueTextLabel.TextColor3 = color3_3
	_valueTextLabel.BackgroundTransparency = 1
	_valueTextLabel.Position = UDim2.new(0, 5, 0, 0)
	_valueTextLabel.Size = UDim2.new(1, -10, 1, 0)
	t2._valueHasBeenNonZero = false
	t2:updateValue()

	return t2
end
function t1.isExpanded(p5) -- line: 143
	return p5._expanded
end
function t1.valueHasBeenNonZero(p6) -- line: 147
	return p6._valueHasBeenNonZero
end
function t1.setExpansionToggleCallback(p7, p8) -- line: 151
	p7._expansionToggleCallback = p8
end
function t1.__toggleExpansion(p9) -- line: 155
	p9._expanded = not p9._expanded
	p9:__updateButtonState()

	if p9._expansionToggleCallback ~= nil then
		p9._expansionToggleCallback()
	end
end
function t1.__updateButtonState(p10) -- line: 164
	if #p10._treeViewItem:getChildren() == 0 then
		p10._button.Visible = false

		return
	end

	p10._button.Visible = true

	if p10._expanded then
		p10._button.Text = "-"

		return
	end

	p10._button.Text = "+"
end
function t1.updateValue(p11) -- line: 178
	if p11._treeViewItem:getValue() >= 0.001 then
		p11._valueHasBeenNonZero = true
	end

	p11._valueTextLabel.Text = string.format("%.3f", p11._treeViewItem:getValue())
end
function t1.setZIndex(p12, p13) -- line: 190
	p12._frame.ZIndex = p13
	p12._labelTextLabel.ZIndex = p13
	p12._valueTextLabel.ZIndex = p13
end
function t1.setRowValue(p14, p15) -- line: 196
	p14._valueTextLabel.Text = string.format("%.3f", p15)
end
function t1.getFrame(p16) -- line: 200
	return p16._frame
end
function t1.setRowNumber(p17, p18) -- line: 204
	-- upvalues: color3 (copy), color3_2 (copy)
	if p18 % 2 == 1 then
		p17._buttonFrame.BackgroundColor3 = color3
		p17._labelFrame.BackgroundColor3 = color3
		p17._valueFrame.BackgroundColor3 = color3

		return
	end

	p17._buttonFrame.BackgroundColor3 = color3_2
	p17._labelFrame.BackgroundColor3 = color3_2
	p17._valueFrame.BackgroundColor3 = color3_2
end

local t3 = {}

t3.__index = t3
t3.Indent = string.rep(" ", 4)

function t3.new(p19) -- line: 227
	-- upvalues: t3 (copy)
	local t4 = {}

	setmetatable(t4, t3)
	t4._frame = Instance.new("Frame")
	t4._frame.Name = "MemoryAnalyzerClassFrame"
	t4._frame.ZIndex = p19.ZIndex
	t4._frame.BackgroundTransparency = 1
	t4._rowsByTreeViewItem = {}
	t4._layoutDirty = false
	t4._heightChangedCallback = nil
	t4._heightInPix = 0
	t4._frame.Parent = p19

	return t4
end
function t3.getMemoryUsageTree(_) -- line: 254
	return nil
end
function t3.setHeightChangedCallback(p21, p22) -- line: 258
	p21._heightChangedCallback = p22
end
function t3.__getOrMakeRowForTreeViewItem(p23, p24) -- line: 262
	-- upvalues: t1 (copy)
	if p23._rowsByTreeViewItem[p24] == nil then
		local v49 = t1.new(p24)

		v49:setExpansionToggleCallback(function() -- line: 265
			-- upvalues: p23 (copy)
			p23:__layoutRows()
		end)
		v49:getFrame().Parent = p23._frame
		p23._rowsByTreeViewItem[p24] = v49
		p23._layoutDirty = true
	end

	return p23._rowsByTreeViewItem[p24]
end
function t3.__recursiveUpdateStatValue(p25, p26) -- line: 277
	p25:__getOrMakeRowForTreeViewItem(p26):updateValue()

	local v52 = p26:getChildren()

	for _, v in ipairs(v52) do
		p25:__recursiveUpdateStatValue(v)
	end
end
function t3.renderUpdates(p27) -- line: 288
	local v56 = p27:getMemoryUsageTree()

	if v56 ~= nil then
		p27:__recursiveUpdateStatValue(v56)
	end

	if p27._layoutDirty then
		p27:__layoutRows()
	end
end
function t3.__layoutRows(p28) -- line: 300
	p28._layoutDirty = false
	p28._heightInPix = 0

	if p28:getMemoryUsageTree() ~= nil then
		p28:__recursiveLayoutTreeViewItem(p28:getMemoryUsageTree(), true)
	end

	p28._frame.Size = UDim2.new(1, 0, 0, p28._heightInPix)
	p28._frame.Position = UDim2.new(0, 0, 0, 0)

	if p28._heightChangedCallback then
		p28._heightChangedCallback(p28._heightInPix)
	end
end
function t3.__recursiveLayoutTreeViewItem(p29, p30, p31) -- line: 317
	local v61 = p29:__getOrMakeRowForTreeViewItem(p30)
	local v62 = v61:getFrame()
	local v63 = p31 and v61:valueHasBeenNonZero()

	if v63 then
		v62.Visible = true
		v62.Size = UDim2.new(1, 0, 0, 20)
		v62.Position = UDim2.new(0, 0, 0, p29._heightInPix)
		v61:setZIndex(p29._frame.ZIndex)
		v61:setRowNumber(p29._heightInPix / 20)
		p29._heightInPix = p29._heightInPix + 20
	else
		v62.Visible = false
	end

	local v64 = p30:getChildren()

	for _, v in ipairs(v64) do
		p29:__recursiveLayoutTreeViewItem(v, v61:isExpanded() and v63)
	end
end
function t3.getHeightInPix(p32) -- line: 343
	return p32._heightInPix
end

return t3
