local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local Roact = require(CorePackages.Packages.Roact)
local AndroidBackButtonConnection = require(Modules.LuaApp.Navigation.AndroidBackButtonConnection)
local v5 = Roact.PureComponent:extend("AndroidBackButtonNavigationHandler")

v5.defaultProps = {
	androidBackButtonConnection = function() -- line: 9
		-- upvalues: AndroidBackButtonConnection (copy)
		return AndroidBackButtonConnection()
	end
}

function v5.init(p1) -- line: 14
	p1.androidBackButtonConnection = p1.props.androidBackButtonConnection()

	function p1.onBackButtonPressed() -- line: 17
		-- upvalues: p1 (copy)
		if p1.props.disabled then
			return
		end

		if p1.props.canGoBackInRN and p1.props.navigateBackInRN then
			p1.props.navigateBackInRN()

			return
		end

		if p1.props.canGoBackInAppRoute then
			p1.props.navigateBackInAppRoute()

			return
		end

		p1.androidBackButtonConnection.showExitDialog()
	end
end
function v5.didMount(p2) -- line: 31
	p2.androidBackButtonConnection.connect(p2.onBackButtonPressed)
end
function v5.didUpdate(p3, p4) -- line: 35
	if not p4.isVisible and p3.props.isVisible then
		p3.androidBackButtonConnection.connect(p3.onBackButtonPressed)

		return
	end

	if p4.isVisible and not p3.props.isVisible then
		p3.androidBackButtonConnection.disconnect()
	end
end
function v5.willUnmount(p5) -- line: 43
	p5.androidBackButtonConnection.disconnect()
end
function v5.render(_) -- line: 47
	return nil
end

return v5
