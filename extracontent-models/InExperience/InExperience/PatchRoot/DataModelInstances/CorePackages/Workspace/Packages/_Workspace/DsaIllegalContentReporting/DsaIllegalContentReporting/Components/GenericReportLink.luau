local Parent = script:FindFirstAncestor("DsaIllegalContentReporting").Parent
local Foundation = require(Parent.Foundation)
local default = require(Parent.LinkingProtocol).LinkingProtocol.default
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local ControlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local View = Foundation.View
local v12 = game:DefineFastString("GenericReportLink", "https://www.roblox.com/illegal-content-reporting")
local v13 = game:DefineFastFlag("ImproveIllegalContentReportingLinkLook", false)

function GenericReportLink() -- line: 22
	-- upvalues: v13 (copy), React (copy), useLocalization (copy), getIconRichText (copy), IconName (copy), default (copy), v12 (copy), ControlState (copy), View (copy), FoundationText (copy)
	local v14 = nil
	local u15 = nil

	if v13 then
		local v16

		v14, v16 = React.useState(false)
		u15 = v16
	end

	local v17 = useLocalization({
		GenericReportLinkText = "Feature.ReportAbuse.Label.GenericReportIllegalContentMessage"
	})
	local v18 = nil

	if v13 then
		v18 = `<b>{ v17.GenericReportLinkText }</b> { getIconRichText(IconName.ArrowUpRightFromSquare) }`
	end

	local v19 = React.useCallback(function() -- line: 39
		-- upvalues: default (copy), v12 (copy)
		default:openURL(v12)
	end, {})
	local v20 = nil

	if v13 then
		v20 = React.useCallback(function(p1) -- line: 45
			-- upvalues: u15 (ref), ControlState (copy)
			u15(p1 == ControlState.Hover)
		end, {})
	end

	return React.createElement(View, {
		tag = "auto-xy col gap-small"
	}, { React.createElement(FoundationText, {
		RichText = true,
		tag = "auto-xy radius-small padding-xsmall text-wrap text-body-small",
		Text = if not v13 then `<b>{ v17.GenericReportLinkText }</b>` else if not v14 then v18 else `<u>{ v18 }</u>`,
		onActivated = v19,
		onStateChanged = if not v13 then nil else v20
	}) })
end

return React.memo(GenericReportLink)
