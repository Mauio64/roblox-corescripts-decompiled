local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)

local ControllerBar = InGameMenuDependencies.UIBlox.App.Bar.ControllerBar
local parent = script.Parent.Parent
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local RoactRodux = InGameMenuDependencies.RoactRodux
local Constants = require(parent.Resources.Constants)
local IncrementControllerBar = require(parent.Actions.IncrementControllerBar)
local DecrementControllerBar = require(parent.Actions.DecrementControllerBar)
local extended = Roact.PureComponent:extend("IGMControllerBar2")

extended.validateProps = t.strictInterface({
	rightHints = t.table,
	leftHint = t.table,
	incrementControllerBar = t.callback,
	decrementControllerBar = t.callback
})

function extended.init(p)
	p.props.incrementControllerBar()
end

function extended.willUnmount(p)
	p.props.decrementControllerBar()
end

function extended.render(p)
	return Roact.createElement(Roact.Portal, { target = CoreGui }, {
		IGMControllerBar = Roact.createElement("ScreenGui", {
			DisplayOrder = Constants.DisplayOrder.ControllerBar
		}, {
			ControllerBar = Roact.createElement(ControllerBar, {
				rightHints = p.props.rightHints,
				leftHint = p.props.leftHint
			})
		})
	})
end

return RoactRodux.UNSTABLE_connect2(nil, function(callback)
	return {
		incrementControllerBar = function()
			callback(IncrementControllerBar())
		end,
		decrementControllerBar = function()
			callback(DecrementControllerBar())
		end
	}
end)(extended)
