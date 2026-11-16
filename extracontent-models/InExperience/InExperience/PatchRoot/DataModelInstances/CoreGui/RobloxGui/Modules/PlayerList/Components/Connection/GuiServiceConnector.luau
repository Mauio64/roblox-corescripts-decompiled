local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent.Parent

local SetInspectMenuEnabled = require(parent.Actions.SetInspectMenuEnabled)

local EventConnection = require(script.Parent.EventConnection)

local extended = Roact.PureComponent:extend("GuiServiceConnector")

function extended.render(p)
	return Roact.createFragment({
		InspectMenuEnabledConnection = Roact.createElement(EventConnection, {
			event = GuiService.InspectMenuEnabledChangedSignal,
			callback = function(p2)
				p.props.setInspectMenuEnabled(p2)
			end
		})
	})
end

local function mapDispatchToProps(callback)
	return {
		setInspectMenuEnabled = function(p)
			return callback(SetInspectMenuEnabled(p))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(extended)
