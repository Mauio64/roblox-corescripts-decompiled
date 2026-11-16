local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

local RoactRodux = require(CorePackages.Packages.RoactRodux)

require("@luauforge/bundled/dHK")

local withStyle = UIBlox.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage

local module = require("@luauforge/bundled/dTK")

local module2 = require("@luauforge/bundled/dTL")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local module3 = require("@luauforge/bundled/cgr")
local constants = module3.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions

local loadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy
local module4 = require("@luauforge/bundled/dTM")

local avatarHeadShot = constants.RbxthumbTypes.AvatarHeadShot

local extended = Roact.PureComponent:extend("AvatarHeadshotLocalIcon")

extended.defaultProps = { Size = 36, LayoutOrder = 1 }

extended.validateProps = t.strictInterface({
	Size = t.optional(t.number),
	ZIndex = t.number,
	LayoutOrder = t.optional(t.integer),
	BackgroundColor3 = t.optional(t.Color3),
	BackgroundTransparency = t.optional(t.number),
	navigation = t.table,
	localUserId = t.string
})

function extended:getCurrentRouteName()
	if
		self.props.navigation
		and self.props.navigation.state
		and self.props.navigation.state.routes
		and self.props.navigation.state.routes[1]
		and module4.getActiveScreenNavigationState(self.props.navigation.state.routes[1])
		and module4.getActiveScreenNavigationState(self.props.navigation.state.routes[1]).routeName
	then
		return module4.getActiveScreenNavigationState(self.props.navigation.state.routes[1]).routeName
	end
end

function extended:init()
	self:setState({
		currentRouteName = self:getCurrentRouteName(),
		imageUri = getRbxthumbWithTypeSizeAndOptions(
			self.props.localUserId,
			avatarHeadShot,
			48,
			true,
			true,
			module2
		)
	})

	function self.getLoadingImage()
		return Roact.createElement(skeleton, {
			radius = radius.Circle,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended:didUpdate(p2, p3)
	local currentRouteName = self:getCurrentRouteName()

	if
		currentRouteName and currentRouteName ~= p3.currentRouteName
		or self.props and p2 and self.props.localUserId ~= p2.localUserId
	then
		self:setState({
			currentRouteName = currentRouteName,
			imageUri = getRbxthumbWithTypeSizeAndOptions(
				self.props.localUserId,
				avatarHeadShot,
				48,
				true,
				true,
				module2
			)
		})
	end
end

function extended:makeLoadableImage()
	if self.props.localUserId == nil or self.props.localUserId == "" then
		return nil
	end

	local imageUri = self.state.imageUri

	return Roact.createElement(loadableImage, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = imageUri,
		useShimmerAnimationWhileLoading = true,
		cornerRadius = UDim.new(0.5, 0),
		shouldHandleReloads = true,
		loadingStrategy = loadingStrategy.Eager
	})
end

function extended:renderWithProviders(p2)
	local theme = p2.Theme

	local createElement = Roact.createElement
	local v6 = {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(self.props.Size, self.props.Size),
		ZIndex = self.props.ZIndex,
		LayoutOrder = self.props.LayoutOrder
	}

	local createElement2 = Roact.createElement
	local v9 = {
		ZIndex = self.props.ZIndex,
		BorderSizePixel = 0,
		BackgroundColor3 = self.props.BackgroundColor3 or theme.PlaceHolder.Color,
		BackgroundTransparency = 0,
		Size = 0,
		Position = 0,
		AnchorPoint = 0
	}
	local v10 = self.props.BackgroundTransparency

	if not v10 then
		v10 = if module then theme.PlaceHolder.Transparency else nil
	end

	v9.BackgroundTransparency = v10

	v9.Size = UDim2.new(1, 0, 1, 0)
	v9.Position = UDim2.fromScale(0.5, 0.5)
	v9.AnchorPoint = Vector2.new(0.5, 0.5)
	return createElement("Frame", v6, {
		Background = createElement2("Frame", v9, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			LoadableImage = self:makeLoadableImage()
		})
	})
end

local function mapStateToProps(p2)
	return { localUserId = p2.LocalUserId }
end

local v5 = withNavigation(extended, nil)

return RoactRodux.connect(mapStateToProps)(v5)
