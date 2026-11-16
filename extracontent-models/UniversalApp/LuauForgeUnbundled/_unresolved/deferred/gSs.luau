local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Cryo = require(CorePackages.Packages.Cryo)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameOnAxis = roactFitComponents.FitFrameOnAxis

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module = require("@luauforge/bundled/geT")

local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/dNP")
local module4 = require("@luauforge/deferred/gOC")

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module5 = require("@luauforge/bundled/fvh")

local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed
local withNavigation = RoactNavigation.withNavigation
require("@luauforge/bundled/dHK")

local cursorKind = UIBlox.App.SelectionImage.CursorKind
local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local fFlagAXBlockMakeupEquipR6 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBlockMakeupEquipR6

local component_assetscircle_29 = images["component_assets/circle_29"]
local component_assetscircle_25 = images["component_assets/circle_25"]

local v5 = { dampingRatio = 1, frequency = 3.5 }

local extended = Roact.PureComponent:extend("AvatarTypeSwitch")

local function resizeTextLabel(current)
	local v6

	if foundationFontFaceMigration then
		v6 = getTextSize(current.Text, current.TextSize, current.FontFace, Vector2.new(10000, 10000)).X
	else
		v6 = text.GetTextWidth(current.Text, current.Font, current.TextSize)
	end

	local udim = UDim.new(0, v6)
	local udim2 = UDim.new(0, current.TextSize)
	current.Size = UDim2.new(udim, udim2)
end

function extended:resizeTextLabels()
	local current = self.r6Ref.current
	local current2 = self.r15Ref.current

	if not (current and current2) then
		return
	end

	resizeTextLabel(current)
	resizeTextLabel(current2)

	local v6 = math.max(current.AbsoluteSize.x, current2.AbsoluteSize.x)

	current.Size = UDim2.new(0, v6, 0, current.Size.Y.Offset)
	current2.Size = UDim2.new(0, v6, 0, current2.Size.Y.Offset)
end

function extended:makeOnOverlayClosed(p3)
	return function()
		logOnOverlayClosed("AvatarTypeSwitch")
	end
end

function extended:init()
	self.r6Ref = Roact.createRef()
	self.r15Ref = Roact.createRef()

	local binding, v6 = Roact.createBinding(UDim2.fromScale(1, 1))
	self.sizeBinding = binding
	self.updateSizeBinding = v6

	function self.absoluteSizeChanged(p2)
		self.updateSizeBinding(UDim2.fromOffset(p2.AbsoluteSize.X, p2.AbsoluteSize.Y))
	end

	function self.toggleAvatarType(p2)
		local sendAnalytics = self.props.sendAnalytics
		local analytics = self.props.analytics
		local setAvatarType = self.props.setAvatarType
		local v7

		if self.props.avatarType == module2.AvatarType.R6 then
			v7 = module2.AvatarType.R15
		else
			v7 = module2.AvatarType.R6
		end

		local wrapLayer = module5.hasWrapLayer(self.props.currentCharacter)

		local v8 = if fFlagAXBlockMakeupEquipR6 then module5.hasMakeup(self.props.equippedAssets) else nil

		if v7 == module2.AvatarType.R6 and (wrapLayer or v8) then
			self.props.navigation.navigate(avatarScreen.LayeredClothingR6SwitchPrompt, {
				onOverlayClosed = self:makeOnOverlayClosed()
			})

			return
		end

		setAvatarType(v7)
		sendAnalytics(analytics.toggleAvatarType, v7)
	end
end

function extended:didMount()
	self:resizeTextLabels()
end

function extended:renderWithProviders(p2, props2, callback, p3)
	local layoutOrder = self.props.LayoutOrder

	local theme = props2.Theme
	local font = props2.Font

	local v6 = self.props.avatarType == module2.AvatarType.R15 and 0.5 or 0

	local forwardRef = self.props.forwardRef

	local createElement = Roact.createElement
	local forwardRefsByRef = {
		Size = self.sizeBinding,
		Image = component_assetscircle_29,
		ImageColor3 = theme.BackgroundUIDefault.Color,
		ImageTransparency = theme.BackgroundUIDefault.Transparency,
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(14, 13, 15, 15),
		LayoutOrder = layoutOrder,
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionRight = self.props.NextSelectionRight,
		NextSelectionUp = self.props.NextSelectionUp,
		NextSelectionDown = self.props.NextSelectionDown,
		[Roact.Ref] = forwardRef
	}
	local children = {
		AnimatedFrame = Roact.createElement(springAnimatedItem.AnimatedFrame, {
			regularProps = {
				Size = UDim2.new(0.5, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			animatedValues = { positionX = v6 },
			mapValuesToProps = function(p4)
				return {
					Position = UDim2.new(p4.positionX, 0, 0, 0)
				}
			end,
			springOptions = v5
		}, {
			SwitchImage = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(1, 0, 1, 0),
				Image = component_assetscircle_25,
				ImageColor3 = theme.UIEmphasis.Color,
				ImageTransparency = theme.UIEmphasis.Transparency,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 11, 13, 13)
			})
		}),
		SwitchButton = Roact.createElement(focusable.ImageButton, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Event.Activated] = function()
				self.toggleAvatarType(p3)
			end,
			SelectionImageObject = callback(cursorKind.Toggle)
		}),
		LabelsContainer = 0
	}

	local createElement3 = Roact.createElement
	local absoluteSizeChangedsByAbsoluteSize = {
		axis = fitFrameOnAxis.Axis.Both,
		margin = roactFitComponents.Rect.square(3),
		contentPadding = UDim.new(0, 10),
		FillDirection = Enum.FillDirection.Horizontal,
		BackgroundTransparency = 1,
		ZIndex = 2,
		[Roact.Change.AbsoluteSize] = self.absoluteSizeChanged
	}

	local createElement4 = Roact.createElement
	local r6RefsByRef = {}
	r6RefsByRef.BackgroundTransparency = 1
	r6RefsByRef.AnchorPoint = Vector2.new(0, 0.5)
	local v11 = if not foundationFontFaceMigration then font.Body.Font else nil
	r6RefsByRef.Font = v11

	local v12 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
	r6RefsByRef.FontFace = v12

	r6RefsByRef.Text = p2.r6Text
	r6RefsByRef.TextXAlignment = Enum.TextXAlignment.Center
	r6RefsByRef.TextSize = font.CaptionHeader.RelativeSize * font.BaseSize
	local v13 = if self.props.avatarType == module2.AvatarType.R6 then theme.TextEmphasis.Color else theme.TextDefault.Color
	r6RefsByRef.TextColor3 = v13

	r6RefsByRef.LayoutOrder = 1
	r6RefsByRef[Roact.Ref] = self.r6Ref
	local children2 = {
		R6Label = createElement4("TextLabel", r6RefsByRef),
		R15Label = 0
	}

	local createElement5 = Roact.createElement
	local r15RefsByRef = {}
	r15RefsByRef.BackgroundTransparency = 1
	r15RefsByRef.AnchorPoint = Vector2.new(1, 0.5)
	local v15 = if not foundationFontFaceMigration then font.Body.Font else nil
	r15RefsByRef.Font = v15

	local v16 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
	r15RefsByRef.FontFace = v16

	r15RefsByRef.Text = p2.r15Text
	r15RefsByRef.TextXAlignment = Enum.TextXAlignment.Center
	r15RefsByRef.TextSize = font.CaptionHeader.RelativeSize * font.BaseSize
	local v17 = if self.props.avatarType == module2.AvatarType.R15 then theme.TextEmphasis.Color else theme.TextDefault.Color
	r15RefsByRef.TextColor3 = v17

	r15RefsByRef.LayoutOrder = 2
	r15RefsByRef[Roact.Ref] = self.r15Ref
	children2.R15Label = createElement5("TextLabel", r15RefsByRef)
	children.LabelsContainer = createElement3(fitFrameOnAxis, absoluteSizeChangedsByAbsoluteSize, children2)
	return createElement(imageSetLabel, forwardRefsByRef, children)
end

function extended:render()
	return withLocalization({
		r6Text = "Feature.Avatar.Label.R6",
		r15Text = "Feature.Avatar.Label.R15"
	})(function(p2)
		return withStyle(function(p3)
			return withSelectionCursorProvider(function(p4)
				return self:renderWithProviders(p2, p3, p4)
			end)
		end)
	end)
end

local v6 = withNavigation(roactServices.connect({ analytics = module })(extended), nil)

local function mapStateToProps(p2, p3)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter

	return {
		equippedAssets = equippedAssets,
		avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType,
		currentCharacter = currentCharacter
	}
end

local function mapDispatchToProps(callback)
	return {
		setAvatarType = function(p2)
			callback(module3(p2))
		end,
		sendAnalytics = function(p2, p3)
			callback(module4(p2, p3))
		end
	}
end

local v7 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v6)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v7, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
