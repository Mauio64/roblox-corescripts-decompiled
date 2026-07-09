local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local t = dependencies.t
local UIBlox = dependencies.UIBlox
local llama = dependencies.llama
local withStyle = UIBlox.Style.withStyle
local validateColorInfo = UIBlox.Style.Validator.validateColorInfo
local validateFontInfo = UIBlox.Style.Validator.validateFontInfo
local v10 = Roact.PureComponent:extend("StyledTextLabel")

v10.defaultProps = {
	BorderSizePixel = 0,
	Text = "Text",
	BackgroundStyle = {
		Transparency = 1,
		Color = Color3.fromRGB(0, 0, 0)
	},
	FontStyle = {
		RelativeSize = 1,
		RelativeMinSize = 1,
		Font = Enum.Font.Gotham
	},
	TextStyle = {
		Transparency = 1,
		Color = Color3.fromRGB(0, 0, 0)
	},
	Size = UDim2.new(1, 0, 1, 0)
}
v10.validateProps = t.interface({
	BackgroundStyle = t.optional(validateColorInfo),
	FontStyle = t.optional(validateFontInfo),
	TextStyle = t.optional(validateColorInfo),
	Text = t.optional(t.string)
})

function v10.render(p1) -- line: 40
	-- upvalues: withStyle (copy), Roact (copy), llama (copy)
	return withStyle(function(p2) -- line: 41
		-- upvalues: p1 (copy), Roact (copy), llama (copy)
		local v13 = p1.props.FontStyle.RelativeSize * p2.Font.BaseSize

		return Roact.createElement("TextLabel", llama.Dictionary.join({
			BackgroundColor3 = p1.props.BackgroundStyle.Color,
			BackgroundTransparency = p1.props.BackgroundStyle.Transparency,
			Font = p1.props.FontStyle.Font,
			TextSize = v13,
			TextColor3 = p1.props.TextStyle.Color,
			TextTransparency = p1.props.TextStyle.Transparency
		}, p1.props, {
			BackgroundStyle = llama.None,
			FontStyle = llama.None,
			TextStyle = llama.None
		}))
	end)
end

return v10
