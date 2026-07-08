local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent.Parent
local EventConnection = require(ParentParent.Parent.Common.EventConnection)
local SetInputType = require(ParentParent.Actions.SetInputType)
local InputType = require(ParentParent.Constants).InputType
local v9 = Roact.PureComponent:extend("LastInputTypeConnector")
local t1 = {
	[Enum.UserInputType.MouseButton2] = InputType.MouseAndKeyBoard,
	[Enum.UserInputType.MouseButton3] = InputType.MouseAndKeyBoard,
	[Enum.UserInputType.MouseWheel] = InputType.MouseAndKeyBoard,
	[Enum.UserInputType.MouseMovement] = InputType.MouseAndKeyBoard,
	[Enum.UserInputType.Keyboard] = InputType.MouseAndKeyBoard,
	[Enum.UserInputType.Gamepad1] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad2] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad3] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad4] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad5] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad6] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad7] = InputType.Gamepad,
	[Enum.UserInputType.Gamepad8] = InputType.Gamepad,
	[Enum.UserInputType.Touch] = InputType.Touch
}

function v9.didMount(p1) -- line: 38
	-- upvalues: t1 (copy), UserInputService (copy)
	local v12 = t1[UserInputService:GetLastInputType()]

	if v12 then
		p1.props.setInputType(v12)
	end
end
function v9.render(p2) -- line: 45
	-- upvalues: Roact (copy), EventConnection (copy), UserInputService (copy), t1 (copy)
	return Roact.createElement(EventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = function(p3) -- line: 48
			-- upvalues: t1 (copy), p2 (copy)
			local v16 = t1[p3]

			if v16 then
				p2.props.setInputType(v16)
			end
		end
	})
end

return RoactRodux.UNSTABLE_connect2(nil, function(p4) -- line: 57
	-- upvalues: SetInputType (copy)
	return {
		setInputType = function(p5) -- line: 59
			-- upvalues: p4 (copy), SetInputType (copy)
			return p4(SetInputType(p5))
		end
	}
end)(v9)
