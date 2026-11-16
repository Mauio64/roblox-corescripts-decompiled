local parent = script:FindFirstAncestor("PeekView").Parent

local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local AppCommonLib2 = require(parent.AppCommonLib)
local Symbol = AppCommonLib2.Symbol

local FitChildren = {}

FitChildren.FitAxis = {
	Width = Symbol.named("Width"),
	Height = Symbol.named("Height"),
	Both = Symbol.named("Both")
}

function FitChildren.wrap(p)
	local extended = Roact.PureComponent:extend(("FitChildren(%s)"):format((tostring(p))))

	function extended:disconnectSignals()
		for _, signal in ipairs(self.signals) do
			signal:Disconnect()
		end
	end

	function extended:resize()
		local v = self.props.fitFields

		if not v then
			if self.props.fitAxis then
				v = { Size = self.props.fitAxis }
			else
				v = { Size = FitChildren.FitAxis.Both }
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
			local function update() -- 1 equivalent call inferred from this helper
				local absoluteContentSize = uiGridStyleLayout.AbsoluteContentSize
				self:applyFit(v, absoluteContentSize.x, absoluteContentSize.y)
			end
			local absoluteContentSizeChangedConnection = uiGridStyleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
			table.insert(self.signals, absoluteContentSizeChangedConnection)
			update() -- inferred equivalent call
		else
			self:resizeFromChildren(v)

			local children = current:GetChildren()

			for _, guiBase2d in ipairs(children) do
				if not guiBase2d:IsA("GuiBase2d") then
					continue
				end

				local sizeChangedConnection = guiBase2d:GetPropertyChangedSignal("Size"):Connect(function()
					self:resizeFromChildren(v)
				end)
				table.insert(self.signals, sizeChangedConnection)
				local positionChangedConnection = guiBase2d:GetPropertyChangedSignal("Position"):Connect(function()
					self:resizeFromChildren(v)
				end)
				table.insert(self.signals, positionChangedConnection)
			end
		end
	end

	function extended:resizeFromChildren(p2)
		local current = self.ref.current

		if current == nil then
			return
		end

		local absolutePosition = current.AbsolutePosition
		local children = current:GetChildren()
		local maxValue = 0
		local maxValue2 = 0

		for _, guiBase2d in ipairs(children) do
			if not guiBase2d:IsA("GuiBase2d") then
				continue
			end

			local absoluteSize = guiBase2d.AbsoluteSize
			local absolutePosition2 = guiBase2d.AbsolutePosition

			maxValue = math.max(maxValue, absolutePosition2.x - absolutePosition.x + absoluteSize.x)
			maxValue2 = math.max(maxValue2, absolutePosition2.y - absolutePosition.y + absoluteSize.y)
		end

		self:applyFit(p2, maxValue, maxValue2)
	end

	function extended:applyFit(items, p2, p3)
		local current = self.ref.current

		if current == nil then
			return
		end

		local uiPadding = current:FindFirstChildOfClass("UIPadding")
		local size = self.props.Size or UDim2.new(0, 0, 0, 0)
		local width = FitChildren.FitAxis.Width
		local height = FitChildren.FitAxis.Height

		local function calculateAxis(item, p4, p5, p6, p7, p8)
			if item ~= p4 and item ~= FitChildren.FitAxis.Both then
				return p6.Scale, p6.Offset
			end

			local v = 0

			if not uiPadding then
				return v, p5
			end

			local v2 = uiPadding[p7].Scale + uiPadding[p8].Scale
			local v3 = uiPadding[p7].Offset + uiPadding[p8].Offset

			if v2 ~= 1 then
				return v, (p5 + v3) / (1 - v2)
			end

			error("Can not apply FitChildren to a component with 100% padding width")
			return v, nil
		end

		for k, item in pairs(items) do
			local v, v2 = calculateAxis(item, width, p2, size.X, "PaddingLeft", "PaddingRight")
			local v3, v4 = calculateAxis(item, height, p3, size.Y, "PaddingTop", "PaddingBottom")

			current[k] = UDim2.new(v, v2, v3, v4)
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

	function extended.render(p2)
		local refsByRef = Immutable.RemoveFromDictionary(p2.props, "fitAxis", "fitFields", "forwardRef")
		refsByRef[Roact.Ref] = p2.ref

		return Roact.createElement(p, refsByRef)
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

	return Roact.forwardRef(function(p2, forwardRef)
		return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = forwardRef }))
	end)
end

FitChildren.FitFrame = FitChildren.wrap("Frame")
FitChildren.FitScrollingFrame = FitChildren.wrap("ScrollingFrame")
FitChildren.FitTextButton = FitChildren.wrap("TextButton")

return FitChildren
