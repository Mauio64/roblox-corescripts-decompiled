local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local ControllerBar = InGameMenuDependencies.UIBlox.App.Bar.ControllerBar
local ParentParent = script.Parent.Parent
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local RoactRodux = InGameMenuDependencies.RoactRodux
local Constants = require(ParentParent.Resources.Constants)
local IncrementControllerBar = require(ParentParent.Actions.IncrementControllerBar)
local DecrementControllerBar = require(ParentParent.Actions.DecrementControllerBar)
local v12 = Roact.PureComponent:extend("IGMControllerBar2")

v12.validateProps = t.strictInterface({
	rightHints = t.table,
	leftHint = t.table,
	incrementControllerBar = t.callback,
	decrementControllerBar = t.callback
})

function v12.init(p1) -- line: 24
	p1.props.incrementControllerBar()
end
function v12.willUnmount(p2) -- line: 28
	p2.props.decrementControllerBar()
end
function v12.render(p3) -- line: 32
	-- upvalues: Roact (copy), CoreGui (copy), Constants (copy), ControllerBar (copy)
	return Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		IGMControllerBar = Roact.createElement("ScreenGui", {
			DisplayOrder = Constants.DisplayOrder.ControllerBar
		}, {
			ControllerBar = Roact.createElement(ControllerBar, {
				rightHints = p3.props.rightHints,
				leftHint = p3.props.leftHint
			})
		})
	})
end

return RoactRodux.UNSTABLE_connect2(nil, function(p4) -- line: 48
	-- upvalues: IncrementControllerBar (copy), DecrementControllerBar (copy)
	return {
		incrementControllerBar = function() -- line: 50
			-- upvalues: p4 (copy), IncrementControllerBar (copy)
			p4(IncrementControllerBar())
		end,
		decrementControllerBar = function() -- line: 53
			-- upvalues: p4 (copy), DecrementControllerBar (copy)
			p4(DecrementControllerBar())
		end
	}
end)(v12)
