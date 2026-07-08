local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local withStyle = require(Parent.UIBlox).Style.withStyle
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local v10 = Roact.PureComponent:extend("LoadingAvatar")
local v11 = game:DefineFastFlag("AppChatLoadingIndicatorTransparency", false)

v10.defaultProps = {
	cellHeight = 64,
	avatarSize = 36,
	LayoutOrder = 0,
	avatarImage = Images["component_assets/circle_49_mask"]
}

function v10.render(p1) -- line: 25
	-- upvalues: withStyle (copy), Roact (copy), Skeleton (copy), EnumsRadius (copy), v11 (copy), ImageSetLabel (copy)
	local v13 = p1.props.cellHeight / 2 - p1.props.avatarSize / 2

	return withStyle(function(p2) -- line: 28
		-- upvalues: Roact (copy), p1 (copy), Skeleton (copy), v13 (copy), EnumsRadius (copy), v11 (copy), ImageSetLabel (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, p1.props.cellHeight, 0, p1.props.cellHeight),
			LayoutOrder = p1.props.LayoutOrder
		}, {
			avatarShimmer = Roact.createElement(Skeleton, {
				Size = UDim2.fromOffset(p1.props.avatarSize, p1.props.avatarSize),
				Position = UDim2.fromOffset(v13, v13),
				radius = EnumsRadius.Circle
			}),
			avatarMask = if not v11 then Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(p1.props.avatarSize, p1.props.avatarSize),
				Position = UDim2.fromOffset(v13, v13),
				Image = p1.props.avatarImage,
				ImageColor3 = p2.Theme.BackgroundDefault.Color
			}) else nil
		})
	end)
end

return v10
