local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Immutable
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Text
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
			local newUDim = UDim.new
			local v6

			if foundationFontFaceMigration then
				v6 = getTextSize(data.Text, data.TextSize, data.FontFace, Vector2.new(10000, 10000)).X
			else
				v6 = text.GetTextWidth(data.Text, data.Font, data.TextSize)
			end

			local udim = newUDim(0, v6)
			local udim2

			if maxWidth == nil or not (maxWidth < udim.Offset) then
				udim2 = fitAxis == FitChildren.FitAxis.Both and UDim.new(0, data.TextSize) or data.Size.Height
			else
				udim = UDim.new(0, maxWidth)
				local newUDim2 = UDim.new
				local v8

				if foundationFontFaceMigration then
					v8 = getTextSize(
						data.Text,
						data.TextSize,
						data.FontFace,
						Vector2.new(udim.Offset, 10000)
					).Y
				else
					v8 = text.GetTextHeight(data.Text, data.Font, data.TextSize, udim.Offset)
				end

				udim2 = newUDim2(0, v8)
			end

			self:setState({ width = udim, height = udim2 })
		else
			local newUDim = UDim.new
			local v6

			if foundationFontFaceMigration then
				v6 = getTextSize(
					data.Text,
					data.TextSize,
					data.FontFace,
					Vector2.new(data.AbsoluteSize.X, 10000)
				).Y
			else
				v6 = text.GetTextHeight(data.Text, data.Font, data.TextSize, data.AbsoluteSize.X)
			end

			local udim = newUDim(0, v6)

			self:setState({ width = data.Size.Width, height = udim })
		end
	end

	self:setState({ width = nil, height = nil })
end

function extended.render(props)
	local fitAxis = props.props.fitAxis or FitChildren.FitAxis.Height
	local v5

	if foundationFontFaceMigration then
		v5 = immutable.RemoveFromDictionary(props.props, "fitAxis", "maxWidth", "Font", "FontFace")
	else
		v5 = immutable.RemoveFromDictionary(props.props, "fitAxis", "maxWidth")
	end

	local width = props.state.width
	local height = props.state.height

	if width and height then
		v5 = immutable.JoinDictionaries(v5, { Size = UDim2.new(width, height) })
	end

	if foundationFontFaceMigration then
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

	return Roact.createElement("TextLabel", immutable.JoinDictionaries(v5, {
		[Roact.Ref] = props.onRef,
		[Roact.Change.Text] = props.resize,
		[Roact.Change.TextSize] = props.resize,
		[Roact.Change.AbsoluteSize] = fitAxis == FitChildren.FitAxis.Height and props.resize or nil
	}))
end

function extended.didMount(p2)
	p2.resize(p2.ref)
end

return extended
