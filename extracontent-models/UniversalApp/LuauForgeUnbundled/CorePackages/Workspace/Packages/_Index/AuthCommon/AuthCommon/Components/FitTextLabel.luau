local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Immutable
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation").Utility.normalizeFontFace

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FitChildren")

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
			local udim = UDim.new(
				0,
				getTextSize(data.Text, data.TextSize, data.FontFace, Vector2.new(10000, 10000)).X
			)
			local udim2

			if maxWidth == nil or not (maxWidth < udim.Offset) then
				udim2 = fitAxis == FitChildren.FitAxis.Both and UDim.new(0, data.TextSize) or data.Size.Height
			else
				udim = UDim.new(0, maxWidth)
				udim2 = UDim.new(
					0,
					getTextSize(data.Text, data.TextSize, data.FontFace, Vector2.new(udim.Offset, 10000)).Y
				)
			end

			self:setState({ width = udim, height = udim2 })
		else
			local udim = UDim.new(
				0,
				getTextSize(
					data.Text,
					data.TextSize,
					data.FontFace,
					Vector2.new(data.AbsoluteSize.X, 10000)
				).Y
			)

			self:setState({ width = data.Size.Width, height = udim })
		end
	end

	self:setState({ width = nil, height = nil })
end

function extended.render(props)
	local fitAxis = props.props.fitAxis or FitChildren.FitAxis.Height
	local v5 = immutable.RemoveFromDictionary(props.props, "fitAxis", "maxWidth", "Font", "FontFace")
	local width = props.state.width
	local height = props.state.height

	if width and height then
		v5 = immutable.JoinDictionaries(v5, { Size = UDim2.new(width, height) })
	end

	local createElement = Roact.createElement

	local joinDictionaries = immutable.JoinDictionaries
	local v8 = if props.props.FontFace or props.props.Font then normalizeFontFace(props.props.FontFace or props.props.Font) else nil

	local v9 = {
		[Roact.Ref] = props.onRef,
		[Roact.Change.Text] = props.resize,
		[Roact.Change.TextSize] = props.resize
	}
	local absoluteSize = Roact.Change.AbsoluteSize
	local v10 = if fitAxis == FitChildren.FitAxis.Height then props.resize or nil else nil
	v9[absoluteSize] = v10
	v9[Roact.Change.FontFace] = props.resize
	return createElement("TextLabel", joinDictionaries(v5, { FontFace = v8 }, v9))
end

function extended.didMount(p2)
	p2.resize(p2.ref)
end

return extended
