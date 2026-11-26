local NotificationService = game:GetService("NotificationService")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local module = require("@luauforge/bundled/dPN")

local extended = Roact.PureComponent:extend("DraggableTile")

extended.validateProps = t.strictInterface({
	thumbnail = t.string,
	ZIndex = t.number,
	isSelectedByTap = t.boolean,
	imageTransparency = t.number,
	AnchorPoint = t.Vector2,
	Position = t.UDim2,
	Size = t.UDim2,
	assetTypeId = t.string
})

extended.defaultProps = {
	isSelectedByTap = false,
	ZIndex = 1,
	imageTransparency = 0,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.fromScale(0, 0),
	Size = UDim2.fromScale(1, 1)
}

local udim = UDim.new(0, 10)

function extended:init()
	self:setState({
		style = string.lower(NotificationService.SelectedTheme)
	})

	function self.updateTheme()
		self:setState({
			style = string.lower(NotificationService.SelectedTheme)
		})
	end
end

function extended.render(data)
	return withStyle(function(p2)
		local theme = p2.Theme

		local v5 = (module.GradientBackgroundAssetTypeIds[data.props.assetTypeId] or data.props.assetTypeId == module.AssetTypeIdStrings.HairAccessory)
			and (data.state.style == "dark" and "rbxasset://textures/ui/AvatarExperience/glowLight.png" or "rbxasset://textures/ui/AvatarExperience/glowDark.png")
			or nil

		return Roact.createElement("Frame", {
			Size = data.props.Size,
			BackgroundTransparency = 0,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			ZIndex = data.props.ZIndex,
			AnchorPoint = data.props.AnchorPoint,
			Position = data.props.Position,
			Selectable = true
		}, {
			BackgroundImage = Roact.createElement(imageSetLabel, {
				Image = v5,
				ImageTransparency = data.props.imageTransparency,
				BackgroundTransparency = theme.PlaceHolder.Transparency,
				BackgroundColor3 = theme.PlaceHolder.Color,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 0
			}, {
				Image = Roact.createElement(loadableImage, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = data.props.thumbnail,
					ImageTransparency = data.props.imageTransparency,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.fromScale(1, 1),
					ZIndex = 0,
					cornerRadius = udim,
					showFailedStateWhenLoadingFailed = true,
					useShimmerAnimationWhileLoading = true
				}),
				UICorner = Roact.createElement("UICorner", { CornerRadius = udim })
			}),
			ThemeConnection = Roact.createElement(externalEventConnection, {
				event = NotificationService:GetPropertyChangedSignal("SelectedTheme"),
				callback = data.updateTheme
			}),
			UICorner = Roact.createElement("UICorner", { CornerRadius = udim })
		})
	end)
end

return extended
