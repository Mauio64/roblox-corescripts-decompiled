local CorePackages = game:GetService("CorePackages")

local NotificationService = game:GetService("NotificationService")

local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local images = UIBlox.App.ImageSet.Images
local module = require("@luauforge/deferred/hhm")
local module2 = require("@luauforge/deferred/hhn")

local iconsmenuprofilepicture_large = images["icons/menu/profilepicture_large"]

local vector2 = Vector2.new(40, 0)
local vector2_2 = Vector2.new(0, 0)

local vector2_3 = Vector2.new(382 - vector2.X, 340)
local vector2_4 = Vector2.new(228 - vector2_2.X, 360)

local extended = Roact.PureComponent:extend("ProfilePictureEditorPageButton")

extended.validateProps = t.strictInterface({
	transparencyModifier = t.number,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	onActivated = t.callback,
	forwardRef = t.optional(t.table)
})

extended.defaultProps = { transparencyModifier = 0 }

function extended.init(object)
	object:setState({
		style = string.lower(NotificationService.SelectedTheme)
	})
end

function extended:render()
	return withLocalization({
		ppeButtonText = "Feature.Avatar.Action.EditProfilePicture"
	})(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended:renderWithProviders(p3)
	local transparencyModifier = self.props.transparencyModifier
	local nextSelectionLeft = self.props.NextSelectionLeft
	local nextSelectionRight = self.props.NextSelectionRight
	local nextSelectionUp = self.props.NextSelectionUp
	local nextSelectionDown = self.props.NextSelectionDown
	local forwardRef = self.props.forwardRef
	local v5 = self.state.style == "dark" and "rbxasset://textures/AvatarEditorImages/AvatarEditor.png"
		or "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png"

	return Roact.createElement(module, {
		Size = UDim2.new(1, 0, 1, 0),
		backgroundImage = v5,
		icon = iconsmenuprofilepicture_large,
		text = p3.ppeButtonText,
		transparencyModifier = transparencyModifier,
		ignoreThumbnail = true,
		iconBeforeText = true,
		NextSelectionLeft = nextSelectionLeft,
		NextSelectionRight = nextSelectionRight,
		NextSelectionUp = nextSelectionUp,
		NextSelectionDown = nextSelectionDown,
		[Roact.Ref] = forwardRef,
		extraThumbnails = {
			{
				side = module2.Left,
				image = "rbxasset://textures/ui/AvatarExperience/Avatar1_PPEButton.png",
				imageRectSize = vector2_3,
				imageRectOffset = vector2,
				paddingTopScale = 0.04,
				paddingBottomScale = 0,
				paddingSideScale = 0.02
			},
			{
				side = module2.Right,
				image = "rbxasset://textures/ui/AvatarExperience/Avatar2_PPEButton.png",
				imageRectSize = vector2_4,
				imageRectOffset = vector2_2,
				paddingTopScale = 0.04,
				paddingBottomScale = 0,
				paddingSideScale = 0.04
			}
		},
		onActivated = self.props.onActivated
	})
end

function extended:didMount()
	self.themeChangedConn = NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function()
		self:setState({
			style = string.lower(NotificationService.SelectedTheme)
		})
	end)
end

function extended:willUnmount()
	if self.themeChangedConn then
		self.themeChangedConn:Disconnect()
		self.themeChangedConn = nil
	end
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
