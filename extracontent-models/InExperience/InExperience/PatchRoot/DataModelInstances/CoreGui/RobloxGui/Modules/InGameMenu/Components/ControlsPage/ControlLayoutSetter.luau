local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local ParentParent = script.Parent.Parent.Parent
local Controls = require(ParentParent.Resources.Controls)
local SetControlLayout = require(ParentParent.Actions.SetControlLayout)
local v9 = Roact.PureComponent:extend("ControlLayoutSetter")

function v9.init(p1) -- line: 16
	-- upvalues: Controls (copy), UserInputService (copy)
	local v11 = Controls.inputToControlTypeMap[UserInputService:GetLastInputType()]

	if v11 then
		p1.props.dispatchSetControlLayout(v11)
	end
end
function v9.render(_) -- line: 23
	return nil
end
function v9.didMount(p3) -- line: 27
	-- upvalues: UserInputService (copy), Controls (copy)
	p3.inputChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p4) -- line: 28
		-- upvalues: Controls (copy), p3 (copy)
		local v17 = Controls.inputToControlTypeMap[p4]

		if v17 then
			p3.props.dispatchSetControlLayout(v17)
		end
	end)
end
function v9.willUnmount(p5) -- line: 39
	if p5.inputChangedConnection then
		p5.inputChangedConnection:Disconnect()
	end
end

return RoactRodux.UNSTABLE_connect2(nil, function(p6) -- line: 45
	-- upvalues: SetControlLayout (copy)
	return {
		dispatchSetControlLayout = function(p7) -- line: 47
			-- upvalues: p6 (copy), SetControlLayout (copy)
			p6(SetControlLayout(p7))
		end
	}
end)(v9)
