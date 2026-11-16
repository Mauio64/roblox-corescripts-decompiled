local color = Color3.new(0.35, 0.55, 0.35)
local color2 = Color3.new(0.15, 0.35, 0.15)
local color3 = Color3.new(1, 1, 1)
local color4 = Color3.new(1, 1, 1)
local color5 = Color3.new(1, 1, 1)

local udim = UDim2.new(0, 0, 0, 0)

local udim2 = UDim2.new(1, -18, 0, 2)
local udim3 = UDim2.new(0, 16, 0, 16)

local udim4 = UDim2.new(1, -100, 0, 0)
local udim5 = UDim2.new(0, 100, 0, 20)

game:GetService("CoreGui")

local function __StyleAndSizeButton(button) -- 1 equivalent call inferred from this helper
	button.TextXAlignment = Enum.TextXAlignment.Center
	button.TextColor3 = color3
	button.BackgroundTransparency = 1
	button.BorderColor3 = color5
	button.BorderSizePixel = 1

	button.Position = udim2
	button.Size = udim3
end

local function __StyleAndSizeLabel(p) -- 2 equivalent calls inferred from this helper
	p.TextXAlignment = Enum.TextXAlignment.Left
	p.TextColor3 = color3
	p.BackgroundTransparency = 1

	p.Position = UDim2.new(0, 5, 0, 0)
	p.Size = UDim2.new(1, -10, 1, 0)
end

local function __StyleRowCellFrame(p) -- 3 equivalent calls inferred from this helper
	p.BorderColor3 = color4
	p.BorderSizePixel = 1
	p.BackgroundTransparency = 0.6
end

local class = {}
class.__index = class

function class.new(treeViewItem)
	local class2 = {}
	setmetatable(class2, class)

	class2._treeViewItem = treeViewItem

	class2._expanded = true
	class2._expansionToggleCallback = nil

	class2._frame = Instance.new("Frame")
	class2._frame.Name = "MemoryAnalyzerRowClassFrame"
	class2._frame.BackgroundTransparency = 1

	class2._buttonFrame = Instance.new("Frame")
	class2._buttonFrame.Name = "ButtonFrame"
	class2._buttonFrame.Parent = class2._frame
	class2._buttonFrame.Position = udim
	local v = (1 + treeViewItem:getStackDepth()) * 20
	class2._buttonFrame.Size = UDim2.new(0, v, 0, 20)
	__StyleRowCellFrame(class2._buttonFrame) -- inferred equivalent call

	class2._button = Instance.new("TextButton")
	class2._button.Name = "Button"
	class2._button.Parent = class2._buttonFrame
	__StyleAndSizeButton(class2._button) -- inferred equivalent call

	class2._button.MouseButton1Click:connect(function()
		class2:__toggleExpansion()
	end)

	class2:__updateButtonState()

	class2._labelFrame = Instance.new("Frame")
	class2._labelFrame.Name = "LabelFrame"
	class2._labelFrame.Parent = class2._frame

	class2._labelFrame.Position = UDim2.new(0, v, 0, 0)
	class2._labelFrame.Size = UDim2.new(1, -v - 100, 0, 20)
	__StyleRowCellFrame(class2._labelFrame) -- inferred equivalent call

	class2._labelTextLabel = Instance.new("TextLabel")
	class2._labelTextLabel.Name = "Label"
	class2._labelTextLabel.Parent = class2._labelFrame
	__StyleAndSizeLabel(class2._labelTextLabel) -- inferred equivalent call

	class2._labelTextLabel.Text = treeViewItem:getLabel()

	class2._valueFrame = Instance.new("Frame")
	class2._valueFrame.Name = "ValueFrame"
	class2._valueFrame.Parent = class2._frame
	class2._valueFrame.Position = udim4
	class2._valueFrame.Size = udim5
	__StyleRowCellFrame(class2._valueFrame) -- inferred equivalent call

	class2._valueTextLabel = Instance.new("TextLabel")
	class2._valueTextLabel.Name = "Value"
	class2._valueTextLabel.Parent = class2._valueFrame
	__StyleAndSizeLabel(class2._valueTextLabel) -- inferred equivalent call

	class2._valueHasBeenNonZero = false
	class2:updateValue()

	return class2
end

function class:isExpanded()
	return self._expanded
end

function class:valueHasBeenNonZero()
	return self._valueHasBeenNonZero
end

function class:setExpansionToggleCallback(expansionToggleCallback)
	self._expansionToggleCallback = expansionToggleCallback
end

function class:__toggleExpansion()
	self._expanded = not self._expanded
	self:__updateButtonState()

	if self._expansionToggleCallback ~= nil then
		self._expansionToggleCallback()
	end
end

function class:__updateButtonState()
	if #self._treeViewItem:getChildren() == 0 then
		self._button.Visible = false
		return
	end

	self._button.Visible = true

	if self._expanded then
		self._button.Text = "-"
	else
		self._button.Text = "+"
	end
end

function class:updateValue()
	if self._treeViewItem:getValue() >= 0.001 then
		self._valueHasBeenNonZero = true
	end

	self._valueTextLabel.Text = string.format("%.3f", self._treeViewItem:getValue())
end

function class:setZIndex(zIndex)
	self._frame.ZIndex = zIndex
	self._labelTextLabel.ZIndex = zIndex
	self._valueTextLabel.ZIndex = zIndex
end

function class:setRowValue(p)
	self._valueTextLabel.Text = string.format("%.3f", p)
end

function class:getFrame()
	return self._frame
end

function class:setRowNumber(p)
	if p % 2 == 1 then
		self._buttonFrame.BackgroundColor3 = color
		self._labelFrame.BackgroundColor3 = color
		self._valueFrame.BackgroundColor3 = color
	else
		self._buttonFrame.BackgroundColor3 = color2
		self._labelFrame.BackgroundColor3 = color2
		self._valueFrame.BackgroundColor3 = color2
	end
end

local BaseMemoryAnalyzer = {}
BaseMemoryAnalyzer.__index = BaseMemoryAnalyzer

BaseMemoryAnalyzer.Indent = string.rep(" ", 4)

function BaseMemoryAnalyzer.new(parent)
	local v = {}
	setmetatable(v, BaseMemoryAnalyzer)

	v._frame = Instance.new("Frame")
	v._frame.Name = "MemoryAnalyzerClassFrame"
	v._frame.ZIndex = parent.ZIndex
	v._frame.BackgroundTransparency = 1

	v._rowsByTreeViewItem = {}

	v._layoutDirty = false

	v._heightChangedCallback = nil
	v._heightInPix = 0

	v._frame.Parent = parent

	return v
end

function BaseMemoryAnalyzer:getMemoryUsageTree(): nil
	return nil
end

function BaseMemoryAnalyzer:setHeightChangedCallback(heightChangedCallback)
	self._heightChangedCallback = heightChangedCallback
end

function BaseMemoryAnalyzer:__getOrMakeRowForTreeViewItem(p)
	if self._rowsByTreeViewItem[p] ~= nil then
		return self._rowsByTreeViewItem[p]
	end

	local v = class.new(p)
	v:setExpansionToggleCallback(function()
		self:__layoutRows()
	end)
	local frame = v:getFrame()
	frame.Parent = self._frame

	self._rowsByTreeViewItem[p] = v
	self._layoutDirty = true

	return self._rowsByTreeViewItem[p]
end

function BaseMemoryAnalyzer:__recursiveUpdateStatValue(object)
	self:__getOrMakeRowForTreeViewItem(object):updateValue()

	local children = object:getChildren()

	for _, child in ipairs(children) do
		self:__recursiveUpdateStatValue(child)
	end
end

function BaseMemoryAnalyzer:renderUpdates()
	local memoryUsageTree = self:getMemoryUsageTree()

	if memoryUsageTree ~= nil then
		self:__recursiveUpdateStatValue(memoryUsageTree)
	end

	if self._layoutDirty then
		self:__layoutRows()
	end
end

function BaseMemoryAnalyzer:__layoutRows()
	self._layoutDirty = false
	self._heightInPix = 0

	if self:getMemoryUsageTree() ~= nil then
		self:__recursiveLayoutTreeViewItem(self:getMemoryUsageTree(), true)
	end

	self._frame.Size = UDim2.new(1, 0, 0, self._heightInPix)
	self._frame.Position = UDim2.new(0, 0, 0, 0)

	if self._heightChangedCallback then
		self._heightChangedCallback(self._heightInPix)
	end
end

function BaseMemoryAnalyzer:__recursiveLayoutTreeViewItem(object, p)
	local __getOrMakeRowForTreeViewItem = self:__getOrMakeRowForTreeViewItem(object)
	local frame = __getOrMakeRowForTreeViewItem:getFrame()

	local v = p and __getOrMakeRowForTreeViewItem:valueHasBeenNonZero()

	if v then
		frame.Visible = true
		frame.Size = UDim2.new(1, 0, 0, 20)
		frame.Position = UDim2.new(0, 0, 0, self._heightInPix)
		__getOrMakeRowForTreeViewItem:setZIndex(self._frame.ZIndex)
		__getOrMakeRowForTreeViewItem:setRowNumber(self._heightInPix / 20)

		self._heightInPix += 20
	else
		frame.Visible = false
	end

	local children = object:getChildren()

	for _, child in ipairs(children) do
		self:__recursiveLayoutTreeViewItem(child, __getOrMakeRowForTreeViewItem:isExpanded() and v)
	end
end

function BaseMemoryAnalyzer:getHeightInPix()
	return self._heightInPix
end

return BaseMemoryAnalyzer
