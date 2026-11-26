local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Navigation").useNavigation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local WizardSpinner = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/WizardSpinner")
local withAnalyticsSessionId = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/withAnalyticsSessionId")

local function RedirectNode(props)
	local report = props.report
	local props2 = props.props
	local analyticsSessionId = props.ctx.analyticsSessionId
	local v5 = useNavigation()

	React.useEffect(function()
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
				detail = withAnalyticsSessionId(url, analyticsSessionId),
				extraProps = {
					title = props2.title or "",
					onClose = function()
						report("Done")
					end
				}
			})

			return
		end

		onTerminalRedirect(withAnalyticsSessionId(url, analyticsSessionId), props2.title or "")

		report("Done")
	end, { props2, report })

	return React.createElement(WizardSpinner)
end

return RedirectNode
