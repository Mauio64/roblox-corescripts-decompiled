local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux

local parent = script.Parent.Parent.Parent

local Controls = require(parent.Resources.Controls)

local SetControlLayout = require(parent.Actions.SetControlLayout)

local extended = Roact.PureComponent:extend("ControlLayoutSetter")

function extended.init(p)
	local inputToControlType = Controls.inputToControlTypeMap[UserInputService:GetLastInputType()]

	if inputToControlType then
		p.props.dispatchSetControlLayout(inputToControlType)
	end
end

function extended.render(_): nil
	return nil
end

function extended:didMount()
	self.inputChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
		local inputToControlType = Controls.inputToControlTypeMap[p]

		if inputToControlType then
			self.props.dispatchSetControlLayout(inputToControlType)
		end
	end)
end

function extended.willUnmount(p)
	if p.inputChangedConnection then
		p.inputChangedConnection:Disconnect()
	end
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		dispatchSetControlLayout = function(p)
			callback(SetControlLayout(p))
		end
	}
end)(extended)
