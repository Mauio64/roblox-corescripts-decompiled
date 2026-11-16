local module = require("@luauforge/bundled/gvb")
local useNavigation = require("@luauforge/bundled/gvO").useNavigation
local appPage = require("@luauforge/bundled/gvP").AppPage
require("@luauforge/bundled/gvc")
local LoadingStatePage = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Container/LoadingStatePage")
local module3 = require("@luauforge/bundled/gvQ")

local function RedirectNode(props)
	local report = props.report
	local props2 = props.props
	local analyticsSessionId = props.ctx.analyticsSessionId
	local v5 = useNavigation()

	module.useEffect(function()
		local url = props2.url

		if type(url) ~= "string" or url == "" then
			report("__invalidRedirect__")
			return
		end

		local onTerminalRedirect = props.ctx.onTerminalRedirect

		if
			onTerminalRedirect == nil
			or props.transitions == nil
			or props.transitions.Done == nil
			or props.transitions.Done.kind ~= "Exit"
		then
			v5.push(appPage.GenericWebPage, {
				detail = module3(url, analyticsSessionId),
				extraProps = {
					title = props2.title or "",
					onClose = function()
						report("Done")
					end
				}
			})

			return
		end

		onTerminalRedirect(module3(url, analyticsSessionId), props2.title or "")

		report("Done")
	end, { props2, report })

	return module.createElement(LoadingStatePage)
end

return RedirectNode
