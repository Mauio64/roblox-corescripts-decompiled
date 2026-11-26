local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

local module = require("@luauforge/deferred/gJv")
local module2 = require("@luauforge/bundled/dXh")
local module3 = require("@luauforge/deferred/fvO")

return function(p2)
	local extended = Roact.PureComponent:extend("AppRouterParams")

	function extended.init(p3)
		local navigation = p3.props.navigation

		if module3(module2.getRootNavigation(navigation).state) and p3.props.params then
			navigation.setParams(p3.props.params)
		end
	end

	function extended.render(p3)
		if p3.props.navigation.state.params == nil then
			return nil
		end

		return Roact.createElement(p2, Cryo.Dictionary.join(p3.props, {
			params = Cryo.None
		}))
	end

	return function(p3)
		return Roact.createElement(module.Consumer, {
			render = function(p4)
				if p4.setNavigationForTests then
					p4.setNavigationForTests(p3.navigation)
					p4 = Cryo.Dictionary.join(p4, { setNavigationForTests = Cryo.None })
				end

				local joined = Cryo.Dictionary.join(p3, { params = p4 })

				return Roact.createElement(extended, joined)
			end
		})
	end
end
