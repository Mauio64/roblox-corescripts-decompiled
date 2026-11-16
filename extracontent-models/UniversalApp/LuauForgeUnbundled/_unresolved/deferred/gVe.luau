local CorePackages = game:GetService("CorePackages")

local NotificationService = game:GetService("NotificationService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local RoactRodux = require(CorePackages.Packages.RoactRodux)

require("@luauforge/bundled/dHK")

local images = UIBlox.App.ImageSet.Images
local loadableImage = UIBlox.App.Loading.LoadableImage

local module = require("@luauforge/deferred/gVf")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/cgr")
local constants = module3.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions
local avatarThumbnailRequests = module3.Utils.AvatarThumbnailRequests

local t = require(CorePackages.Packages.t)

assert(
	avatarThumbnailRequests.CUSTOMIZE_BUTTON ~= nil,
	"AvatarThumbnailRequests.CUSTOMIZE_BUTTON should exist. Silence type checker."
)

assert(
	avatarThumbnailRequests.CUSTOMIZE_BUTTON[1] ~= nil,
	"AvatarThumbnailRequests.CUSTOMIZE_BUTTON[1] should exist. Silence type checker."
)

local v5 = avatarThumbnailRequests.CUSTOMIZE_BUTTON[1]
local v6 = constants.RbxThumbnailSizeToNumberSize[v5.thumbnailSize]
local v7 = constants.RbxAvatarThumbnailTypeFromEnumToRbxthumbType[v5.thumbnailType]

local iconsmenucustomize_large = images["icons/menu/customize_large"]

local extended = Roact.PureComponent:extend("AvatarPageButton")

extended.validateProps = t.strictInterface({
	transparencyModifier = t.number,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	onActivated = t.callback,
	forwardRef = t.optional(t.table),
	localUserId = t.string
})

extended.defaultProps = { transparencyModifier = 0 }

function extended:init()
	self.state = {
		style = string.lower(NotificationService.SelectedTheme)
	}

	function self.getLoadingImage(options)
		local joined = Cryo.Dictionary.join(options or {}, {
			LoadingSpinner = Roact.createElement(loading, {
				size = iconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}),
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize
			})
		})

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1
			},
			joined
		)
	end

	function self.getThumbnail(p2, p3, p4, p5, p6, p7)
		if self.props.localUserId == nil or self.props.localUserId == "" then
			return nil
		end

		local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
			self.props.localUserId,
			v7,
			v6
		)

		return Roact.createElement(loadableImage, {
			Position = p2,
			Size = p3,
			BackgroundTransparency = 1,
			Image = rbxthumbWithTypeSizeAndOptions,
			useShimmerAnimationWhileLoading = false,
			renderOnLoading = self.getLoadingImage,
			ZIndex = p6,
			cornerRadius = UDim.new(0, module2.PageButtonCornerRadius),
			ImageRectOffset = p4,
			ImageRectSize = p5,
			shouldHandleReloads = true
		})
	end
end

function extended.render(data)
	local style = data.state.style
	local transparencyModifier = data.props.transparencyModifier
	local nextSelectionLeft = data.props.NextSelectionLeft
	local nextSelectionRight = data.props.NextSelectionRight
	local nextSelectionUp = data.props.NextSelectionUp
	local nextSelectionDown = data.props.NextSelectionDown

	local v8 = style == "dark" and "rbxasset://textures/AvatarEditorImages/AvatarEditor.png"
		or "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png"

	local forwardRef = data.props.forwardRef

	return withLocalization({ avatarEditorText = "Feature.Catalog.Action.Customize" })(function(p2)
		return Roact.createElement(module, {
			Size = UDim2.new(1, 0, 1, 0),
			backgroundImage = v8,
			getThumbnail = data.getThumbnail,
			thumbnailSize = v6,
			thumbnailZoom = 2,
			thumbnailImageYInsetScale = 0.05,
			icon = iconsmenucustomize_large,
			text = p2.avatarEditorText,
			transparencyModifier = transparencyModifier,
			NextSelectionLeft = nextSelectionLeft,
			NextSelectionRight = nextSelectionRight,
			NextSelectionUp = nextSelectionUp,
			NextSelectionDown = nextSelectionDown,
			[Roact.Ref] = forwardRef,
			onActivated = data.props.onActivated
		})
	end)
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

local function mapStateToProps(p2)
	return { localUserId = p2.LocalUserId }
end

local v8 = RoactRodux.connect(mapStateToProps)(extended)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v8, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
