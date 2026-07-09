local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local NotificationService = game:GetService("NotificationService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local RoactRodux = require(CorePackages.Packages.RoactRodux)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Images = UIBlox.App.ImageSet.Images
local LoadableImage = UIBlox.App.Loading.LoadableImage
local PageButton = require(Modules.AvatarExperience.Common.Components.Landing.PageButton)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Constants = require(Modules.AvatarExperience.Common.Constants)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local AvatarThumbnailRequests = UserLib.Utils.AvatarThumbnailRequests
local t = require(CorePackages.Packages.t)

assert(AvatarThumbnailRequests.CUSTOMIZE_BUTTON ~= nil, "AvatarThumbnailRequests.CUSTOMIZE_BUTTON should exist. Silence type checker.")
assert(AvatarThumbnailRequests.CUSTOMIZE_BUTTON[1] ~= nil, "AvatarThumbnailRequests.CUSTOMIZE_BUTTON[1] should exist. Silence type checker.")

local v22 = AvatarThumbnailRequests.CUSTOMIZE_BUTTON[1]
local u23 = Constants2.RbxThumbnailSizeToNumberSize[v22.thumbnailSize]
local u24 = Constants2.RbxAvatarThumbnailTypeFromEnumToRbxthumbType[v22.thumbnailType]
local v25 = Images["icons/menu/customize_large"]
local v26 = Roact.PureComponent:extend("AvatarPageButton")

v26.validateProps = t.strictInterface({
	transparencyModifier = t.number,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	onActivated = t.callback,
	forwardRef = t.optional(t.table),
	localUserId = t.string
})
v26.defaultProps = {
	transparencyModifier = 0
}

function v26.init(p1) -- line: 75
	-- upvalues: NotificationService (copy), Cryo (copy), Roact (copy), Loading (copy), IconSize (copy), getRbxthumbWithTypeSizeAndOptions (copy), u24 (ref), u23 (ref), LoadableImage (copy), Constants (copy)
	p1.state = {
		style = string.lower(NotificationService.SelectedTheme)
	}

	function p1.getLoadingImage(p2) -- line: 80
		-- upvalues: Cryo (copy), Roact (copy), Loading (copy), IconSize (copy)
		local v45 = p2 or {}
		local v46 = Cryo.Dictionary.join(v45, {
			LoadingSpinner = Roact.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}),
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize
			})
		})

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, v46)
	end
	function p1.getThumbnail(p3, p4, p5, p6, p7, _) -- line: 103
		-- upvalues: p1 (copy), getRbxthumbWithTypeSizeAndOptions (copy), u24 (ref), u23 (ref), Roact (copy), LoadableImage (copy), Constants (copy)
		if p1.props.localUserId == nil or p1.props.localUserId == "" then
			return nil
		end

		local v53 = getRbxthumbWithTypeSizeAndOptions(p1.props.localUserId, u24, u23)

		return Roact.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = false,
			shouldHandleReloads = true,
			Position = p3,
			Size = p4,
			Image = v53,
			renderOnLoading = p1.getLoadingImage,
			ZIndex = p7,
			cornerRadius = UDim.new(0, Constants.PageButtonCornerRadius),
			ImageRectOffset = p5,
			ImageRectSize = p6
		})
	end
end
function v26.render(p9) -- line: 134
	-- upvalues: withLocalization (copy), Roact (copy), PageButton (copy), u23 (ref), v25 (copy)
	local style = p9.state.style
	local transparencyModifier = p9.props.transparencyModifier
	local NextSelectionLeft = p9.props.NextSelectionLeft
	local NextSelectionRight = p9.props.NextSelectionRight
	local NextSelectionUp = p9.props.NextSelectionUp
	local NextSelectionDown = p9.props.NextSelectionDown
	local s1 = "rbxasset://textures/AvatarEditorImages/AvatarEditor_LightTheme.png"

	if style == "dark" then
		s1 = "rbxasset://textures/AvatarEditorImages/AvatarEditor.png"
	end

	local forwardRef = p9.props.forwardRef

	return withLocalization({
		avatarEditorText = "Feature.Catalog.Action.Customize"
	})(function(p10) -- line: 151
		-- upvalues: Roact (copy), PageButton (copy), s1 (ref), p9 (copy), u23 (ref), v25 (copy), transparencyModifier (copy), NextSelectionLeft (copy), NextSelectionRight (copy), NextSelectionUp (copy), NextSelectionDown (copy), forwardRef (copy)
		return Roact.createElement(PageButton, {
			Size = UDim2.new(1, 0, 1, 0),
			backgroundImage = s1,
			getThumbnail = p9.getThumbnail,
			thumbnailSize = u23,
			thumbnailZoom = 2,
			thumbnailImageYInsetScale = 0.05,
			icon = v25,
			text = p10.avatarEditorText,
			transparencyModifier = transparencyModifier,
			NextSelectionLeft = NextSelectionLeft,
			NextSelectionRight = NextSelectionRight,
			NextSelectionUp = NextSelectionUp,
			NextSelectionDown = NextSelectionDown,
			[Roact.Ref] = forwardRef,
			onActivated = p9.props.onActivated
		})
	end)
end
function v26.didMount(p11) -- line: 173
	-- upvalues: NotificationService (copy)
	p11.themeChangedConn = NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function() -- line: 174
		-- upvalues: p11 (copy), NotificationService (copy)
		p11:setState({
			style = string.lower(NotificationService.SelectedTheme)
		})
	end)
end
function v26.willUnmount(p12) -- line: 181
	if p12.themeChangedConn then
		p12.themeChangedConn:Disconnect()
		p12.themeChangedConn = nil
	end
end

local function mapStateToProps(p13) -- line: 188
	return {
		localUserId = p13.LocalUserId
	}
end

local u28 = RoactRodux.connect(mapStateToProps)(v26)

return Roact.forwardRef(function(p14, p15) -- line: 196
	-- upvalues: Roact (copy), u28 (ref), Cryo (copy)
	return Roact.createElement(u28, Cryo.Dictionary.join(p14, {
		forwardRef = p15
	}))
end)
