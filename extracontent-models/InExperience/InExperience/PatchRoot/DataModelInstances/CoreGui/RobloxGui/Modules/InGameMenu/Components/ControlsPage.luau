local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local VRService = require(CorePackages.Workspace.Packages.MockableProxyServices).VRService
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local Controls = require(ParentParent.Resources.Controls)
local KeyboardControls = require(script.ControlLayouts.KeyboardControls)
local GamepadControls = require(script.ControlLayouts.GamepadControls)
local VRGamepadControlsWrapper = require(script.ControlLayouts.VRGamepadControlsWrapper)
local VRUtil = require(CorePackages.Workspace.Packages.VrCommon).VRUtil
local FocusHandler = require(ParentParent.Components.Connection.FocusHandler)
local v15 = Roact.PureComponent:extend("ControlsPage")

v15.validateProps = t.strictInterface({
	pageTitle = t.string,
	controlLayout = t.optional(t.string),
	canCaptureFocus = t.optional(t.boolean)
})

function v15.init(p1) -- line: 33
	-- upvalues: Roact (copy)
	p1.closeButtonRef = Roact.createRef()
end
function v15.render(p2) -- line: 37
	-- upvalues: Controls (copy), Roact (copy), KeyboardControls (copy), VRService (copy), VRUtil (copy), VRGamepadControlsWrapper (copy), GamepadControls (copy), FocusHandler (copy), GuiService (copy)
	local controlLayout = p2.props.controlLayout

	if controlLayout == Controls.ControlLayouts.KEYBOARD then
		return Roact.createElement(KeyboardControls)
	end

	if controlLayout == Controls.ControlLayouts.GAMEPAD then
		if VRService.VREnabled and VRUtil.getCurrentControllerType() == "Touch" then
			return Roact.createElement(VRGamepadControlsWrapper)
		end

		return Roact.createFragment({
			GamepadControls = Roact.createElement(GamepadControls, {
				closeButtonRef = p2.closeButtonRef
			}),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p2.props.canCaptureFocus,
				didFocus = function() -- line: 52
					-- upvalues: p2 (copy), GuiService (copy)
					local v20 = p2.closeButtonRef:getValue()

					GuiService:AddSelectionParent("IGMControlsPage_CloseButtonSelectionGroup", v20)
					GuiService.SelectedCoreObject = v20
				end,
				didBlur = function() -- line: 57
					-- upvalues: GuiService (copy)
					GuiService:RemoveSelectionGroup("IGMControlsPage_CloseButtonSelectionGroup")
				end
			})
		})
	end

	return nil
end

return RoactRodux.UNSTABLE_connect2(function(p3) -- line: 69
	return {
		controlLayout = p3.controlLayout,
		canCaptureFocus = p3.menuPage == "Controls"
	}
end)(v15)
