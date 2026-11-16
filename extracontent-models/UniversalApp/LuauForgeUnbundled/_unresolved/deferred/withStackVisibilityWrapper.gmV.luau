local CorePackages = game:GetService("CorePackages")

local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module = require("@luauforge/bundled/fot")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local module2 = require("@luauforge/bundled/gmW")

local avatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarRoute
local module3 = require("@luauforge/bundled/fsK")
local module4 = require("@luauforge/deferred/gmX")
local module5 = require("@luauforge/deferred/gff")

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.rn.stackvis")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local module6 = require("@luauforge/deferred/gmY")

local fFlagCleanupTenFootUiPaddingAndAnalytics = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCleanupTenFootUiPaddingAndAnalytics

local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useEventMap = ReactFocusNavigation.useEventMap
local getFFlagEnableUseShowTopBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableUseShowTopBar

local extended = Roact.PureComponent:extend("StackVisibilityWrapper")

local strictInterface = t.strictInterface
local v5 = {
	component = t.union(t.callback, t.table),
	innerProps = t.optional(t.table),
	navigation = t.table,
	designTokens = 0,
	eventMapRef = 0,
	guiService = 0,
	avatarRoute = 0
}
local v6 = if not fFlagCleanupTenFootUiPaddingAndAnalytics then t.any else nil
v5.designTokens = v6
local v7 = if getFFlagEnableUseShowTopBar() then t.any else nil
v5.eventMapRef = v7

v5.guiService = t.optional(t.union(t.Instance, t.table))

v5.avatarRoute = avatarRoute.Interface
extended.validateProps = strictInterface(v5)

function extended:getRouteName()
	return self.props.navigation.state.routeName
end

function extended:render()
	local routeName = self:getRouteName()
	local navigation = self.props.navigation
	local avatarRoute2 = self.props.avatarRoute
	local component = self.props.component
	local innerProps = self.props.innerProps
	local designTokens = if not fFlagCleanupTenFootUiPaddingAndAnalytics then self.props.designTokens else nil
	local eventMapRef = if getFFlagEnableUseShowTopBar() then self.props.eventMapRef else nil

	local v8 = module4(self.props)

	local joined = Cryo.Dictionary.join(innerProps, {
		navigation = navigation,
		avatarRoute = avatarRoute2
	})

	logger:trace("[{}]: {}", v8 and "VISIBLE" or "NOT VISIBLE", routeName)

	if isVRAppBuild() then
		return Roact.createElement(
			module5,
			{
				visible = v8,
				roundedCornersFrame = avatarScreenProperties[routeName].VRPanelRoundedCorners,
				panelPlacement = avatarScreenProperties[routeName].VRPanelPlacement
			},
			{
				StackScreen = Roact.createElement(component, joined)
			}
		)
	end

	local createElement = Roact.createElement

	local v11 = if fFlagCleanupTenFootUiPaddingAndAnalytics then UDim2.fromScale(1, 1) else UDim2.new(
		1,
		designTokens.rightPadding,
		1,
		designTokens.bottomPadding
	)

	local v12 = if not fFlagCleanupTenFootUiPaddingAndAnalytics then UDim2.fromOffset(
		designTokens.leftPadding,
		designTokens.topPadding
	) else nil
	return createElement("Frame", {
		Size = v11,
		Position = v12,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		BorderSizePixel = 0,
		Visible = v8,
		ref = eventMapRef
	}, {
		StackScreen = Roact.createElement(component, joined)
	})
end

function extended:didMount()
	local routeName = self:getRouteName()
	local guiService = self.props.guiService

	if guiService and module4(self.props) then
		guiService:BroadcastNotification(routeName, module.APP_READY)
	end
end

function extended:didUpdate(p2, p3)
	local guiService = self.props.guiService

	if guiService and not module4(p2) and module4(self.props) then
		guiService:BroadcastNotification(self:getRouteName(), module.APP_READY)
	end
end

local v8 = withNavigation((module3((roactServices.connect({ guiService = appGuiService })(extended)))))

if not fFlagCleanupTenFootUiPaddingAndAnalytics then
	v8 = module6(v8)
end

if getFFlagEnableUseShowTopBar() then
	local noOpEvents = {
		[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NoOpEvent,
		[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NoOpEvent
	}

	local v9 = v8
	v8 = function(p2)
		local v10 = useEventMap(noOpEvents)

		return Roact.createElement(v9, Cryo.Dictionary.join(p2, { eventMapRef = v10 }))
	end
end

local function withStackVisibilityWrapper(p2)
	local v9 = module2(p2)

	return function(p3)
		return Roact.createElement(v8, {
			component = v9,
			innerProps = p3,
			navigation = p3.navigation
		})
	end
end

return withStackVisibilityWrapper
