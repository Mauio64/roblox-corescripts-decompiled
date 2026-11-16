local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local MockableProxyServices = require(CorePackages.Workspace.Packages.MockableProxyServices)
local VRService = MockableProxyServices.VRService
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent

local Controls = require(parent.Resources.Controls)

local KeyboardControls = require(script.ControlLayouts.KeyboardControls)
local GamepadControls = require(script.ControlLayouts.GamepadControls)
local VRGamepadControlsWrapper = require(script.ControlLayouts.VRGamepadControlsWrapper)

local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRUtil = VrCommon.VRUtil

local FocusHandler = require(parent.Components.Connection.FocusHandler)

local extended = Roact.PureComponent:extend("ControlsPage")

extended.validateProps = t.strictInterface({
	pageTitle = t.string,
	controlLayout = t.optional(t.string),
	canCaptureFocus = t.optional(t.boolean)
})

function extended:init()
	self.closeButtonRef = Roact.createRef()
end

function extended.render(p)
	local controlLayout = p.props.controlLayout

	if controlLayout == Controls.ControlLayouts.KEYBOARD then
		return Roact.createElement(KeyboardControls)
	end

	if controlLayout ~= Controls.ControlLayouts.GAMEPAD then
		return nil
	end

	if VRService.VREnabled and VRUtil.getCurrentControllerType() == "Touch" then
		return Roact.createElement(VRGamepadControlsWrapper)
	end

	return Roact.createFragment({
		GamepadControls = Roact.createElement(GamepadControls, { closeButtonRef = p.closeButtonRef }),
		FocusHandler = Roact.createElement(FocusHandler, {
			isFocused = p.props.canCaptureFocus,
			didFocus = function()
				local selectedCoreObject = p.closeButtonRef:getValue()
				GuiService:AddSelectionParent("IGMControlsPage_CloseButtonSelectionGroup", selectedCoreObject)
				GuiService.SelectedCoreObject = selectedCoreObject
			end,
			didBlur = function()
				GuiService:RemoveSelectionGroup("IGMControlsPage_CloseButtonSelectionGroup")
			end
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p)
	return {
		controlLayout = p.controlLayout,
		canCaptureFocus = p.menuPage == "Controls"
	}
end)(extended)
