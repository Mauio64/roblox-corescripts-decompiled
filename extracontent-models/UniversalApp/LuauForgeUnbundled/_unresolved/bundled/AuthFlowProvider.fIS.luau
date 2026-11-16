local module = require("@luauforge/bundled/fIT")

local module2 = require("@luauforge/bundled/fIR")
require("@luauforge/bundled/fIQ")

local function AuthFlowProvider(props)
	if props.page == module2.LoginV2 then
		local loginV2Container = require("@luauforge/bundled/fIU").Components.LoginV2Container
		return module.createElement(loginV2Container, {
			monoDeps = props.environment,
			isVisible = props.isVisible
		})
	end

	warn(`AuthFlowProvider received unsupported page '{props.page}'`)
	return nil
end

return AuthFlowProvider
