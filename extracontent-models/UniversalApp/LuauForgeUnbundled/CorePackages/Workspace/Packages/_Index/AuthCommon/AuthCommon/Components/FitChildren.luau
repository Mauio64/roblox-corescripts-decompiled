local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Immutable
local symbol = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Symbol

local v5 = {}

v5.FitAxis = {
	Width = symbol.named("Width"),
	Height = symbol.named("Height"),
	Both = symbol.named("Both")
}

function v5.wrap(p2)
	local extended = Roact.PureComponent:extend(("FitChildren(%s)"):format((tostring(p2))))

	function extended:disconnectSignals()
		for i, signal in ipairs(self.signals) do
			signal:Disconnect()
		end
	end

	function extended:resize()
		local v6 = self.props.fitFields

		if not v6 then
			if self.props.fitAxis then
				v6 = { Size = self.props.fitAxis }
			else
				v6 = { Size = v5.FitAxis.Both }
			end
		end

		self:disconnectSignals()
		self.signals = {}

		local current = self.ref.current

		if current == nil then
			return
		end

		local uiGridStyleLayout = current:FindFirstChildWhichIsA("UIGridStyleLayout")

		if uiGridStyleLayout then
			local function update()
				local absoluteContentSize = uiGridStyleLayout.AbsoluteContentSize
				self:applyFit(v6, absoluteContentSize.x, absoluteContentSize.y)
			end
			local absoluteContentSizeChangedConnection = uiGridStyleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
			table.insert(self.signals, absoluteContentSizeChangedConnection)
			local absoluteContentSize = uiGridStyleLayout.AbsoluteContentSize
			self:applyFit(v6, absoluteContentSize.x, absoluteContentSize.y)
		else
			self:resizeFromChildren(v6)

			local children = current:GetChildren()

			for i, guiBase2d in ipairs(children) do
				if not guiBase2d:IsA("GuiBase2d") then
					continue
				end

				local sizeChangedConnection = guiBase2d:GetPropertyChangedSignal("Size"):Connect(function()
					self:resizeFromChildren(v6)
				end)
				table.insert(self.signals, sizeChangedConnection)
				local positionChangedConnection = guiBase2d:GetPropertyChangedSignal("Position"):Connect(function()
					self:resizeFromChildren(v6)
				end)
				table.insert(self.signals, positionChangedConnection)
			end
		end
	end

	function extended:resizeFromChildren(p3)
		local current = self.ref.current

		if current == nil then
			return
		end

		local absolutePosition = current.AbsolutePosition
		local children = current:GetChildren()
		local maxValue = 0
		local maxValue2 = 0

		for i, guiBase2d in ipairs(children) do
			if not guiBase2d:IsA("GuiBase2d") then
				continue
			end

			local absoluteSize = guiBase2d.AbsoluteSize
			local absolutePosition2 = guiBase2d.AbsolutePosition

			maxValue = math.max(maxValue, absolutePosition2.x - absolutePosition.x + absoluteSize.x)
			maxValue2 = math.max(maxValue2, absolutePosition2.y - absolutePosition.y + absoluteSize.y)
		end

		self:applyFit(p3, maxValue, maxValue2)
	end

	function extended:applyFit(items, p4, p5)
		local current = self.ref.current

		if current == nil then
			return
		end

		local uiPadding = current:FindFirstChildOfClass("UIPadding")
		local size = self.props.Size or UDim2.new(0, 0, 0, 0)
		local width = v5.FitAxis.Width
		local height = v5.FitAxis.Height

		local function calculateAxis(item, p6, p7, p8, p9, p10)
			if item ~= p6 and item ~= v5.FitAxis.Both then
				return p8.Scale, p8.Offset
			end

			local v7 = 0

			if not uiPadding then
				return v7, p7
			end

			local v8 = uiPadding[p9].Scale + uiPadding[p10].Scale
			local v9 = uiPadding[p9].Offset + uiPadding[p10].Offset

			if v8 ~= 1 then
				return v7, (p7 + v9) / (1 - v8)
			end

			error("Can not apply FitChildren to a component with 100% padding width")
			return v7, nil
		end

		for k, item in pairs(items) do
			local v6, v7 = calculateAxis(item, width, p4, size.X, "PaddingLeft", "PaddingRight")
			local v8, v9 = calculateAxis(item, height, p5, size.Y, "PaddingTop", "PaddingBottom")

			current[k] = UDim2.new(v6, v7, v8, v9)
		end
	end

	function extended:init()
		self.signals = {}

		local forwardRef = self.props.forwardRef

		assert(
			type(forwardRef) ~= "function",
			("%s does not support function ref forwarding"):format((tostring(extended)))
		)

		self.ref = forwardRef or Roact.createRef()
	end

	function extended.render(p3)
		local refsByRef = immutable.RemoveFromDictionary(p3.props, "fitAxis", "fitFields", "forwardRef")
		refsByRef[Roact.Ref] = p3.ref

		return Roact.createElement(p2, refsByRef)
	end

	function extended:didMount()
		self:resize()
	end

	function extended:didUpdate()
		self:resize()
	end

	function extended:willUnmount()
		self:disconnectSignals()
	end

	return Roact.forwardRef(function(p3, p4)
		return Roact.createElement(extended, Cryo.Dictionary.join(p3, {
			forwardRef = p4
		}))
	end)
end

v5.FitFrame = v5.wrap("Frame")
v5.FitScrollingFrame = v5.wrap("ScrollingFrame")
v5.FitTextButton = v5.wrap("TextButton")

return v5
