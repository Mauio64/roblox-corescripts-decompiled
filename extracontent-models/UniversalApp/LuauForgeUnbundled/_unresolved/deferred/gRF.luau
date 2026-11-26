local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local fFlagFontFaceAX = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFontFaceAX
require("@luauforge/bundled/dKT")

local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local withStyle = UIBlox.Style.withStyle
local getPageMargin = UIBlox.App.Container.getPageMargin
local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local fitTextLabel = FitFrame.FitTextLabel

local module = require("@luauforge/deferred/gRG")

local iconsactionseditedit = images["icons/actions/edit/edit"]
local iconsactionseditdelete = images["icons/actions/edit/delete"]

local extended = Roact.PureComponent:extend("ManageActionBar")

extended.validateProps = t.strictInterface({
	gradientFade = t.optional(t.boolean),
	multiSelect = t.optional(t.boolean),
	selectedOutfits = t.array(t.string),
	deleteOutfit = t.callback,
	renameOutfit = t.callback,
	bottomPadding = t.optional(t.number),
	ZIndex = t.integer,
	NextSelectionUp = t.optional(t.table),
	forwardRef = t.optional(t.table),
	showCustomOutfitNames = t.boolean,
	isPortrait = t.boolean
})

extended.defaultProps = { gradientFade = false, multiSelect = false }

function extended:init()
	self.renameButtonRef = Roact.createRef()
	self.deleteButtonRef = Roact.createRef()

	local binding, v5 = Roact.createBinding(UDim.new(0, 24))
	self.marginBinding = binding
	self.updateMarginBinding = v5

	function self.absoluteSizeChanged(p3)
		local pageMargin = getPageMargin(p3.AbsoluteSize.X)

		self.updateMarginBinding(UDim.new(0, pageMargin))
	end
end

function extended:renderBarItems(p2, props2)
	local children = {}

	children.UIPadding = Roact.createElement("UIPadding", {
		PaddingLeft = self.marginBinding,
		PaddingRight = self.marginBinding
	})

	local theme = props2.Theme

	if self.props.gradientFade then
		children.UIGradient = Roact.createElement("UIGradient", {
			Rotation = 270,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(0.8, theme.BackgroundDefault.Transparency),
				NumberSequenceKeypoint.new(1, 1)
			})
		})
	end

	if self.props.multiSelect then
		local v5 = props2.Font.Header2.Font
		local v6 = props2.Font.BaseSize * props2.Font.Header2.RelativeSize

		local v7 = p2.selectItem

		if #self.props.selectedOutfits > 0 then
			v7 = p2.countSelected
		end

		local createElement = Roact.createElement
		local v9 = {
			width = fitTextLabel.Width.FitToText,
			BackgroundTransparency = 1,
			Text = v7,
			Font = 0,
			Position = 0,
			AnchorPoint = 0,
			TextColor3 = 0,
			TextSize = 0
		}

		if fFlagFontFaceAX then
			v5 = normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font)
		end

		v9.Font = v5
		v9.Position = UDim2.fromScale(0, 0.5)
		v9.AnchorPoint = Vector2.new(0, 0.5)
		v9.TextColor3 = props2.Theme.TextEmphasis.Color
		v9.TextSize = v6
		children.SelectedCountTextLabel = createElement(fitTextLabel, v9)
	elseif self.props.showCustomOutfitNames then
		children.RenameButton = Roact.createElement(iconButton, {
			anchorPoint = Vector2.new(0, 0.5),
			position = UDim2.fromScale(0, 0.5),
			size = UDim2.new(0, 44, 1, 0),
			icon = iconsactionseditedit,
			iconSize = iconSize.Medium,
			iconColor3 = theme.SystemPrimaryDefault.Color,
			iconTransparency = theme.SystemPrimaryDefault.Transparency,
			onActivated = self.props.renameOutfit,
			buttonRef = self.renameButtonRef,
			NextSelectionRight = self.deleteButtonRef
		})
	end

	local v5 = #self.props.selectedOutfits > 0

	local createElement = Roact.createElement
	local v7 = {
		anchorPoint = Vector2.new(1, 0.5),
		position = UDim2.fromScale(1, 0.5),
		size = UDim2.new(0, 44, 1, 0),
		icon = iconsactionseditdelete,
		iconSize = iconSize.Medium,
		iconColor3 = theme.SystemPrimaryDefault.Color,
		iconTransparency = v5 and theme.SystemPrimaryDefault.Transparency or 0.5,
		onActivated = 0,
		buttonRef = 0,
		NextSelectionLeft = 0
	}
	local v8 = if v5 then self.props.deleteOutfit or nil else nil
	v7.onActivated = v8
	v7.buttonRef = self.deleteButtonRef
	local v9 = if not self.props.multiSelect then self.renameButtonRef or nil else nil
	v7.NextSelectionLeft = v9
	children.DeleteButton = createElement(iconButton, v7)

	return children
end

function extended:renderWithProviders(p2, p3)
	local theme = p3.Theme

	local actionBarHeight = module.ActionBarHeight

	if self.props.isPortrait then
		actionBarHeight += 24
	end

	if self.props.bottomPadding then
		actionBarHeight += self.props.bottomPadding
	end

	local barItems = self:renderBarItems(p2, p3)

	local forwardRef = self.props.forwardRef
	local v5

	if self.props.isPortrait then
		v5 = 24
	elseif self.props.bottomPadding then
		v5 = self.props.bottomPadding
	end

	local createElement = Roact.createElement
	local v7 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, actionBarHeight),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = self.props.ZIndex,
		[Roact.Change.AbsoluteSize] = self.absoluteSizeChanged,
		[Roact.Ref] = forwardRef
	}
	local v8 = {
		Background = Roact.createElement(
			"Frame",
			{
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, module.ActionBarHeight)
			},
			barItems
		),
		GapFiller = 0
	}
	local v9

	if v5 then
		v9 = Roact.createElement("Frame", {
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, v5),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1)
		})
	elseif self.props.isPortrait then
		v9 = Roact.createElement("Frame", {
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1)
		})
	end

	v8.GapFiller = v9
	return createElement("Frame", v7, v8)
end

function extended:render()
	return withLocalization({
		countSelected = {
			"Feature.Avatar.Label.CountSelected",
			itemCount = #self.props.selectedOutfits
		},
		selectItem = "Feature.Avatar.Label.SelectItem"
	})(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local v5 = roactAppPolicy.connect(function(p2, p3)
	return { showCustomOutfitNames = p2.getCustomOutfitNames() }
end)(extended)

local function mapStateToProps(p2, p3)
	return {
		isPortrait = p2.DeviceOrientation == deviceOrientationMode.Portrait
	}
end

local v6 = RoactRodux.connect(mapStateToProps, nil)(v5)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v6, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
