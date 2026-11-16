local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Symbol = AppCommonLib.Symbol
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Resources.Constants)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local named = Symbol.named("InGameMenuCursorOverride")

local InputType = Constants.InputType

local extended = Roact.PureComponent:extend("MouseOverrideManager")

extended.validateProps = t.strictInterface({
	menuOpen = t.boolean,
	exitModalOpen = t.boolean,
	inputType = t.string
})

function extended:render()
	local exitModalOpen = self.props.exitModalOpen

	return Roact.createElement(ExternalEventConnection, {
		event = UserInputService:GetPropertyChangedSignal("OverrideMouseIconBehavior"),
		callback = function()
			if
				(self.props.menuOpen or exitModalOpen)
				and UserInputService.OverrideMouseIconBehavior == Enum.OverrideMouseIconBehavior.None
			then
				self:updateMouseIconOverride()
			end
		end
	})
end

function extended:init()
	self.didOverrideMouse = false
end

function extended:updateMouseIconOverride()
	local exitModalOpen = self.props.exitModalOpen

	if self.props.menuOpen or exitModalOpen then
		self.didOverrideMouse = true

		if self.props.inputType == InputType.Gamepad or VRService.VREnabled then
			MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceHide)
		else
			MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceShow)
		end
	elseif self.didOverrideMouse then
		self.didOverrideMouse = false
		MouseIconOverrideService.pop(named)
	end
end

function extended:didMount()
	self:updateMouseIconOverride()
end

function extended:didUpdate()
	self:updateMouseIconOverride()
end

return RoactRodux.UNSTABLE_connect2(function(data)
	local closingApp = data.nativeClosePrompt.closingApp

	return {
		menuOpen = data.isMenuOpen,
		exitModalOpen = closingApp,
		inputType = data.displayOptions.inputType
	}
end, nil)(extended)
