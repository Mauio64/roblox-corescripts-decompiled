local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Cryo = require(parent3.Cryo)

local withStyle = require(parent2.Core.Style.withStyle)

local ControllerBarHint = require(script.Parent.ControllerBarHint)

local GetTextSize = require(parent2.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent2.Core.Text.GetFontFromFontStyle)

local BarConstants = require(script.Parent.BarConstants)
local ControllerBarHintInternalPadding = BarConstants.ControllerBarHintInternalPadding
local MenuConstants = require(parent.Menu.MenuConstants)
local DefaultKeyLabelSize = MenuConstants.DefaultKeyLabelSize

local extended = Roact.PureComponent:extend("ControllerBar")

local strictInterface = t.strictInterface({ keyCode = t.enum(Enum.KeyCode), text = t.string })

extended.validateProps = t.strictInterface({
	leftHint = strictInterface,
	rightHints = t.optional(t.map(t.number, strictInterface))
})

function extended:init()
	self.state = {
		controllerBarWidth = 0,
		hintStringsConcat = nil,
		requiredSpace = nil,
		hintRatios = nil
	}
end

function extended.calculateHintRatios(p, options)
	local joined = Cryo.List.join({ p }, options or {})
	local result = {}
	local total = 0
	local v = 84
	local v2 = ""

	for _, v3 in ipairs(joined) do
		result[v3.text] = GetTextSize(v3.text, 17, Enum.Font.ArialBold, Vector2.new(10000, 10000)).X

		total += result[v3.text]

		v = v + DefaultKeyLabelSize + ControllerBarHintInternalPadding

		v2 ..= v3.text
	end

	for k, v3 in pairs(result) do
		result[k] = v3 / total
	end

	return result, v + math.max(#joined - 2, 0) * 40, v2
end

function extended.getDerivedStateFromProps(p)
	local hintRatios, requiredSpace, hintStringsConcat = extended.calculateHintRatios(p.leftHint, p.rightHints)

	return {
		hintRatios = hintRatios,
		requiredSpace = requiredSpace,
		hintStringsConcat = hintStringsConcat
	}
end

function extended:calculateHintSize(p, p2)
	local v = p - self.state.requiredSpace

	local v2 = p2.Header2.RelativeSize * p2.BaseSize
	local v3 = p2.Header2.RelativeMinSize * p2.BaseSize

	local x = GetTextSize(self.state.hintStringsConcat, v3, GetFontFromFontStyle(p2.Header2), Vector2.new(10000, 10000)).X

	if x <= v then
		local x2 = GetTextSize(
			self.state.hintStringsConcat,
			v2,
			GetFontFromFontStyle(p2.Header2),
			Vector2.new(10000, 10000)
		).X
		local v4 = (v2 - v3) / (x2 - x)
		local v5 = v2 - v4 * x2

		return nil, (math.clamp(v * v4 + v5, v3, v2))
	else
		local result = {}

		for k, hintRatio in pairs(self.state.hintRatios) do
			result[k] = hintRatio * v
		end

		return result
	end
end

function extended:render()
	return withStyle(function(p)
		local theme = p.Theme

		local hintSize, hintTextSize = self:calculateHintSize(self.state.controllerBarWidth, p.Font)

		local function makeHint(leftHint, p2)
			local joined = Cryo.Dictionary.join(leftHint, {
				key = "Hint" .. tostring(p2),
				hintTextSize = hintTextSize,
				maxWidth = hintSize and hintSize[leftHint.text] or nil
			})

			return Roact.createElement(ControllerBarHint, joined)
		end

		local rightHints

		if self.props.rightHints then
			rightHints = Roact.createFragment(Cryo.List.map(self.props.rightHints, makeHint))
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = theme.BackgroundUIContrast.Transparency,
			BackgroundColor3 = theme.BackgroundUIContrast.Color,
			Size = UDim2.new(1, 0, 0, 72),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			[Roact.Change.AbsoluteSize] = function(p2)
				self:setState({ controllerBarWidth = p2.AbsoluteSize.X })
			end,
			[Roact.Event.AncestryChanged] = function(p2)
				self:setState({ controllerBarWidth = p2.AbsoluteSize.X })
			end
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			LeftFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.5, 1)
			}, {
				Roact.createElement("UIListLayout", {
					key = "Layout",
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 40)
				}),
				makeHint(self.props.leftHint, "Left")
			}),
			RightFrame = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.5, 1),
					Position = UDim2.fromScale(1, 0),
					AnchorPoint = Vector2.new(1, 0)
				},
				{
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 40)
					}),
					RightHints = rightHints
				}
			)
		})
	end)
end

return extended
