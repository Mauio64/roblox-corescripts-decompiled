local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local UserInputService = game:GetService("UserInputService")

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService

local SetGamepadEnabled = require(PurchasePrompt.Actions.SetGamepadEnabled)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local connectToStore = require(PurchasePrompt.connectToStore)

local ExternalEventConnection = require(script.Parent.ExternalEventConnection)

local set = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true
}

local extended = Roact.Component:extend("InputTypeManager")

function extended:init()
	local setGamepadEnabled = self.props.setGamepadEnabled

	function self.dispatchOnChange(p)
		local v = set[p] and true or false

		if v == self.props.gamepadEnabled then
			return
		end

		setGamepadEnabled(v)
	end

	self.cursorOverridden = false
end

function extended.render(p)
	return Roact.createElement(ExternalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = p.dispatchOnChange
	})
end

function extended:didUpdate(p, _)
	local v

	if p.promptState == PromptState.None then
		v = self.props.promptState ~= PromptState.None
	else
		v = false
	end

	local v2

	if p.promptState == PromptState.None then
		v2 = false
	else
		v2 = self.props.promptState == PromptState.None
	end

	local v3 = self.props.promptState ~= PromptState.None

	local forceHide = self.props.gamepadEnabled and Enum.OverrideMouseIconBehavior.ForceHide
		or Enum.OverrideMouseIconBehavior.ForceShow

	if v3 and p.gamepadEnabled ~= self.props.gamepadEnabled then
		if self.cursorOverridden then
			MouseIconOverrideService.pop("PurchasePromptOverrideKey")
		end

		MouseIconOverrideService.push("PurchasePromptOverrideKey", forceHide)
		self.cursorOverridden = true
	elseif v then
		MouseIconOverrideService.push("PurchasePromptOverrideKey", forceHide)
		self.cursorOverridden = true
	elseif v2 then
		MouseIconOverrideService.pop("PurchasePromptOverrideKey")
		self.cursorOverridden = false
	end
end

local function mapStateToProps(p)
	return { promptState = p.promptState, gamepadEnabled = p.gamepadEnabled }
end

local function mapDispatchToProps(callback)
	return {
		setGamepadEnabled = function(p)
			callback(SetGamepadEnabled(p))
		end
	}
end

return (connectToStore(mapStateToProps, mapDispatchToProps)(extended))
