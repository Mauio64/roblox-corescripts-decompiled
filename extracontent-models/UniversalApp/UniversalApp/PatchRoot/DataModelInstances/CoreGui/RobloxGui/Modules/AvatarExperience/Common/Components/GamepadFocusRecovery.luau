local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local AvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarRoute
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local t = require(CorePackages.Packages.t)
local v10 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.gamepad")
local v11 = Roact.PureComponent:extend("GamepadFocusRecovery")

v11.defaultProps = {
	debugName = "Unspecified"
}
v11.validateProps = t.strictInterface({
	focusController = t.table,
	isGamepadInput = t.boolean,
	debugName = t.optional(t.string),
	avatarRoute = AvatarRoute.Interface,
	navigation = t.table
})

function v11.init(p1) -- line: 51
	-- upvalues: GuiService (copy)
	p1:setState({
		isFocused = p1.props.navigation.isFocused()
	})

	function p1.onWillFocus() -- line: 56
		-- upvalues: p1 (copy), GuiService (copy)
		p1.selectedCoreObjectConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 57
			-- upvalues: p1 (copy)
			p1:startTrackingSelectedCoreObject()
		end)
		p1:startTrackingSelectedCoreObject()
		p1:setState({
			isFocused = true
		})
	end
	function p1.onWillBlur() -- line: 68
		-- upvalues: p1 (copy)
		p1:onBlurOrUnmount()
		p1:setState({
			isFocused = false
		})
	end
end
function v11.onBlurOrUnmount(p2) -- line: 76
	p2:stopTrackingSelectedCoreObject()

	if p2.selectedCoreObjectConnection then
		p2.selectedCoreObjectConnection:Disconnect()
		p2.selectedCoreObjectConnection = nil
	end
end
function v11.handleFocusLost(p3, p4) -- line: 85
	-- upvalues: GuiService (copy), v10 (copy)
	wait()

	local SelectedCoreObject = GuiService.SelectedCoreObject

	if SelectedCoreObject ~= nil and SelectedCoreObject:IsDescendantOf(game) then
		return
	end

	if p3:canCaptureFocus() then
		p3.props.focusController:captureFocus()

		if p4 ~= nil then
			v10:debug(string.format("[GamepadFocusRecovery] Lost focus on object: %s, screen: %s, %s", tostring(p4), p3.props.debugName, (tostring(p3.props.avatarRoute))))
		end
	end
end
function v11.startTrackingSelectedCoreObject(p5) -- line: 113
	-- upvalues: GuiService (copy), v10 (copy)
	p5:stopTrackingSelectedCoreObject()

	local SelectedCoreObject = GuiService.SelectedCoreObject

	v10:trace("SelectedCoreObject: {}", SelectedCoreObject and SelectedCoreObject:GetFullName() or "nil")

	if SelectedCoreObject == nil or not SelectedCoreObject:IsDescendantOf(game) then
		p5:handleFocusLost(SelectedCoreObject)

		return
	end

	p5.selectedCoreObjectAncestryConnection = SelectedCoreObject.AncestryChanged:Connect(function(_, parent) -- line: 122
		-- upvalues: p5 (copy), SelectedCoreObject (copy)
		if not parent then
			p5:stopTrackingSelectedCoreObject()
			p5:handleFocusLost(SelectedCoreObject)
		end
	end)
end
function v11.stopTrackingSelectedCoreObject(p7) -- line: 131
	if p7.selectedCoreObjectAncestryConnection then
		p7.selectedCoreObjectAncestryConnection:Disconnect()
		p7.selectedCoreObjectAncestryConnection = nil
	end
end
function v11.render(p8) -- line: 138
	-- upvalues: Roact (copy), RoactNavigation (copy)
	return Roact.createElement(RoactNavigation.NavigationEvents, {
		onWillFocus = p8.onWillFocus,
		onWillBlur = p8.onWillBlur
	})
end
function v11.willUnmount(p9) -- line: 145
	p9:onBlurOrUnmount()
end
function v11.canCaptureFocus(p10) -- line: 149
	return p10.props.avatarRoute and (p10.props.avatarRoute.isVisible and (p10.props.isGamepadInput and p10.state.isFocused))
end

return withNavigation(withAvatarRoute(v11), nil)
