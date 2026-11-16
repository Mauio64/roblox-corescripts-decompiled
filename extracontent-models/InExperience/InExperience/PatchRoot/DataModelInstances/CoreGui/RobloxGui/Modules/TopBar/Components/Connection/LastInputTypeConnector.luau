local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent.Parent

local EventConnection = require(parent.Parent.Common.EventConnection)

local SetInputType = require(parent.Actions.SetInputType)
local Constants = require(parent.Constants)

local InputType = Constants.InputType

local extended = Roact.PureComponent:extend("LastInputTypeConnector")

local v = {
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

function extended.didMount(p)
	local v2 = v[UserInputService:GetLastInputType()]

	if v2 then
		p.props.setInputType(v2)
	end
end

function extended.render(p)
	return Roact.createElement(EventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = function(p2)
			local v2 = v[p2]

			if v2 then
				p.props.setInputType(v2)
			end
		end
	})
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		setInputType = function(p)
			return callback(SetInputType(p))
		end
	}
end)(extended)
