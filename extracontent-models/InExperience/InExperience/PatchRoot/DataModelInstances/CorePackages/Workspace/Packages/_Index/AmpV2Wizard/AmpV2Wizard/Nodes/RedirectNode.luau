local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
require(AmpV2Wizard.Types)
local WizardSpinner = require(AmpV2Wizard.WizardSpinner)
local withAnalyticsSessionId = require(AmpV2Wizard.withAnalyticsSessionId)

local function RedirectNode(props)
	local report = props.report
	local props2 = props.props
	local analyticsSessionId = props.ctx.analyticsSessionId
	local v = useNavigation()

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
			v.push(AppPage.GenericWebPage, {
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
