local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FitChildren = require(AuthCommon.Components.FitChildren)

local extended = Roact.PureComponent:extend("FitTextLabel")

extended.defaultProps = { fitAxis = FitChildren.FitAxis.Height, maxWidth = nil }

function extended:init()
	function self.onRef(ref)
		self.ref = ref
	end

	function self.resize(data)
		local fitAxis = self.props.fitAxis
		local maxWidth = self.props.maxWidth

		if fitAxis == FitChildren.FitAxis.Width or fitAxis == FitChildren.FitAxis.Both then
			local udim = UDim.new(0, GetTextSize(data.Text, data.TextSize, data.FontFace, Vector2.new(10000, 10000)).X)
			local udim2

			if maxWidth == nil or not (maxWidth < udim.Offset) then
				udim2 = fitAxis == FitChildren.FitAxis.Both and UDim.new(0, data.TextSize) or data.Size.Height
			else
				udim = UDim.new(0, maxWidth)
				udim2 = UDim.new(
					0,
					GetTextSize(data.Text, data.TextSize, data.FontFace, Vector2.new(udim.Offset, 10000)).Y
				)
			end

			self:setState({ width = udim, height = udim2 })
		else
			local udim = UDim.new(
				0,
				GetTextSize(data.Text, data.TextSize, data.FontFace, Vector2.new(data.AbsoluteSize.X, 10000)).Y
			)

			self:setState({ width = data.Size.Width, height = udim })
		end
	end

	self:setState({ width = nil, height = nil })
end

function extended.render(props)
	local fitAxis = props.props.fitAxis or FitChildren.FitAxis.Height
	local v = Immutable.RemoveFromDictionary(props.props, "fitAxis", "maxWidth", "Font", "FontFace")
	local width = props.state.width
	local height = props.state.height

	if width and height then
		v = Immutable.JoinDictionaries(v, { Size = UDim2.new(width, height) })
	end

	local createElement = Roact.createElement

	local joinDictionaries = Immutable.JoinDictionaries
	local fontFace

	if props.props.FontFace or props.props.Font then
		fontFace = normalizeFontFace(props.props.FontFace or props.props.Font)
	end

	local v2 = {
		[Roact.Ref] = props.onRef,
		[Roact.Change.Text] = props.resize,
		[Roact.Change.TextSize] = props.resize
	}
	local absoluteSize = Roact.Change.AbsoluteSize
	local v3

	if fitAxis == FitChildren.FitAxis.Height then
		v3 = props.resize or nil
	end

	v2[absoluteSize] = v3
	v2[Roact.Change.FontFace] = props.resize
	return createElement("TextLabel", joinDictionaries(v, { FontFace = fontFace }, v2))
end

function extended.didMount(p)
	p.resize(p.ref)
end

return extended
