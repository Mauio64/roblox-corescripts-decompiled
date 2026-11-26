local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName
local text = Foundation.Text

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local function Subtitle(p2)
	local translateIntoString = useArTranslation().translateIntoString

	local v5 = React.useMemo(function()
		local v6 = p2.subtitle and p2.subtitle.leading and iconName[p2.subtitle.leading]

		if v6 then
			return getIconRichText(v6)
		end

		return ""
	end, { p2.subtitle })

	if p2.subtitle then
		return React.createElement(text, {
			Text = `{v5} {translateIntoString(p2.subtitle.text)}`,
			RichText = true,
			tag = "auto-xy text-body-medium content-default",
			LayoutOrder = p2.layoutOrder
		})
	end

	return nil
end

return React.memo(Subtitle)
