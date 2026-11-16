local parent = script:FindFirstAncestor("ContactImporter").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function ContactsSyncWarningMessage(p)
	local v = useLocalization({ message = "Feature.Contacts.Message.ContactsSyncWarning" })

	return React.createElement(View, {
		LayoutOrder = p.layoutOrder,
		tag = "size-full-0 auto-y margin-y-small"
	}, {
		text = React.createElement(Text, {
			tag = "auto-y size-full-0 text-align-x-left text-wrap radius-medium bg-action-alert padding-medium stroke-emphasis",
			Text = v.message
		})
	})
end

return ContactsSyncWarningMessage
