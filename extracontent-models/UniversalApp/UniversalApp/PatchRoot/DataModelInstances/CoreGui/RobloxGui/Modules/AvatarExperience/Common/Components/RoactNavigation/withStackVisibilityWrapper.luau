local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local AfterAvatarExperienceLoaded = require(Modules.AvatarExperience.Common.Components.AfterAvatarExperienceLoaded)
local AvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarRoute
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local isAvatarRouteVisible = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Utils.isAvatarRouteVisible)
local AvatarVRPanelWrapper = require(Modules.AvatarExperience.Common.Components.AvatarVRPanelWrapper)
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local v17 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.rn.stackvis")
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local with10ftUIPadding = require(Modules.AvatarExperience.Common.Components.with10ftUIPadding)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local useEventMap = require(CorePackages.Packages.ReactFocusNavigation).useEventMap
local GetFFlagEnableUseShowTopBar = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableUseShowTopBar
local v23 = Roact.PureComponent:extend("StackVisibilityWrapper")

v23.validateProps = t.strictInterface({
	component = t.union(t.callback, t.table),
	innerProps = t.optional(t.table),
	navigation = t.table,
	designTokens = t.any,
	eventMapRef = if not GetFFlagEnableUseShowTopBar() then nil else t.any,
	guiService = t.optional(t.union(t.Instance, t.table)),
	avatarRoute = AvatarRoute.Interface
})

function v23.getRouteName(p1) -- line: 50
	return p1.props.navigation.state.routeName
end
function v23.render(p2) -- line: 55
	-- upvalues: GetFFlagEnableUseShowTopBar (copy), isAvatarRouteVisible (copy), Cryo (copy), v17 (copy), IsVRAppBuild (copy), Roact (copy), AvatarVRPanelWrapper (copy), AvatarScreenProperties (copy)
	local v30 = p2:getRouteName()
	local navigation = p2.props.navigation
	local avatarRoute = p2.props.avatarRoute
	local component = p2.props.component
	local innerProps = p2.props.innerProps
	local designTokens = p2.props.designTokens
	local topPadding = designTokens.topPadding
	local leftPadding = designTokens.leftPadding
	local bottomPadding = designTokens.bottomPadding
	local rightPadding = designTokens.rightPadding
	local v40 = if not GetFFlagEnableUseShowTopBar() then nil else p2.props.eventMapRef
	local v41 = isAvatarRouteVisible(p2.props)
	local v42 = Cryo.Dictionary.join(innerProps, {
		navigation = navigation,
		avatarRoute = avatarRoute
	})

	v17:trace("[{}]: {}", not v41 and "NOT VISIBLE" or "VISIBLE", v30)

	if IsVRAppBuild() then
		return Roact.createElement(AvatarVRPanelWrapper, {
			visible = v41,
			roundedCornersFrame = AvatarScreenProperties[v30].VRPanelRoundedCorners,
			panelPlacement = AvatarScreenProperties[v30].VRPanelPlacement
		}, {
			StackScreen = Roact.createElement(component, v42)
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		BorderSizePixel = 0,
		Size = UDim2.new(1, rightPadding, 1, bottomPadding),
		Position = UDim2.fromOffset(leftPadding, topPadding),
		Visible = v41,
		ref = v40
	}, {
		StackScreen = Roact.createElement(component, v42)
	})
end
function v23.didMount(p3) -- line: 102
	-- upvalues: isAvatarRouteVisible (copy), NotificationType (copy)
	local v44 = p3:getRouteName()
	local guiService = p3.props.guiService

	if guiService and isAvatarRouteVisible(p3.props) then
		guiService:BroadcastNotification(v44, NotificationType.APP_READY)
	end
end
function v23.didUpdate(p4, p5, _) -- line: 112
	-- upvalues: isAvatarRouteVisible (copy), NotificationType (copy)
	local guiService = p4.props.guiService

	if guiService and (not isAvatarRouteVisible(p5) and isAvatarRouteVisible(p4.props)) then
		guiService:BroadcastNotification(p4:getRouteName(), NotificationType.APP_READY)
	end
end

local u24 = with10ftUIPadding((withNavigation((withAvatarRoute((RoactServices.connect({
	guiService = AppGuiService
})(v23)))))))

if GetFFlagEnableUseShowTopBar() then
	local t1 = {
		[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NoOpEvent,
		[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NoOpEvent
	}
	local v26 = u24

	function u24(p7) -- line: 140
		-- upvalues: useEventMap (copy), t1 (copy), Roact (copy), v26 (copy), Cryo (copy)
		local v51 = useEventMap(t1)

		return Roact.createElement(v26, Cryo.Dictionary.join(p7, {
			eventMapRef = v51
		}))
	end
end

local function withStackVisibilityWrapper(p8) -- line: 165
	-- upvalues: AfterAvatarExperienceLoaded (copy), Roact (copy), u24 (ref)
	local u53 = AfterAvatarExperienceLoaded(p8)

	return function(p9) -- line: 170
		-- upvalues: Roact (copy), u24 (ref), u53 (ref)
		return Roact.createElement(u24, {
			component = u53,
			innerProps = p9,
			navigation = p9.navigation
		})
	end
end

return withStackVisibilityWrapper
