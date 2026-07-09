local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameOnAxis = RoactFitComponents.FitFrameOnAxis
local FitTextLabel = RoactFitComponents.FitTextLabel
local Images = UIBlox.App.ImageSet.Images
local BaseMenu = UIBlox.App.Menu.BaseMenu
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local withTopBarSearchSignal = require(Modules.LuaApp.Context.withTopBarSearchSignal)
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local SetEntryPage = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetEntryPage)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v32 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local v33 = Images["component_assets/circle_17"]
local v34 = Images["icons/menu/customize"]
local v35 = Images["icons/menu/shop"]
local v36 = Images["icons/menu/profilepicture"]
local v37 = Images["icons/common/settings"]
local v38 = Images["icons/common/search"]
local v39 = Images["icons/actions/adjust"]
local v40 = Images["icons/common/goldrobux"]
local v41 = Images["icons/navigation/close"]
local v42 = Roact.PureComponent:extend("AvatarExperienceQuickMenu")

v42.validateProps = t.strictInterface({
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
	avatarRoute = AvatarRoute.Interface
})

function v42.init(p1) -- line: 84
	-- upvalues: NavigationUtils (copy), AvatarScreen (copy), Roact (copy)
	function p1.onActivatedShop() -- line: 85
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.Catalog)
	end
	function p1.onActivatedEditProfilePicture() -- line: 89
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.ProfilePictureEditorEmotes, {
			prevNavPage = p1.props.avatarRoute.opaque.name
		})
	end
	function p1.onActivatedManage() -- line: 95
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.ManageOutfitPage)
	end
	function p1.onActivatedCustomizeAvatar() -- line: 99
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.AvatarEditor)
	end
	function p1.onActivatedRefinement() -- line: 103
		-- upvalues: p1 (copy), NavigationUtils (copy), AvatarScreen (copy)
		p1.props.setEntryPage(p1.props.avatarRoute.opaque.name)
		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.LayeredClothingSort)
	end
	function p1.onActivatedBuyRobux() -- line: 108
		-- upvalues: p1 (copy)
		p1.closePrompt()
		p1.props.purchaseRobux()
	end
	function p1.closePrompt() -- line: 113
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end

	local v45, v46 = Roact.createBinding(UDim2.fromScale(0.35, 0.5))

	p1.sizeBinding = v45
	p1.updateSizeBinding = v46

	function p1.onContentSizeChanged(p2) -- line: 119
		-- upvalues: p1 (copy)
		local AbsoluteContentSizeY = p2.AbsoluteContentSize.Y

		p1.updateSizeBinding(UDim2.new(0.35, 0, 0, AbsoluteContentSizeY))
	end
end
function v42.gatherElements(p3, p4, p5) -- line: 125
	-- upvalues: AvatarScreen (copy), v34 (copy), v35 (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy), v40 (copy), v41 (copy)
	local t1 = {}
	local name = p3.props.avatarRoute.opaque.name

	if name == AvatarScreen.AvatarExperienceLandingPage or (name == AvatarScreen.Catalog or name == AvatarScreen.ProfilePictureEditorEmotes) then
		table.insert(t1, {
			icon = v34,
			text = p4.customizeAvatar,
			onActivated = p3.onActivatedCustomizeAvatar
		})
	end

	if name == AvatarScreen.AvatarExperienceLandingPage or name == AvatarScreen.AvatarEditor or name == AvatarScreen.MySharedAvatars or name == AvatarScreen.ProfilePictureEditorEmotes then
		table.insert(t1, {
			icon = v35,
			text = p4.shop,
			onActivated = p3.onActivatedShop
		})
	end

	if name == AvatarScreen.AvatarExperienceLandingPage or name == AvatarScreen.AvatarEditor or name == AvatarScreen.Catalog then
		table.insert(t1, {
			icon = v36,
			text = p4.editProfilePicture,
			onActivated = p3.onActivatedEditProfilePicture
		})
	end

	if p3.props.manageOutfitsEnabled and name == AvatarScreen.AvatarEditor then
		table.insert(t1, {
			icon = v37,
			text = p4.manage,
			onActivated = p3.onActivatedManage
		})
	end

	local v52 = p3.props.isAvatarEditorSceneFullView or (p3.props.isMySharedAvatarSceneFullView or (p3.props.isCatalogSceneFullView or p3.props.isProfilePictureEditorEmotesSceneFullView))

	if name == AvatarScreen.Catalog and not v52 then
		table.insert(t1, {
			icon = v38,
			text = p4.search,
			onActivated = function() -- line: 190
				-- upvalues: p3 (copy), p5 (copy), name (copy)
				p3.closePrompt()
				p5:fire(name)
			end
		})
	end

	table.insert(t1, {
		icon = v39,
		text = p4.avatarAdjustment,
		onActivated = p3.onActivatedRefinement
	})
	table.insert(t1, {
		icon = v40,
		text = p4.buyRobux,
		onActivated = p3.onActivatedBuyRobux
	})
	table.insert(t1, {
		icon = v41,
		text = p4.cancel,
		onActivated = p3.closePrompt
	})

	return t1
end
function v42.renderWithProviders(p6, p7, p8, p9) -- line: 218
	-- upvalues: AvatarScreen (copy), Roact (copy), Focusable (copy), ImageSetLabel (copy), v33 (copy), FitFrameOnAxis (copy), FitTextLabel (copy), BaseMenu (copy)
	local p8Font = p8.Font
	local Theme = p8.Theme
	local Header1Font = p8Font.Header1.Font
	local v60 = p8Font.BaseSize * p8Font.Header1.RelativeSize
	local v61 = p6:gatherElements(p7, p9)
	local name = p6.props.avatarRoute.current.name
	local v63 = if name ~= AvatarScreen.AvatarExperienceLandingPage then if name ~= AvatarScreen.AvatarEditor then p7.shopOptions else p7.customizeOptions else p7.avatarOptions

	return Roact.createElement(Focusable[ImageSetLabel], {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = p6.sizeBinding,
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = v33,
		ImageColor3 = Theme.BackgroundUIDefault.Color,
		ImageTransparency = Theme.BackgroundUIDefault.Transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9),
		[Roact.Ref] = p6.props.defaultChildRef
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 20),
			[Roact.Change.AbsoluteContentSize] = p6.onContentSizeChanged
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 20)
		}),
		TextContainer = Roact.createElement(FitFrameOnAxis, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			axis = FitFrameOnAxis.Axis.Both,
			margin = {
				top = 0,
				bottom = 0,
				left = 20,
				right = 0
			}
		}, {
			TitleText = Roact.createElement(FitTextLabel, {
				BackgroundTransparency = 1,
				width = FitTextLabel.Width.FitToText,
				Text = v63,
				Font = Header1Font,
				TextSize = v60,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency
			})
		}),
		BaseMenu = Roact.createElement(BaseMenu, {
			layoutOrder = 2,
			topElementRounded = false,
			buttonProps = v61
		})
	})
end
function v42.render(p10) -- line: 288
	-- upvalues: withLocalization (copy), withStyle (copy), withTopBarSearchSignal (copy)
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
	})(function(p11) -- line: 301
		-- upvalues: withStyle (copy), withTopBarSearchSignal (copy), p10 (copy)
		return withStyle(function(p12) -- line: 302
			-- upvalues: withTopBarSearchSignal (copy), p10 (copy), p11 (copy)
			return withTopBarSearchSignal(function(p13) -- line: 303
				-- upvalues: p10 (copy), p11 (copy), p12 (copy)
				return p10:renderWithProviders(p11, p12, p13)
			end)
		end)
	end)
end

local v43 = RoactRodux.connect(function(p14, _) -- line: 310
	-- upvalues: Utils (copy), AvatarScreen (copy), FullView (copy)
	local v67 = Utils.getAvatarEditorCategoryInfoFromState(p14)
	local v68 = p14.AvatarExperience.Common.FullView[AvatarScreen.ProfilePictureEditorEmotes] == FullView.SceneFullView

	return {
		manageOutfitsEnabled = v67.ManageOutfitsEnabled == true,
		isAvatarEditorSceneFullView = p14.AvatarExperience.Common.FullView[AvatarScreen.AvatarEditor] == FullView.SceneFullView,
		isCatalogSceneFullView = p14.AvatarExperience.Common.FullView[AvatarScreen.Catalog] == FullView.SceneFullView,
		isProfilePictureEditorEmotesSceneFullView = v68,
		isMySharedAvatarSceneFullView = p14.AvatarExperience.Common.FullView[AvatarScreen.MySharedAvatars] == FullView.SceneFullView
	}
end, function(p16) -- line: 326
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v32 (copy), NavigateDown (copy), SetEntryPage (copy)
	return {
		purchaseRobux = function() -- line: 328
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v32 (copy), p16 (copy), NavigateDown (copy)
			local t2 = {
				name = AppPage.PurchaseRobux
			}

			if FFlagSignalsNavP3Dispatch then
				v32.down(v32.fromLegacyPage(t2))

				return
			end

			p16(NavigateDown(t2))
		end,
		setEntryPage = function(p17) -- line: 338
			-- upvalues: p16 (copy), SetEntryPage (copy)
			p16(SetEntryPage(p17))
		end
	}
end)(v42)

return (withAvatarRoute((withOverlayFocusHandling((RoactServices.connect({
	avatarExperienceAnalytics = Analytics
})(v43))))))
