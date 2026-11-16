local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Foundation")
local text = Foundation.Text
local view = Foundation.View

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Localization").Hooks.useLocalization

local function ContactsSyncWarningMessage(p2)
	local v5 = useLocalization({
		message = "Feature.Contacts.Message.ContactsSyncWarning"
	})

	return React.createElement(
		view,
		{ LayoutOrder = p2.layoutOrder, tag = "size-full-0 auto-y margin-y-small" },
		{
			text = React.createElement(text, {
				tag = "auto-y size-full-0 text-align-x-left text-wrap radius-medium bg-action-alert padding-medium stroke-emphasis",
				Text = v5.message
			})
		}
	)
end

return ContactsSyncWarningMessage
