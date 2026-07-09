local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local t = require(CorePackages.Packages.t)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local AvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarRoute
local v8 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.gamepad")
local GamepadFocusRecovery = require(Modules.AvatarExperience.Common.Components.GamepadFocusRecovery)
local withIsGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).withIsGamepadInput
local v11 = Roact.PureComponent:extend("GamepadFocusHandlerForPage")

v11.validateProps = t.strictInterface({
	focusController = t.table,
	captureFocusOnMount = t.optional(t.boolean),
	isGamepadInput = t.optional(t.boolean),
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface
})
v11.defaultProps = {
	captureFocusOnMount = false
}

function v11.debugName(p1) -- line: 44
	local state = p1.props.navigation.state

	return (state.routeName or "") .. ":" .. (state.key or "")
end
function v11.render(p2) -- line: 49
	-- upvalues: Roact (copy), GamepadFocusRecovery (copy)
	return Roact.createElement(GamepadFocusRecovery, {
		focusController = p2.props.focusController,
		isGamepadInput = p2.props.isGamepadInput,
		debugName = p2:debugName()
	})
end

local function isCurrentScreen(p3) -- line: 57
	local current = p3.avatarRoute.current

	return p3.navigation.state.key == current.key
end

function v11.canCaptureFocus(p4, p5) -- line: 62
	-- upvalues: v8 (copy)
	local avatarRoute = p4.props.avatarRoute
	local isGamepadInput = p4.props.isGamepadInput
	local props = p4.props
	local current = props.avatarRoute.current
	local v24 = props.navigation.state.key == current.key
	local v25 = v24 and (avatarRoute.isVisible and (not avatarRoute.isOverlayVisible and isGamepadInput))

	if p5 then
		v8:trace("{} {} canCapture: {}, isCurrentScreen: {}, currentRoute: {}, isVisible: {}, isOverlayVisible: {}, isGamepadInput: {}", p4:debugName(), p5, v25, v24, avatarRoute.current, avatarRoute.isVisible, avatarRoute.isOverlayVisible, isGamepadInput)
	end

	return v25
end
function v11.didMount(p6) -- line: 86
	-- upvalues: v8 (copy)
	if p6.props.captureFocusOnMount and p6:canCaptureFocus("didMount") then
		v8:debug("captureFocusOnMount page: {}", p6:debugName())
		p6.props.focusController.captureFocus()
	end
end
function v11.didUpdate(p7, p8) -- line: 93
	-- upvalues: v8 (copy)
	if p7:canCaptureFocus("didUpdate") then
		local current = p8.avatarRoute.current
		local v30 = p8.navigation.state.key ~= current.key
		local isGamepadInput = p8.isGamepadInput
		local v32 = not p8.avatarRoute.isVisible

		if v30 or not isGamepadInput or v32 then
			v8:debug("captureFocus {}, navigatedToThisPage: {}, acquiredVisibility: {}", p7:debugName(), v30, v32)
			p7.props.focusController.captureFocus()

			return
		end
	elseif p8.isGamepadInput and not p7.props.isGamepadInput then
		v8:debug("releaseFocus {}", p7:debugName())
		p7.props.focusController.releaseFocus()
	end
end

return (withNavigation((withAvatarRoute((withIsGamepadInput(v11))))))
