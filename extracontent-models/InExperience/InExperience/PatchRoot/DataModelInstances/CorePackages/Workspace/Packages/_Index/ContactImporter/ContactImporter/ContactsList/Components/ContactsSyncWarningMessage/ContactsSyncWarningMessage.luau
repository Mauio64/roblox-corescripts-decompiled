local Parent = script:FindFirstAncestor("ContactImporter").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function ContactsSyncWarningMessage(t1: {[any]: any}) -- line: 16
	-- upvalues: useLocalization (copy), React (copy), View (copy), FoundationText (copy)
	local v9 = useLocalization({
		message = "Feature.Contacts.Message.ContactsSyncWarning"
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y margin-y-small",
		LayoutOrder = t1.layoutOrder
	}, {
		text = React.createElement(FoundationText, {
			tag = "auto-y size-full-0 text-align-x-left text-wrap radius-medium bg-action-alert padding-medium stroke-emphasis",
			Text = v9.message
		})
	})
end

return ContactsSyncWarningMessage
