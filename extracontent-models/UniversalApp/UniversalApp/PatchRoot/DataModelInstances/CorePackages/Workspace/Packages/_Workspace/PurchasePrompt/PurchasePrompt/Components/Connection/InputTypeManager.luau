local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local UserInputService = game:GetService("UserInputService")
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local MouseIconOverrideService = require(PurchasePromptParent.CoreScriptsCommon).MouseIconOverrideService
local SetGamepadEnabled = require(PurchasePrompt.Actions.SetGamepadEnabled)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local connectToStore = require(PurchasePrompt.connectToStore)
local ExternalEventConnection = require(script.Parent.ExternalEventConnection)
local t1 = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true
}
local v11 = Roact.Component:extend("InputTypeManager")

function v11.init(p1) -- line: 31
	-- upvalues: t1 (copy)
	local setGamepadEnabled = p1.props.setGamepadEnabled

	function p1.dispatchOnChange(p2) -- line: 34
		-- upvalues: t1 (copy), p1 (copy), setGamepadEnabled (copy)
		local v27 = not not t1[p2]

		if v27 == p1.props.gamepadEnabled then
			return
		end

		setGamepadEnabled(v27)
	end

	p1.cursorOverridden = false
end
function v11.render(p3) -- line: 50
	-- upvalues: Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	return Roact.createElement(ExternalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = p3.dispatchOnChange
	})
end
function v11.didUpdate(p4, p5, _) -- line: 57
	-- upvalues: PromptState (copy), MouseIconOverrideService (copy)
	local v20 = p5.promptState == PromptState.None and p4.props.promptState ~= PromptState.None
	local v21 = p5.promptState ~= PromptState.None and p4.props.promptState == PromptState.None
	local v22 = p4.props.promptState ~= PromptState.None
	local v23 = p4.props.gamepadEnabled and Enum.OverrideMouseIconBehavior.ForceHide or Enum.OverrideMouseIconBehavior.ForceShow

	if v22 and p5.gamepadEnabled ~= p4.props.gamepadEnabled then
		if p4.cursorOverridden then
			MouseIconOverrideService.pop("PurchasePromptOverrideKey")
		end

		MouseIconOverrideService.push("PurchasePromptOverrideKey", v23)
		p4.cursorOverridden = true

		return
	end

	if v20 then
		MouseIconOverrideService.push("PurchasePromptOverrideKey", v23)
		p4.cursorOverridden = true

		return
	end

	if v21 then
		MouseIconOverrideService.pop("PurchasePromptOverrideKey")
		p4.cursorOverridden = false
	end
end

local function mapStateToProps(p7) -- line: 84
	return {
		promptState = p7.promptState,
		gamepadEnabled = p7.gamepadEnabled
	}
end
local function mapDispatchToProps(p8) -- line: 91
	-- upvalues: SetGamepadEnabled (copy)
	return {
		setGamepadEnabled = function(p9) -- line: 93
			-- upvalues: p8 (copy), SetGamepadEnabled (copy)
			p8(SetGamepadEnabled(p9))
		end
	}
end

return (connectToStore(mapStateToProps, mapDispatchToProps)(v11))
