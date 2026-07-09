local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local Focusable = RoactGamepad.Focusable
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Modules = CoreGui.RobloxGui.Modules
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useAppliedDescriptionValueContext = require(Modules.AvatarExperience.Common.Context.AppliedDescription.useAppliedDescriptionValueContext)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RefinementNavBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementNavBar)
local VerticalDrawer = require(Modules.AvatarExperience.AccessoryAdjustment.Components.VerticalDrawer)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local FullView = AvatarExperienceCommon.Enums.FullView
local RefinementControlBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementControlBar)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXMigrateAdjustAccessoryViewToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAdjustAccessoryViewToFocusNavigation
local v40 = Images["icons/menu/about_large"]
local v41 = Roact.PureComponent:extend("AccessoryAdjustmentPage")

v41.validateProps = t.strictInterface({
	tokens = if not FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then nil else t.table,
	fullView = t.userdata,
	isPortrait = t.boolean,
	setFullView = t.callback,
	noAccessoriesEquipped = t.boolean,
	avatarExperienceAnalytics = t.table,
	avatarRoute = t.table,
	navigation = t.table
})

function v41.init(p1) -- line: 81
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), Roact (copy), FullView (copy), TopBar (copy)
	p1.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.createFocusController() else nil
	p1.verticalDrawerRef = Roact.createRef()
	p1.topBarRef = Roact.createRef()
	p1.adjustmentButtonRef = Roact.createRef()
	p1.refinementNavBarRef = Roact.createRef()
	p1.props.setFullView(p1.props.avatarExperienceAnalytics, FullView.SceneFullView)
	p1.backButtonComponent = TopBar.makeBackButton(function() -- line: 89
		-- upvalues: p1 (copy)
		p1.props.navigation.pop()
	end)
end
function v41.renderTopBar(p2) -- line: 94
	-- upvalues: withLocalization (copy), Roact (copy), TopBar (copy)
	local isPortrait = p2.props.isPortrait

	return withLocalization({
		titleText = "Feature.Avatar.Heading.AccessoryAdjustmentTitle"
	})(function(p3) -- line: 99
		-- upvalues: Roact (copy), TopBar (copy), p2 (copy), isPortrait (copy)
		return Roact.createElement(TopBar.Container, {
			transparentBackground = true,
			titleText = p3.titleText,
			NextSelectionDown = p2.adjustmentButtonRef,
			hideSiteMessageBanner = isPortrait,
			leftItem = p2.backButtonComponent,
			ref = p2.topBarRef
		})
	end)
end
function v41.renderWithProviders(p4, p5, p6) -- line: 111
	-- upvalues: Roact (copy), SceneInteractionFrame (copy), GetFFlagAXEnableSlotBasedEditor (copy), RefinementControlBar (copy), RefinementNavBar (copy), VerticalDrawer (copy), Constants (copy), FFlagAXMigrateAdjustAccessoryViewToFocusNavigation (copy), ImageSetLabel (copy), v40 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), GamepadFocusHandlerForPage (copy), Focusable (copy)
	local p5Font = p5.Font
	local Theme = p5.Theme
	local t1 = {
		SceneInteractionFrame = Roact.createElement(SceneInteractionFrame),
		TopBar = p4:renderTopBar(),
		RefinementNavBar = Roact.createElement(if not GetFFlagAXEnableSlotBasedEditor() then RefinementNavBar else RefinementControlBar, {
			NextSelectionRight = p4.verticalDrawerRef,
			NextSelectionUp = p4.topBarRef,
			ref = p4.refinementNavBarRef
		}),
		VerticalDrawer = if p4.props.noAccessoriesEquipped then nil else Roact.createElement(VerticalDrawer, {
			ref = p4.verticalDrawerRef,
			NextSelectionLeft = p4.refinementNavBarRef
		}),
		NoAccessoriesWarning = if not p4.props.noAccessoriesEquipped then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, Constants.NoItem.BottomPadding),
			Size = UDim2.new(1, 0, 0, 100)
		}, {
			Label = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0, 0),
				Text = p6.noAccessoriesText,
				Font = p5Font.CaptionHeader.Font,
				TextSize = if not FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then Constants.NoItem.TextSize else p4.props.tokens.Typography.BodyMedium.FontSize,
				TextColor3 = Theme.IconEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = v40,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(0, -2, 0.5, 0),
					Size = UDim2.fromOffset(Constants.NoItem.IconSize, Constants.NoItem.IconSize),
					ImageColor3 = Theme.IconEmphasis.Color
				})
			})
		}),
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = p4.focusController
		}) else nil
	}

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p4.focusController else nil,
		defaultChild = p4.verticalDrawerRef
	}, t1)
end
function v41.render(p7) -- line: 182
	-- upvalues: withStyle (copy), withLocalization (copy)
	return withStyle(function(p8) -- line: 183
		-- upvalues: withLocalization (copy), p7 (copy)
		return withLocalization({
			noAccessoriesText = "Feature.Avatar.Message.NoAccessoriesEquipped"
		})(function(p9) -- line: 186
			-- upvalues: p7 (copy), p8 (copy)
			return p7:renderWithProviders(p8, p9)
		end)
	end)
end

local function mapStateToProps(p10, _) -- line: 192
	-- upvalues: DeviceOrientationMode (copy), selectIsFullView (copy), AvatarScreen (copy)
	return {
		isPortrait = p10.DeviceOrientation == DeviceOrientationMode.Portrait,
		fullView = selectIsFullView(p10, AvatarScreen.AccessoryAdjustment)
	}
end
local function mapDispatchToProps(p12) -- line: 201
	-- upvalues: SetFullView (copy), AvatarScreen (copy)
	return {
		setFullView = function(p13, p14) -- line: 203
			-- upvalues: p12 (copy), SetFullView (copy), AvatarScreen (copy)
			p12(SetFullView(p13, AvatarScreen.AccessoryAdjustment, p14))
		end
	}
end

local v44 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v41)
local u45 = withStackVisibilityWrapper((RoactServices.connect({
	avatarExperienceAnalytics = Analytics
})(v44)))

local function selectAllowedAATypes(p15) -- line: 217
	-- upvalues: Constants2 (copy)
	return p15.AvatarExperience.AvatarEditor.AvatarSettings[Constants2.AvatarSettings.accessoryRefinementTypes]
end

return function(p16) -- line: 221
	-- upvalues: useAppliedDescriptionValueContext (copy), FFlagAXMigrateAdjustAccessoryViewToFocusNavigation (copy), useTokens (copy), Cryo (copy), useSelector (copy), selectAllowedAATypes (copy), AccessoryAdjustmentUtils (copy), React (copy), u45 (ref)
	local v62 = useAppliedDescriptionValueContext().appliedDescriptionBinding:getValue()

	if FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then
		local v63 = useTokens()

		p16 = Cryo.Dictionary.join(p16, {
			tokens = v63
		})
	end

	if v62 then
		local v64 = useSelector(selectAllowedAATypes)
		local v65 = AccessoryAdjustmentUtils.getAdjustableAccessories(v62, v64)

		p16 = Cryo.Dictionary.join(p16, {
			noAccessoriesEquipped = Cryo.isEmpty(v65)
		})
	end

	return React.createElement(u45, p16)
end
