local parent = script.Parent.Parent

local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)

local success, result = pcall(function()
	return game:GetEngineFeature("TextBoundsRoundUp")
end)

local v = success and result

local TextService = game:GetService("TextService")
local function getTextHeight(text, textSize, font, p)
	if v then
		return TextService:GetTextSize(text, textSize, font, Vector2.new(p, 10000)).Y
	end

	return TextService:GetTextSize(text, textSize, font, Vector2.new(p, 10000)).Y + 2
end

local function getTextWidth(text, textSize, font)
	if v then
		return TextService:GetTextSize(text, textSize, font, Vector2.new(10000, 10000)).X
	end

	return TextService:GetTextSize(text, textSize, font, Vector2.new(10000, 10000)).X + 2
end

local function getFontTextBoundsAsync(text, textSize, font, width)
	local getTextBoundsParams = Instance.new("GetTextBoundsParams")
	getTextBoundsParams.Text = text
	getTextBoundsParams.Font = font
	getTextBoundsParams.Size = textSize
	getTextBoundsParams.Width = width

	local success2, result2 = pcall(function()
		return TextService:GetTextBoundsAsync(getTextBoundsParams)
	end)

	getTextBoundsParams:Destroy()

	if success2 and typeof(result2) == "Vector2" then
		return result2
	end

	return nil
end

local width2 = { FitToText = {} }

local extended = Roact.PureComponent:extend("FitTextLabel")

extended.defaultProps = {
	Font = Enum.Font.SourceSans,
	Text = "Label",
	TextSize = 12,
	TextWrapped = true,
	maximumWidth = 1e999
}

function extended:init()
	self.measurementId = 0
	self.mounted = false

	if Roact.Ref == "ref" then
		self.frameRef = self.props.forwardedRef or Roact.createRef()
	else
		self.frameRef = self.props[Roact.Ref] or Roact.createRef()
	end

	function self.onResize()
		if not self.frameRef.current then
			return
		end

		if typeof(self.props.Font) == "Font" then
			self:__resizeForFont(self.frameRef.current)
			return
		end

		self.measurementId += 1
		self.frameRef.current.Size = self:__getSize(self.frameRef.current)
	end
end

function extended:render()
	local v2 = self.props.onActivated and "TextButton" or "TextLabel"
	return Roact.createElement(v2, self:__getFilteredProps())
end

function extended:didMount()
	self.mounted = true
	self.onResize()
end

function extended.didUpdate(p)
	p.onResize()
end

function extended:willUnmount()
	self.mounted = false
	self.measurementId += 1
end

function extended:__getFilteredProps()
	local width = typeof(self.props.width) == "UDim" and self.props.width or UDim.new(0, 0)
	local v2 = {
		["width"] = nil,
		["width"] = nil,
		["width"] = nil,
		width = Cryo.None,
		maximumWidth = Cryo.None,
		onActivated = Cryo.None,
		forwardedRef = Cryo.None,
		Size = UDim2.new(width, UDim.new(0, 0)),
		[Roact.Ref] = self.frameRef
	}

	local children = Roact.Children
	v2[children] = Cryo.Dictionary.join(self.props[Roact.Children] or {}, {
		sizeConstraint = self.props.maximumWidth < 1e999 and Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(self.props.maximumWidth, 1e999)
		})
	})

	v2[Roact.Event.Activated] = self.props.onActivated

	v2[Roact.Change.AbsoluteSize] = function(p)
		if self.props[Roact.Change.AbsoluteSize] then
			self.props[Roact.Change.AbsoluteSize](p)
		end

		self.onResize()
	end

	if typeof(self.props.Font) == "Font" then
		v2.Font = Cryo.None
		v2.FontFace = self.props.Font
	end

	return Cryo.Dictionary.join(self.props, v2)
end

function extended:__resizeForFont(p)
	self.measurementId += 1
	local measurementId = self.measurementId

	local text = self.props.Text
	local textSize = self.props.TextSize
	local font = self.props.Font
	local maximumWidth = self.props.maximumWidth
	local v2 = self.props.width
	local width = math.max(maximumWidth < 1e999 and maximumWidth or 0, p.AbsoluteSize.X)

	task.spawn(function()
		if v2 == width2.FitToText then
			local fontTextBoundsAsync = getFontTextBoundsAsync(text, textSize, font, 10000)
			v2 = UDim.new(0, fontTextBoundsAsync and math.min(math.ceil(fontTextBoundsAsync.X), maximumWidth) or 0)
		end

		if not self.mounted or self.measurementId ~= measurementId then
			return
		end

		local fontTextBoundsAsync = getFontTextBoundsAsync(text, textSize, font, width)
		local y = fontTextBoundsAsync and math.ceil(fontTextBoundsAsync.Y) or textSize

		if not self.mounted or self.measurementId ~= measurementId or not self.frameRef.current then
			return
		end

		self.frameRef.current.Size = UDim2.new(v2, UDim.new(0, y))
	end)
end

function extended:__getSize(p)
	local maximumWidth = self.props.maximumWidth
	local v2 = self.props.width

	if v2 == width2.FitToText then
		local textWidth = getTextWidth(self.props.Text, self.props.TextSize, self.props.Font)
		v2 = UDim.new(0, (math.min(textWidth, maximumWidth)))
	end

	local v3 = math.max(maximumWidth < 1e999 and maximumWidth or 0, p.AbsoluteSize.X)
	local textHeight = getTextHeight(self.props.Text, self.props.TextSize, self.props.Font, v3)

	return UDim2.new(v2, UDim.new(0, textHeight))
end

local selected

if Roact.Ref == "ref" then
	selected = Roact.forwardRef(function(p, forwardedRef)
		return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardedRef = forwardedRef }))
	end)
else
	selected = extended
end

selected.Width = width2

return selected
