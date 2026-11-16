local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local UserInputService = game:GetService("UserInputService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux

local parent = script.Parent.Parent.Parent

local SetInputType = require(parent.Actions.SetInputType)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local Constants = require(parent.Resources.Constants)

local InputTypeMap = Constants.InputTypeMap

local extended = Roact.PureComponent:extend("LastInputTypeConnector")

function extended:updateInputType(p)
	if VRService.VREnabled then
		p = InputTypeMap[Enum.UserInputType.MouseMovement]
	end

	if p then
		self.props.setInputType(p)
	end
end

function extended:init()
	self:updateInputType(InputTypeMap[UserInputService:GetLastInputType()])
end

function extended:render()
	return Roact.createElement(ExternalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = function(p)
			self:updateInputType(InputTypeMap[p])
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
