local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withStyle = UIBlox.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local FFlagEnableAvatarHeadshotLocalIconBackgroundFix = require(Modules.AvatarExperience.Flags.FFlagEnableAvatarHeadshotLocalIconBackgroundFix)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local LoadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot
local v21 = Roact.PureComponent:extend("AvatarHeadshotLocalIcon")

v21.defaultProps = {
	Size = 36,
	LayoutOrder = 1
}
v21.validateProps = t.strictInterface({
	Size = t.optional(t.number),
	ZIndex = t.number,
	LayoutOrder = t.optional(t.integer),
	BackgroundColor3 = t.optional(t.Color3),
	BackgroundTransparency = t.optional(t.number),
	navigation = t.table,
	localUserId = t.string
})

function v21.getCurrentRouteName(p1) -- line: 51
	-- upvalues: NavigationUtils (copy)
	if p1.props.navigation and (p1.props.navigation.state and p1.props.navigation.state.routes and p1.props.navigation.state.routes[1] and NavigationUtils.getActiveScreenNavigationState(p1.props.navigation.state.routes[1]) and NavigationUtils.getActiveScreenNavigationState(p1.props.navigation.state.routes[1]).routeName) then
		return NavigationUtils.getActiveScreenNavigationState(p1.props.navigation.state.routes[1]).routeName
	end
end
function v21.init(p2) -- line: 64
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), Roact (copy), Skeleton (copy), EnumsRadius (copy)
	p2:setState({
		currentRouteName = p2:getCurrentRouteName(),
		imageUri = getRbxthumbWithTypeSizeAndOptions(p2.props.localUserId, AvatarHeadShot, 48, true, true)
	})

	function p2.getLoadingImage() -- line: 76
		-- upvalues: Roact (copy), Skeleton (copy), EnumsRadius (copy)
		return Roact.createElement(Skeleton, {
			radius = EnumsRadius.Circle,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end
end
function v21.render(p3) -- line: 86
	-- upvalues: withStyle (copy)
	return withStyle(function(p4) -- line: 87
		-- upvalues: p3 (copy)
		return p3:renderWithProviders(p4)
	end)
end
function v21.didUpdate(p5, p6, p7) -- line: 92
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy)
	local v30 = p5:getCurrentRouteName()

	if v30 and v30 ~= p7.currentRouteName or p5.props and p6 and p5.props.localUserId ~= p6.localUserId then
		p5:setState({
			currentRouteName = v30,
			imageUri = getRbxthumbWithTypeSizeAndOptions(p5.props.localUserId, AvatarHeadShot, 48, true, true)
		})
	end
end
function v21.makeLoadableImage(p8) -- line: 116
	-- upvalues: Roact (copy), LoadableImage (copy), LoadingStrategy (copy)
	if p8.props.localUserId == nil or p8.props.localUserId == "" then
		return nil
	end

	local imageUri = p8.state.imageUri

	return Roact.createElement(LoadableImage, {
		BackgroundTransparency = 1,
		useShimmerAnimationWhileLoading = true,
		shouldHandleReloads = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Image = imageUri,
		cornerRadius = UDim.new(0.5, 0),
		loadingStrategy = LoadingStrategy.Eager
	})
end
function v21.renderWithProviders(p9, p10) -- line: 136
	-- upvalues: Roact (copy), FFlagEnableAvatarHeadshotLocalIconBackgroundFix (copy)
	local Theme = p10.Theme

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(p9.props.Size, p9.props.Size),
		ZIndex = p9.props.ZIndex,
		LayoutOrder = p9.props.LayoutOrder
	}, {
		Background = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = p9.props.ZIndex,
			BackgroundColor3 = p9.props.BackgroundColor3 or Theme.PlaceHolder.Color,
			BackgroundTransparency = p9.props.BackgroundTransparency or if not FFlagEnableAvatarHeadshotLocalIconBackgroundFix then nil else Theme.PlaceHolder.Transparency,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			LoadableImage = p9:makeLoadableImage()
		})
	})
end

local function mapStateToProps(p11) -- line: 166
	return {
		localUserId = p11.LocalUserId
	}
end

local v23 = withNavigation(v21, nil)

return RoactRodux.connect(mapStateToProps)(v23)
