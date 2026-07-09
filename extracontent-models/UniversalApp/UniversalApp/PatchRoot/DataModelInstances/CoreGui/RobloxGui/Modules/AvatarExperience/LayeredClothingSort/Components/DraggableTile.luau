local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NotificationService = game:GetService("NotificationService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v13 = Roact.PureComponent:extend("DraggableTile")

v13.validateProps = t.strictInterface({
	thumbnail = t.string,
	ZIndex = t.number,
	isSelectedByTap = t.boolean,
	imageTransparency = t.number,
	AnchorPoint = t.Vector2,
	Position = t.UDim2,
	Size = t.UDim2,
	assetTypeId = t.string
})
v13.defaultProps = {
	isSelectedByTap = false,
	ZIndex = 1,
	imageTransparency = 0,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.fromScale(0, 0),
	Size = UDim2.fromScale(1, 1)
}

local uDim = UDim.new(0, 10)

function v13.init(p1) -- line: 50
	-- upvalues: NotificationService (copy)
	p1:setState({
		style = string.lower(NotificationService.SelectedTheme)
	})

	function p1.updateTheme() -- line: 55
		-- upvalues: p1 (copy), NotificationService (copy)
		p1:setState({
			style = string.lower(NotificationService.SelectedTheme)
		})
	end
end
function v13.render(p2) -- line: 62
	-- upvalues: withStyle (copy), Constants (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), ImageSetLabel (copy), LoadableImage (copy), uDim (copy), ExternalEventConnection (copy), NotificationService (copy)
	return withStyle(function(p3) -- line: 63
		-- upvalues: Constants (copy), p2 (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), ImageSetLabel (copy), LoadableImage (copy), uDim (copy), ExternalEventConnection (copy), NotificationService (copy)
		local Theme = p3.Theme
		local v19 = nil

		if Constants.GradientBackgroundAssetTypeIds[p2.props.assetTypeId] or p2.props.assetTypeId == Constants.AssetTypeIdStrings.HairAccessory then
			v19 = p2.state.style ~= "dark" and "rbxasset://textures/ui/AvatarExperience/glowDark.png" or "rbxasset://textures/ui/AvatarExperience/glowLight.png"
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			Size = p2.props.Size,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			ZIndex = p2.props.ZIndex,
			AnchorPoint = p2.props.AnchorPoint,
			Position = p2.props.Position,
			Selectable = not not FFlagAXMigrateAXToGlobalAutofocus or nil
		}, {
			BackgroundImage = Roact.createElement(ImageSetLabel, {
				BorderSizePixel = 0,
				ZIndex = 0,
				Image = v19,
				ImageTransparency = p2.props.imageTransparency,
				BackgroundTransparency = Theme.PlaceHolder.Transparency,
				BackgroundColor3 = Theme.PlaceHolder.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1)
			}, {
				Image = Roact.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					ZIndex = 0,
					showFailedStateWhenLoadingFailed = true,
					useShimmerAnimationWhileLoading = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = p2.props.thumbnail,
					ImageTransparency = p2.props.imageTransparency,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.fromScale(1, 1),
					cornerRadius = uDim
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = uDim
				})
			}),
			ThemeConnection = Roact.createElement(ExternalEventConnection, {
				event = NotificationService:GetPropertyChangedSignal("SelectedTheme"),
				callback = p2.updateTheme
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = uDim
			})
		})
	end)
end

return v13
