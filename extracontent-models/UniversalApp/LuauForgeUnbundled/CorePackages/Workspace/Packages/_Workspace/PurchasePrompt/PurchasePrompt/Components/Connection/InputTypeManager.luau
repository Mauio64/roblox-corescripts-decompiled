local UserInputService = game:GetService("UserInputService")

local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local mouseIconOverrideService = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/CoreScriptsCommon").MouseIconOverrideService

local SetGamepadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetGamepadEnabled")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")

local ExternalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/ExternalEventConnection")

local set = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true
}

local extended = roact.Component:extend("InputTypeManager")

function extended:init()
	local setGamepadEnabled = self.props.setGamepadEnabled

	function self.dispatchOnChange(p3)
		local v5 = set[p3] and true or false

		if v5 == self.props.gamepadEnabled then
			return
		end

		setGamepadEnabled(v5)
	end

	self.cursorOverridden = false
end

function extended.render(p2)
	return roact.createElement(ExternalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = p2.dispatchOnChange
	})
end

function extended:didUpdate(p2, p3)
	local v5 = p2.promptState == PromptState.None and self.props.promptState ~= PromptState.None
	local v6 = not (p2.promptState == PromptState.None) and self.props.promptState == PromptState.None

	local v7 = self.props.promptState ~= PromptState.None

	local forceHide = self.props.gamepadEnabled and Enum.OverrideMouseIconBehavior.ForceHide
		or Enum.OverrideMouseIconBehavior.ForceShow

	if v7 and p2.gamepadEnabled ~= self.props.gamepadEnabled then
		if self.cursorOverridden then
			mouseIconOverrideService.pop("PurchasePromptOverrideKey")
		end

		mouseIconOverrideService.push("PurchasePromptOverrideKey", forceHide)
		self.cursorOverridden = true
	elseif v5 then
		mouseIconOverrideService.push("PurchasePromptOverrideKey", forceHide)
		self.cursorOverridden = true
	elseif v6 then
		mouseIconOverrideService.pop("PurchasePromptOverrideKey")
		self.cursorOverridden = false
	end
end

local function mapStateToProps(p2)
	return { promptState = p2.promptState, gamepadEnabled = p2.gamepadEnabled }
end

local function mapDispatchToProps(callback)
	return {
		setGamepadEnabled = function(p2)
			callback(SetGamepadEnabled(p2))
		end
	}
end

return (connectToStore(mapStateToProps, mapDispatchToProps)(extended))
