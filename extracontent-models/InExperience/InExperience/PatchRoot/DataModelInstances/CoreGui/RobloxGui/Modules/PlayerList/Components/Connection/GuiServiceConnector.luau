local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent.Parent
local SetInspectMenuEnabled = require(ParentParent.Actions.SetInspectMenuEnabled)
local EventConnection = require(script.Parent.EventConnection)
local v8 = Roact.PureComponent:extend("GuiServiceConnector")

function v8.render(p1) -- line: 16
	-- upvalues: Roact (copy), EventConnection (copy), GuiService (copy)
	return Roact.createFragment({
		InspectMenuEnabledConnection = Roact.createElement(EventConnection, {
			event = GuiService.InspectMenuEnabledChangedSignal,
			callback = function(p2) -- line: 20
				-- upvalues: p1 (copy)
				p1.props.setInspectMenuEnabled(p2)
			end
		})
	})
end

local function mapDispatchToProps(p3) -- line: 27
	-- upvalues: SetInspectMenuEnabled (copy)
	return {
		setInspectMenuEnabled = function(p4) -- line: 29
			-- upvalues: p3 (copy), SetInspectMenuEnabled (copy)
			return p3(SetInspectMenuEnabled(p4))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v8)
