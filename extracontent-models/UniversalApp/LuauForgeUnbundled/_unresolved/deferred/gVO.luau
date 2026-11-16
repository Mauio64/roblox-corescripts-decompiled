local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local focusable = RoactGamepad.Focusable
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Cryo = require(CorePackages.Packages.Cryo)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local module2 = require("@luauforge/deferred/gmV")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/deferred/ggP")
local module4 = require("@luauforge/bundled/dNQ")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module5 = require("@luauforge/deferred/fvk")
local module6 = require("@luauforge/bundled/fox")
local module7 = require("@luauforge/bundled/goB")
local module8 = require("@luauforge/bundled/gnZ")
local module9 = require("@luauforge/bundled/goe")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module10 = require("@luauforge/deferred/gVP")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
require("@luauforge/bundled/dHK")

local module11 = require("@luauforge/deferred/gVR")
local module12 = require("@luauforge/deferred/gVU")
local fullView = AvatarExperienceCommon.Enums.FullView
local module13 = require("@luauforge/deferred/gVV")

local module14 = require("@luauforge/bundled/dOc")

local fFlagAXMigrateAdjustAccessoryViewToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateAdjustAccessoryViewToFocusNavigation

local iconsmenuabout_large = images["icons/menu/about_large"]

local extended = Roact.PureComponent:extend("AccessoryAdjustmentPage")

local strictInterface = t.strictInterface
local v6 = if fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then t.table else nil
extended.validateProps = strictInterface({
	tokens = v6,
	fullView = t.userdata,
	isPortrait = t.boolean,
	setFullView = t.callback,
	noAccessoriesEquipped = t.boolean,
	avatarExperienceAnalytics = t.table,
	avatarRoute = t.table,
	navigation = t.table
})

function extended:init()
	self.verticalDrawerRef = Roact.createRef()
	self.topBarRef = Roact.createRef()
	self.adjustmentButtonRef = Roact.createRef()
	self.refinementNavBarRef = Roact.createRef()

	self.props.setFullView(self.props.avatarExperienceAnalytics, fullView.SceneFullView)
	self.backButtonComponent = module6.makeBackButton(function()
		self.props.navigation.pop()
	end)
end

function extended:renderTopBar()
	local isPortrait = self.props.isPortrait

	return withLocalization({
		titleText = "Feature.Avatar.Heading.AccessoryAdjustmentTitle"
	})(function(p2)
		return Roact.createElement(module6.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = p2.titleText,
			NextSelectionDown = self.adjustmentButtonRef,
			transparentBackground = true,
			hideSiteMessageBanner = isPortrait,
			leftItem = self.backButtonComponent,
			ref = self.topBarRef
		})
	end)
end

function extended:renderWithProviders(props2, p2)
	local font = props2.Font
	local theme = props2.Theme

	local v7 = {
		SceneInteractionFrame = Roact.createElement(module7),
		TopBar = self:renderTopBar(),
		RefinementNavBar = 0,
		VerticalDrawer = 0,
		NoAccessoriesWarning = 0
	}
	local createElement = Roact.createElement
	local v8 = if module14() then module13 else module11
	v7.RefinementNavBar = createElement(v8, {
		NextSelectionRight = self.verticalDrawerRef,
		NextSelectionUp = self.topBarRef,
		ref = self.refinementNavBarRef
	})

	local v9 = if not self.props.noAccessoriesEquipped then Roact.createElement(module12, {
		ref = self.verticalDrawerRef,
		NextSelectionLeft = self.refinementNavBarRef
	}) else nil
	v7.VerticalDrawer = v9
	local v10

	if self.props.noAccessoriesEquipped then
		local createElement2 = Roact.createElement
		local v12 = {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, module3.NoItem.BottomPadding),
			Size = UDim2.new(1, 0, 0, 100),
			BackgroundTransparency = 1
		}

		local createElement3 = Roact.createElement
		local v15 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0, 0),
			Text = p2.noAccessoriesText,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextWrapped = true,
			TextXAlignment = 0
		}
		local v16 = if not foundationFontFaceMigration then font.CaptionHeader.Font else nil
		v15.Font = v16

		local v17 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.CaptionLarge.Font) else nil
		v15.FontFace = v17

		local v18 = if fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then self.props.tokens.Typography.BodyMedium.FontSize else module3.NoItem.TextSize
		v15.TextSize = v18

		v15.TextColor3 = theme.IconEmphasis.Color

		v15.TextXAlignment = Enum.TextXAlignment.Left
		v10 = createElement2("Frame", v12, {
			Label = createElement3("TextLabel", v15, {
				Icon = Roact.createElement(imageSetLabel, {
					Image = iconsmenuabout_large,
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -2, 0.5, 0),
					Size = UDim2.fromOffset(module3.NoItem.IconSize, module3.NoItem.IconSize),
					ImageColor3 = theme.IconEmphasis.Color
				})
			})
		})
	end

	v7.NoAccessoriesWarning = v10

	return Roact.createElement(
		focusable.Frame,
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			defaultChild = self.verticalDrawerRef,
			ZIndex = 2
		},
		v7
	)
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			noAccessoriesText = "Feature.Avatar.Message.NoAccessoriesEquipped"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local function mapStateToProps(p2, p3)
	return {
		isPortrait = p2.DeviceOrientation == deviceOrientationMode.Portrait,
		fullView = module9(p2, avatarScreen.AccessoryAdjustment)
	}
end

local function mapDispatchToProps(callback)
	return {
		setFullView = function(p2, p3)
			callback(module8(p2, avatarScreen.AccessoryAdjustment, p3))
		end
	}
end

local v7 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

local v8 = module2((roactServices.connect({
	avatarExperienceAnalytics = avatarExperienceAnalyticsService
})(v7)))

local function selectAllowedAATypes(p2)
	return p2.AvatarExperience.AvatarEditor.AvatarSettings[module4.AvatarSettings.accessoryRefinementTypes]
end

return function(p2)
	local value = module10().appliedDescriptionBinding:getValue()

	if fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then
		local v9 = useTokens()
		p2 = Cryo.Dictionary.join(p2, { tokens = v9 })
	end

	if value then
		local v9 = useSelector(selectAllowedAATypes)

		local adjustableAccessories = module5.getAdjustableAccessories(value, v9)
		p2 = Cryo.Dictionary.join(p2, {
			noAccessoriesEquipped = Cryo.isEmpty(adjustableAccessories)
		})
	end

	return React.createElement(v8, p2)
end
