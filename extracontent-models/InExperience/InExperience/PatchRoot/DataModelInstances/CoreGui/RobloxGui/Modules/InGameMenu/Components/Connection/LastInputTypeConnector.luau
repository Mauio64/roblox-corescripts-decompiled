local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local UserInputService = game:GetService("UserInputService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local ParentParent = script.Parent.Parent.Parent
local SetInputType = require(ParentParent.Actions.SetInputType)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local InputTypeMap = require(ParentParent.Resources.Constants).InputTypeMap
local v11 = Roact.PureComponent:extend("LastInputTypeConnector")

function v11.updateInputType(p1, p2) -- line: 19
	-- upvalues: VRService (copy), InputTypeMap (copy)
	if VRService.VREnabled then
		p2 = InputTypeMap[Enum.UserInputType.MouseMovement]
	end

	if p2 then
		p1.props.setInputType(p2)
	end
end
function v11.init(p3) -- line: 32
	-- upvalues: InputTypeMap (copy), UserInputService (copy)
	p3:updateInputType(InputTypeMap[UserInputService:GetLastInputType()])
end
function v11.render(p4) -- line: 37
	-- upvalues: Roact (copy), ExternalEventConnection (copy), UserInputService (copy), InputTypeMap (copy)
	return Roact.createElement(ExternalEventConnection, {
		event = UserInputService.LastInputTypeChanged,
		callback = function(p5) -- line: 40
			-- upvalues: InputTypeMap (copy), p4 (copy)
			local v18 = InputTypeMap[p5]

			p4:updateInputType(v18)
		end
	})
end

return RoactRodux.UNSTABLE_connect2(nil, function(p6) -- line: 47
	-- upvalues: SetInputType (copy)
	return {
		setInputType = function(p7) -- line: 49
			-- upvalues: p6 (copy), SetInputType (copy)
			return p6(SetInputType(p7))
		end
	}
end)(v11)
