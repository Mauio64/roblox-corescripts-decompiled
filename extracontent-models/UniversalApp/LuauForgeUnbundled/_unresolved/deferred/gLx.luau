local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local baseMenu = UIBlox.App.Menu.BaseMenu
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/gJz")
local module2 = require("@luauforge/bundled/fDf")
local module3 = require("@luauforge/deferred/fDS")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute

local module5 = require("@luauforge/deferred/gJH")
local module6 = require("@luauforge/deferred/gJI")
local module7 = require("@luauforge/bundled/fAe")
local module8 = require("@luauforge/bundled/dXh")

local module9 = require("@luauforge/deferred/gJR")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEditProfileImageV2Enabled = SharedFlags.FFlagEditProfileImageV2Enabled
local fFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface

local iconsmenucustomize = images["icons/menu/customize"]
local iconsmenushop = images["icons/menu/shop"]
local iconsmenuprofilepicture = images["icons/menu/profilepicture"]

local extended = Roact.PureComponent:extend("AXTransitionContextualMenu")

extended.validateProps = t.strictInterface({
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback),
	focusController = t.optional(t.table),
	navigation = t.table,
	avatarRoute = avatarRoute.Interface,
	screenSize = t.Vector2,
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}),
	topBarHeight = t.number,
	avatarAnalytics = t.table,
	catalogAnalytics = t.table,
	profilePictureEditorAnalytics = t.table,
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	[Roact.Ref] = t.optional(t.table),
	inputBindings = t.optional(t.table)
})

function extended:getOpaquePage()
	return self.props.avatarRoute.opaque.name
end

function extended:init()
	local binding, v6 = Roact.createBinding(UDim2.fromScale(1, 1))
	self.contextMenuSize = binding
	self.updateContextMenuSize = v6

	function self.onAbsoluteSizeChanged(p2)
		if p2.AbsoluteSize.X > 640 then
			local udim = UDim2.new(0, 350, 1, 0)
			self.updateContextMenuSize(udim)
		else
			self.updateContextMenuSize(UDim2.fromScale(1, 1))
		end
	end

	function self.goToAvatarEditorPage()
		if self:getOpaquePage() ~= avatarScreen.AvatarEditor then
			module8.navigateFromOverlay(self.props.navigation, avatarScreen.AvatarEditor)

			self.props.avatarAnalytics.catalogToAvatarButton()
		end
	end

	function self.goToCatalogPage()
		if self:getOpaquePage() ~= avatarScreen.Catalog then
			module8.navigateFromOverlay(self.props.navigation, avatarScreen.Catalog)

			self.props.catalogAnalytics.avatarToCatalogButton()
		end
	end

	function self.goToProfilePictureEditorPage()
		local opaquePage = self:getOpaquePage()

		if fFlagEditProfileImageV2Enabled then
			if opaquePage ~= avatarScreen.EditProfileImage then
				module8.navigateFromOverlay(self.props.navigation, avatarScreen.EditProfileImage, {
					entryOrigin = fFlagAXPPEReturnToEntrySurface and {
						screenName = opaquePage,
						screenParams = self.props.avatarRoute.opaque.params
					} or nil
				})
			end
		elseif opaquePage ~= avatarScreen.ProfilePictureEditorEmotes then
			module8.navigateFromOverlay(self.props.navigation, avatarScreen.ProfilePictureEditorEmotes)
		end

		self.props.profilePictureEditorAnalytics.profilePictureEditorButton()
	end

	function self.onDismiss()
		module8.closeOverlay(self.props.navigation)
	end
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			customizeText = "Feature.Catalog.Action.Customize",
			shopText = "Feature.Avatar.Action.Marketplace",
			profilePictureEditorText = "Feature.Avatar.Action.EditProfilePicture"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended:renderWithProviders(p2, props2)
	local theme = p2.Theme

	local createElement = Roact.createElement
	local v7 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local children = {
		Background = Roact.createElement("TextButton", {
			ZIndex = 1,
			Text = "",
			BorderSizePixel = 0,
			BackgroundColor3 = theme.Overlay.Color,
			BackgroundTransparency = theme.Overlay.Transparency,
			AutoButtonColor = false,
			Position = UDim2.fromOffset(-self.props.globalGuiInset.left, -self.props.globalGuiInset.top),
			Size = UDim2.fromOffset(
				self.props.screenSize.X + self.props.globalGuiInset.left + self.props.globalGuiInset.right,
				self.props.screenSize.Y + self.props.globalGuiInset.top + self.props.globalGuiInset.bottom
			),
			[Roact.Event.Activated] = self.onDismiss
		}),
		Container = 0
	}

	local createElement3 = Roact.createElement
	local v9 = { ZIndex = 2, onAbsoluteSizeChanged = self.onAbsoluteSizeChanged }

	local createElement4 = Roact.createElement
	local defaultChildRefsByRef = {
		BackgroundTransparency = 1,
		Size = self.contextMenuSize,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		[Roact.Ref] = self.props.defaultChildRef
	}

	local createElement5 = Roact.createElement
	local v14 = {
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, self.props.topBarHeight),
		buttonProps = 0
	}

	local v16 = {
		icon = iconsmenucustomize,
		text = props2.customizeText,
		onActivated = self.goToAvatarEditorPage,
		selected = self:getOpaquePage() == avatarScreen.AvatarEditor
	}

	local v17 = {
		icon = iconsmenushop,
		text = props2.shopText,
		onActivated = self.goToCatalogPage,
		selected = self:getOpaquePage() == avatarScreen.Catalog
	}

	local v18 = {
		icon = iconsmenuprofilepicture,
		text = props2.profilePictureEditorText,
		onActivated = self.goToProfilePictureEditorPage,
		selected = 0
	}

	local v19 = if fFlagEditProfileImageV2Enabled then self:getOpaquePage() == avatarScreen.EditProfileImage else self:getOpaquePage() == avatarScreen.ProfilePictureEditorEmotes
	v18.selected = v19
	v14.buttonProps = { v16, v17, v18 }
	children.Container = createElement3(module9, v9, {
		SizeFrame = createElement4("Frame", defaultChildRefsByRef, {
			Menu = createElement5(baseMenu, v14)
		})
	})
	return createElement("Frame", v7, children)
end

local v6 = RoactRodux.connect(function(data, p2)
	return {
		screenSize = data.ScreenSize,
		topBarHeight = data.TopBar.topBarHeight,
		globalGuiInset = data.GlobalGuiInset
	}
end, nil)(extended)

return (module5((module7((module6((roactServices.connect({
	avatarAnalytics = module,
	catalogAnalytics = module2,
	profilePictureEditorAnalytics = module3
})(v6))))))))
