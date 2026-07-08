local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local Symbol = require(CorePackages.Workspace.Packages.AppCommonLib).Symbol
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local v13 = Symbol.named("InGameMenuCursorOverride")
local InputType = Constants.InputType
local v15 = Roact.PureComponent:extend("MouseOverrideManager")

v15.validateProps = t.strictInterface({
	menuOpen = t.boolean,
	exitModalOpen = t.boolean,
	inputType = t.string
})

function v15.render(p1) -- line: 30
	-- upvalues: Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	local exitModalOpen = p1.props.exitModalOpen

	return Roact.createElement(ExternalEventConnection, {
		event = UserInputService:GetPropertyChangedSignal("OverrideMouseIconBehavior"),
		callback = function() -- line: 35
			-- upvalues: p1 (copy), exitModalOpen (copy), UserInputService (copy)
			if (p1.props.menuOpen or exitModalOpen) and UserInputService.OverrideMouseIconBehavior == Enum.OverrideMouseIconBehavior.None then
				p1:updateMouseIconOverride()
			end
		end
	})
end
function v15.init(p2) -- line: 48
	p2.didOverrideMouse = false
end
function v15.updateMouseIconOverride(p3) -- line: 52
	-- upvalues: InputType (copy), VRService (copy), MouseIconOverrideService (copy), v13 (copy)
	local exitModalOpen = p3.props.exitModalOpen

	if p3.props.menuOpen or exitModalOpen then
		p3.didOverrideMouse = true

		if p3.props.inputType == InputType.Gamepad or VRService.VREnabled then
			MouseIconOverrideService.push(v13, Enum.OverrideMouseIconBehavior.ForceHide)

			return
		end

		MouseIconOverrideService.push(v13, Enum.OverrideMouseIconBehavior.ForceShow)

		return
	end

	if p3.didOverrideMouse then
		p3.didOverrideMouse = false
		MouseIconOverrideService.pop(v13)
	end
end
function v15.didMount(p4) -- line: 68
	p4:updateMouseIconOverride()
end
function v15.didUpdate(p5) -- line: 72
	p5:updateMouseIconOverride()
end

return RoactRodux.UNSTABLE_connect2(function(p6) -- line: 76
	local closingApp = p6.nativeClosePrompt.closingApp

	return {
		menuOpen = p6.isMenuOpen,
		exitModalOpen = closingApp,
		inputType = p6.displayOptions.inputType
	}
end, nil)(v15)
