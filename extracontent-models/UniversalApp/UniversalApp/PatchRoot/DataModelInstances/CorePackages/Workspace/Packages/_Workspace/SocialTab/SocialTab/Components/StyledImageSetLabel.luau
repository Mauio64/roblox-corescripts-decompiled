local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local validateColorInfo = UIBlox.Style.Validator.validateColorInfo
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local llama = dependencies.llama
local v10 = Roact.PureComponent:extend("StyledImageSetLabel")

v10.defaultProps = {
	BorderSizePixel = 0,
	Image = "",
	BackgroundStyle = {
		Transparency = 1,
		Color = Color3.fromRGB(0, 0, 0)
	},
	ImageStyle = {
		Transparency = 0,
		Color = Color3.fromRGB(255, 255, 255)
	},
	Size = UDim2.new(1, 0, 1, 0)
}
v10.validateProps = t.interface({
	BackgroundStyle = t.optional(validateColorInfo),
	ImageStyle = t.optional(validateColorInfo),
	Image = t.optional(t.union(t.string, validateImage))
})

function v10.render(p1) -- line: 34
	-- upvalues: Roact (copy), ImageSetLabel (copy), llama (copy)
	return Roact.createElement(ImageSetLabel, llama.Dictionary.join({
		BackgroundColor3 = p1.props.BackgroundStyle.Color,
		BackgroundTransparency = p1.props.BackgroundStyle.Transparency,
		ImageColor3 = p1.props.ImageStyle.Color,
		ImageTransparency = p1.props.ImageStyle.Transparency
	}, p1.props, {
		BackgroundStyle = llama.None,
		ImageStyle = llama.None,
		[Roact.Children] = llama.None
	}), p1.props[Roact.Children])
end

return v10
