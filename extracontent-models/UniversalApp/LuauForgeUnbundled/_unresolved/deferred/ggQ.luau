local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute

local module2 = require("@luauforge/bundled/fsK")
local module3 = require("@luauforge/deferred/gfc")
local module4 = require("@luauforge/bundled/dTM")

local module5 = require("@luauforge/bundled/fuD")

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameOnAxis = roactFitComponents.FitFrameOnAxis
local fitTextLabel = roactFitComponents.FitTextLabel

local images = UIBlox.App.ImageSet.Images
local baseMenu = UIBlox.App.Menu.BaseMenu
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module6 = require("@luauforge/bundled/fsH")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module7 = require("@luauforge/bundled/dTG")
local fFlagAXUseSignalsForLayeredClothingEntryPage = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForLayeredClothingEntryPage
local getLayeredClothingEntryPageStore

if fFlagAXUseSignalsForLayeredClothingEntryPage then
	getLayeredClothingEntryPageStore = require("@luauforge/bundled/dMd").Stores.getLayeredClothingEntryPageStore
else
	getLayeredClothingEntryPageStore = nil
end

local module8 = require("@luauforge/bundled/dCp")
local module9 = require("@luauforge/bundled/eee")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagEditProfileImageV2Enabled = SharedFlags.FFlagEditProfileImageV2Enabled
local fFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local component_assetscircle_17 = images["component_assets/circle_17"]
local iconsmenucustomize = images["icons/menu/customize"]
local iconsmenushop = images["icons/menu/shop"]
local iconsmenuprofilepicture = images["icons/menu/profilepicture"]
local iconscommonsettings = images["icons/common/settings"]
local iconscommonsearch = images["icons/common/search"]
local iconsactionsadjust = images["icons/actions/adjust"]
local iconscommongoldrobux = images["icons/common/goldrobux"]
local iconsnavigationclose = images["icons/navigation/close"]

local extended = Roact.PureComponent:extend("AvatarExperienceQuickMenu")

extended.validateProps = t.strictInterface({
	onOverlayClosed = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	manageOutfitsEnabled = t.boolean,
	isAvatarEditorSceneFullView = t.boolean,
	isCatalogSceneFullView = t.boolean,
	isProfilePictureEditorEmotesSceneFullView = t.boolean,
	isMySharedAvatarSceneFullView = t.boolean,
	purchaseRobux = t.callback,
	setEntryPage = t.callback,
	avatarExperienceAnalytics = t.table,
	navigation = t.table,
	avatarRoute = avatarRoute.Interface
})

function extended:init()
	function self.onActivatedShop()
		module4.navigateFromOverlay(self.props.navigation, avatarScreen.Catalog)
	end

	function self.onActivatedEditProfilePicture()
		if fFlagEditProfileImageV2Enabled then
			module4.navigateFromOverlay(self.props.navigation, avatarScreen.EditProfileImage, {
				prevNavPage = self.props.avatarRoute.opaque.name,
				entryOrigin = fFlagAXPPEReturnToEntrySurface and {
					screenName = self.props.avatarRoute.opaque.name,
					screenParams = self.props.avatarRoute.opaque.params
				} or nil
			})
		else
			module4.navigateFromOverlay(self.props.navigation, avatarScreen.ProfilePictureEditorEmotes, {
				prevNavPage = self.props.avatarRoute.opaque.name
			})
		end
	end

	function self.onActivatedManage()
		module4.navigateFromOverlay(self.props.navigation, avatarScreen.ManageOutfitPage)
	end

	function self.onActivatedCustomizeAvatar()
		module4.navigateFromOverlay(self.props.navigation, avatarScreen.AvatarEditor)
	end

	function self.onActivatedRefinement()
		self.props.setEntryPage(self.props.avatarRoute.opaque.name)
		module4.navigateFromOverlay(self.props.navigation, avatarScreen.LayeredClothingSort)
	end

	function self.onActivatedBuyRobux()
		self.closePrompt()
		self.props.purchaseRobux()
	end

	function self.closePrompt()
		module4.closeOverlay(self.props.navigation)
	end

	local binding, v5 = Roact.createBinding(UDim2.fromScale(0.35, 0.5))
	self.sizeBinding = binding
	self.updateSizeBinding = v5

	function self.onContentSizeChanged(p2)
		local y = p2.AbsoluteContentSize.Y
		self.updateSizeBinding(UDim2.new(0.35, 0, 0, y))
	end
end

function extended:gatherElements(data2, object)
	local elements = {}

	local name = self.props.avatarRoute.opaque.name

	if
		name == avatarScreen.AvatarExperienceLandingPage
		or name == avatarScreen.Catalog
		or name == avatarScreen.ProfilePictureEditorEmotes
	then
		table.insert(elements, {
			icon = iconsmenucustomize,
			text = data2.customizeAvatar,
			onActivated = self.onActivatedCustomizeAvatar
		})
	end

	if
		name == avatarScreen.AvatarExperienceLandingPage
		or name == avatarScreen.AvatarEditor
		or name == avatarScreen.MySharedAvatars
		or name == avatarScreen.ProfilePictureEditorEmotes
	then
		table.insert(elements, {
			icon = iconsmenushop,
			text = data2.shop,
			onActivated = self.onActivatedShop
		})
	end

	if
		name == avatarScreen.AvatarExperienceLandingPage
		or name == avatarScreen.AvatarEditor
		or name == avatarScreen.Catalog
	then
		table.insert(elements, {
			icon = iconsmenuprofilepicture,
			text = data2.editProfilePicture,
			onActivated = self.onActivatedEditProfilePicture
		})
	end

	if self.props.manageOutfitsEnabled and name == avatarScreen.AvatarEditor then
		table.insert(elements, {
			icon = iconscommonsettings,
			text = data2.manage,
			onActivated = self.onActivatedManage
		})
	end

	local isAvatarEditorSceneFullView = self.props.isAvatarEditorSceneFullView
		or self.props.isMySharedAvatarSceneFullView
		or self.props.isCatalogSceneFullView
		or self.props.isProfilePictureEditorEmotesSceneFullView

	if name == avatarScreen.Catalog and not isAvatarEditorSceneFullView then
		table.insert(elements, {
			icon = iconscommonsearch,
			text = data2.search,
			onActivated = function()
				self.closePrompt()
				object:fire(name)
			end
		})
	end

	table.insert(elements, {
		icon = iconsactionsadjust,
		text = data2.avatarAdjustment,
		onActivated = self.onActivatedRefinement
	})

	table.insert(elements, {
		icon = iconscommongoldrobux,
		text = data2.buyRobux,
		onActivated = self.onActivatedBuyRobux
	})

	table.insert(elements, {
		icon = iconsnavigationclose,
		text = data2.cancel,
		onActivated = self.closePrompt
	})

	return elements
end

function extended:renderWithProviders(props2, p2, p3)
	local font = p2.Font
	local theme = p2.Theme

	local font2 = font.Header1.Font
	local v5 = font.BaseSize * font.Header1.RelativeSize

	local elements = self:gatherElements(props2, p3)

	local name = self.props.avatarRoute.current.name
	local v6

	if name == avatarScreen.AvatarExperienceLandingPage then
		v6 = props2.avatarOptions
	else
		v6 = if name == avatarScreen.AvatarEditor then props2.customizeOptions else props2.shopOptions
	end

	return Roact.createElement(focusable[imageSetLabel], {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = self.sizeBinding,
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = component_assetscircle_17,
		ImageColor3 = theme.BackgroundUIDefault.Color,
		ImageTransparency = theme.BackgroundUIDefault.Transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9),
		[Roact.Ref] = self.props.defaultChildRef
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 20),
			[Roact.Change.AbsoluteContentSize] = self.onContentSizeChanged
		}),
		UIPadding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 20) }),
		TextContainer = Roact.createElement(fitFrameOnAxis, {
			axis = fitFrameOnAxis.Axis.Both,
			margin = { top = 0, bottom = 0, left = 20, right = 0 },
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, {
			TitleText = Roact.createElement(fitTextLabel, {
				width = fitTextLabel.Width.FitToText,
				Text = v6,
				Font = font2,
				TextSize = v5,
				BackgroundTransparency = 1,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency
			})
		}),
		BaseMenu = Roact.createElement(baseMenu, {
			buttonProps = elements,
			layoutOrder = 2,
			topElementRounded = false
		})
	})
end

function extended:render()
	return withLocalization({
		avatarOptions = "Feature.Avatar.Label.QuickMenuLandingPageTitle",
		shopOptions = "Feature.Catalog.Label.QuickMenuMarketplaceTitle",
		customizeOptions = "Feature.Avatar.Label.QuickMenuCustomizeTitle",
		shop = "Feature.Avatar.Action.Marketplace",
		manage = "Feature.Avatar.Label.ManageItems",
		customizeAvatar = "Feature.Catalog.Label.CustomizeAvatar",
		editProfilePicture = "Feature.Avatar.Action.EditProfilePicture",
		search = "Feature.Catalog.Label.Search",
		buyRobux = "Feature.Catalog.Label.BuyRobux",
		cancel = "Feature.Catalog.Action.Cancel",
		avatarAdjustment = "Feature.Avatar.Label.AvatarAdjustment"
	})(function(p2)
		return withStyle(function(p3)
			return module6(function(p4)
				return self:renderWithProviders(p2, p3, p4)
			end)
		end)
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	local avatarEditorCategoryInfoFromState = module5.getAvatarEditorCategoryInfoFromState(p2)

	local v6 = p2.AvatarExperience.Common.FullView[avatarScreen.ProfilePictureEditorEmotes] == fullView.SceneFullView

	return {
		manageOutfitsEnabled = avatarEditorCategoryInfoFromState.ManageOutfitsEnabled == true,
		isAvatarEditorSceneFullView = p2.AvatarExperience.Common.FullView[avatarScreen.AvatarEditor] == fullView.SceneFullView,
		isCatalogSceneFullView = p2.AvatarExperience.Common.FullView[avatarScreen.Catalog] == fullView.SceneFullView,
		isProfilePictureEditorEmotesSceneFullView = v6,
		isMySharedAvatarSceneFullView = p2.AvatarExperience.Common.FullView[avatarScreen.MySharedAvatars] == fullView.SceneFullView
	}
end, function(callback)
	return {
		purchaseRobux = function()
			local v6 = { name = module8.PurchaseRobux }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(module9(v6))
			end
		end,
		setEntryPage = function(p2)
			if fFlagAXUseSignalsForLayeredClothingEntryPage then
				getLayeredClothingEntryPageStore(false).setEntryPage(p2)
			else
				callback(module7(p2))
			end
		end
	}
end)(extended)

return (module2((module3((roactServices.connect({
	avatarExperienceAnalytics = avatarExperienceAnalyticsService
})(v5))))))
