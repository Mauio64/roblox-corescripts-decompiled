local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local BaseMenu = UIBlox.App.Menu.BaseMenu
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Analytics3 = require(Modules.AvatarExperience.ProfilePictureEditor.Services.Analytics)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavOverlayContainer = require(Modules.AvatarExperience.Common.Components.NavOverlayContainer)
local FFlagAXFixContextualMenuScrimSize = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXFixContextualMenuScrimSize
local v24 = Images["icons/menu/customize"]
local v25 = Images["icons/menu/shop"]
local v26 = Images["icons/menu/profilepicture"]
local v27 = Roact.PureComponent:extend("AXTransitionContextualMenu")

v27.validateProps = t.strictInterface({
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback),
	focusController = t.optional(t.table),
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
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

function v27.getOpaquePage(p1) -- line: 74
	return p1.props.avatarRoute.opaque.name
end
function v27.init(p2) -- line: 78
	-- upvalues: Roact (copy), AvatarScreen (copy), NavigationUtils (copy)
	local v31, v32 = Roact.createBinding(UDim2.fromScale(1, 1))

	p2.contextMenuSize = v31
	p2.updateContextMenuSize = v32

	function p2.onAbsoluteSizeChanged(p3) -- line: 81
		-- upvalues: p2 (copy)
		if p3.AbsoluteSize.X > 640 then
			local uDim2 = UDim2.new(0, 350, 1, 0)

			p2.updateContextMenuSize(uDim2)

			return
		end

		p2.updateContextMenuSize(UDim2.fromScale(1, 1))
	end
	function p2.goToAvatarEditorPage() -- line: 91
		-- upvalues: p2 (copy), AvatarScreen (copy), NavigationUtils (copy)
		if p2:getOpaquePage() ~= AvatarScreen.AvatarEditor then
			NavigationUtils.navigateFromOverlay(p2.props.navigation, AvatarScreen.AvatarEditor)
			p2.props.avatarAnalytics.catalogToAvatarButton()
		end
	end
	function p2.goToCatalogPage() -- line: 99
		-- upvalues: p2 (copy), AvatarScreen (copy), NavigationUtils (copy)
		if p2:getOpaquePage() ~= AvatarScreen.Catalog then
			NavigationUtils.navigateFromOverlay(p2.props.navigation, AvatarScreen.Catalog)
			p2.props.catalogAnalytics.avatarToCatalogButton()
		end
	end
	function p2.goToProfilePictureEditorPage() -- line: 107
		-- upvalues: p2 (copy), AvatarScreen (copy), NavigationUtils (copy)
		if p2:getOpaquePage() ~= AvatarScreen.ProfilePictureEditorEmotes then
			NavigationUtils.navigateFromOverlay(p2.props.navigation, AvatarScreen.ProfilePictureEditorEmotes)
		end

		p2.props.profilePictureEditorAnalytics.profilePictureEditorButton()
	end
	function p2.onDismiss() -- line: 114
		-- upvalues: NavigationUtils (copy), p2 (copy)
		NavigationUtils.closeOverlay(p2.props.navigation)
	end
end
function v27.render(p4) -- line: 119
	-- upvalues: withStyle (copy), withLocalization (copy)
	return withStyle(function(p5) -- line: 120
		-- upvalues: withLocalization (copy), p4 (copy)
		return withLocalization({
			customizeText = "Feature.Catalog.Action.Customize",
			shopText = "Feature.Avatar.Action.Marketplace",
			profilePictureEditorText = "Feature.Avatar.Action.EditProfilePicture"
		})(function(p6) -- line: 125
			-- upvalues: p4 (copy), p5 (copy)
			return p4:renderWithProviders(p5, p6)
		end)
	end)
end
function v27.renderWithProviders(p7, p8, p9) -- line: 131
	-- upvalues: Roact (copy), FFlagAXFixContextualMenuScrimSize (copy), NavOverlayContainer (copy), BaseMenu (copy), v24 (copy), AvatarScreen (copy), v25 (copy), v26 (copy)
	local Theme = p8.Theme

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Background = Roact.createElement("TextButton", {
			ZIndex = 1,
			Text = "",
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency,
			AutoButtonColor = false,
			Position = UDim2.fromOffset(-p7.props.globalGuiInset.left, -p7.props.globalGuiInset.top),
			Size = if not FFlagAXFixContextualMenuScrimSize then UDim2.fromOffset(p7.props.screenSize.X, p7.props.screenSize.Y) else UDim2.fromOffset(p7.props.screenSize.X + p7.props.globalGuiInset.left + p7.props.globalGuiInset.right, p7.props.screenSize.Y + p7.props.globalGuiInset.top + p7.props.globalGuiInset.bottom),
			[Roact.Event.Activated] = p7.onDismiss
		}),
		Container = Roact.createElement(NavOverlayContainer, {
			ZIndex = 2,
			onAbsoluteSizeChanged = p7.onAbsoluteSizeChanged
		}, {
			SizeFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = p7.contextMenuSize,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				[Roact.Ref] = p7.props.defaultChildRef
			}, {
				Menu = Roact.createElement(BaseMenu, {
					anchorPoint = Vector2.new(0.5, 0),
					position = UDim2.new(0.5, 0, 0, p7.props.topBarHeight),
					buttonProps = {
						{
							icon = v24,
							text = p9.customizeText,
							onActivated = p7.goToAvatarEditorPage,
							selected = p7:getOpaquePage() == AvatarScreen.AvatarEditor
						},
						{
							icon = v25,
							text = p9.shopText,
							onActivated = p7.goToCatalogPage,
							selected = p7:getOpaquePage() == AvatarScreen.Catalog
						},
						{
							icon = v26,
							text = p9.profilePictureEditorText,
							onActivated = p7.goToProfilePictureEditorPage,
							selected = p7:getOpaquePage() == AvatarScreen.ProfilePictureEditorEmotes
						}
					}
				})
			})
		})
	})
end

local v28 = RoactRodux.connect(function(p10, _) -- line: 197
	return {
		screenSize = p10.ScreenSize,
		topBarHeight = p10.TopBar.topBarHeight,
		globalGuiInset = p10.GlobalGuiInset
	}
end, nil)(v27)

return (withMappedNavigationParams((withAvatarRoute((withOverlayFocusHandling((RoactServices.connect({
	avatarAnalytics = Analytics,
	catalogAnalytics = Analytics2,
	profilePictureEditorAnalytics = Analytics3
})(v28))))))))
