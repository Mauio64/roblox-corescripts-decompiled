local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Foundation")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/LinkingProtocol").LinkingProtocol.default
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/React")

local controlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local view = Foundation.View

local defineFastString = game:DefineFastString(
	"GenericReportLink",
	"https://www.roblox.com/illegal-content-reporting"
)
local defineFastFlag = game:DefineFastFlag("ImproveIllegalContentReportingLinkLook", false)

function LUAUFORGE_MODULE_GLOBALS_dav_GenericReportLink()
	local state, setState

	if defineFastFlag then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	local v5 = useLocalization({
		GenericReportLinkText = "Feature.ReportAbuse.Label.GenericReportIllegalContentMessage"
	})
	local v6

	if defineFastFlag then
		v6 = `<b>{v5.GenericReportLinkText}</b> {getIconRichText(iconName.ArrowUpRightFromSquare)}`
	end

	local v7 = React.useCallback(function()
		default:openURL(defineFastString)
	end, {})
	local v8

	if defineFastFlag then
		v8 = React.useCallback(function(p2)
			setState(p2 == controlState.Hover)
		end, {})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	if defineFastFlag then
		if state then
			v6 = `<u>{v6}</u>`
		end
	else
		v6 = `<b>{v5.GenericReportLinkText}</b>`
	end

	if not defineFastFlag then
		v8 = nil
	end

	return createElement(view, { tag = "auto-xy col gap-small" }, { createElement2(text, {
			Text = v6,
			RichText = true,
			onActivated = v7,
			onStateChanged = v8,
			tag = "auto-xy radius-small padding-xsmall text-wrap text-body-small"
		}) })
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_dav_GenericReportLink)
