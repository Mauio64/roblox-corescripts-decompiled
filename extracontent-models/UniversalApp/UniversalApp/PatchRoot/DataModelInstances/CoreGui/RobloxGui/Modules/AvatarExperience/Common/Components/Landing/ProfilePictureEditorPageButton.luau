local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local NotificationService = game:GetService("NotificationService")
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local PageButton = require(Modules.AvatarExperience.Common.Components.Landing.PageButton)
local ThumbnailSide = require(Modules.AvatarExperience.Common.Components.Landing.ThumbnailSide)
local v12 = Images["icons/menu/profilepicture_large"]
local vector2 = Vector2.new(40, 0)
local vector2_2 = Vector2.new(0, 0)
local vector2_3 = Vector2.new(382 - vector2.X, 340)
local vector2_4 = Vector2.new(228 - vector2_2.X, 360)
local v17 = Roact.PureComponent:extend("ProfilePictureEditorPageButton")

v17.validateProps = t.strictInterface({
	transparencyModifier = t.number,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	onActivated = t.callback,
	forwardRef = t.optional(t.table)
})
v17.defaultProps = {
	transparencyModifier = 0
}

function v17.init(p1) -- line: 58
	-- upvalues: NotificationService (copy)
	p1:setState({
		style = string.lower(NotificationService.SelectedTheme)
	})
end
function v17.render(p2) -- line: 64
	-- upvalues: withLocalization (copy)
	return withLocalization({
		ppeButtonText = "Feature.Avatar.Action.EditProfilePicture"
	})(function(p3) -- line: 67
		-- upvalues: p2 (copy)
		return p2:renderWithProviders(p3)
	end)
end
function v17.renderWithProviders(p4, p5) -- line: 72
	-- upvalues: Roact (copy), PageButton (copy), v12 (copy), ThumbnailSide (copy), vector2_3 (copy), vector2 (copy), vector2_4 (copy), vector2_2 (copy)
	local transparencyModifier = p4.props.transparencyModifier
	local NextSelectionLeft = p4.props.NextSelectionLeft
	local NextSelectionRight = p4.props.NextSelectionRight
	local NextSelectionUp = p4.props.NextSelectionUp
	local NextSelectionDown = p4.props.NextSelectionDown
	local forwardRef = p4.props.forwardRef
	local s1 = "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png"

	if p4.state.style == "dark" then
		s1 = "rbxasset://textures/AvatarEditorImages/AvatarEditor.png"
	end

	return Roact.createElement(PageButton, {
		Size = UDim2.new(1, 0, 1, 0),
		backgroundImage = s1,
		icon = v12,
		text = p5.ppeButtonText,
		transparencyModifier = transparencyModifier,
		ignoreThumbnail = true,
		iconBeforeText = true,
		NextSelectionLeft = NextSelectionLeft,
		NextSelectionRight = NextSelectionRight,
		NextSelectionUp = NextSelectionUp,
		NextSelectionDown = NextSelectionDown,
		[Roact.Ref] = forwardRef,
		extraThumbnails = {
			{
				image = "rbxasset://textures/ui/AvatarExperience/Avatar1_PPEButton.png",
				paddingTopScale = 0.04,
				paddingBottomScale = 0,
				paddingSideScale = 0.02,
				side = ThumbnailSide.Left,
				imageRectSize = vector2_3,
				imageRectOffset = vector2
			},
			{
				image = "rbxasset://textures/ui/AvatarExperience/Avatar2_PPEButton.png",
				paddingTopScale = 0.04,
				paddingBottomScale = 0,
				paddingSideScale = 0.04,
				side = ThumbnailSide.Right,
				imageRectSize = vector2_4,
				imageRectOffset = vector2_2
			}
		},
		onActivated = p4.props.onActivated
	})
end
function v17.didMount(p6) -- line: 125
	-- upvalues: NotificationService (copy)
	p6.themeChangedConn = NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function() -- line: 126
		-- upvalues: p6 (copy), NotificationService (copy)
		p6:setState({
			style = string.lower(NotificationService.SelectedTheme)
		})
	end)
end
function v17.willUnmount(p7) -- line: 133
	if p7.themeChangedConn then
		p7.themeChangedConn:Disconnect()
		p7.themeChangedConn = nil
	end
end

return Roact.forwardRef(function(p8, p9) -- line: 140
	-- upvalues: Roact (copy), v17 (copy), Cryo (copy)
	return Roact.createElement(v17, Cryo.Dictionary.join(p8, {
		forwardRef = p9
	}))
end)
