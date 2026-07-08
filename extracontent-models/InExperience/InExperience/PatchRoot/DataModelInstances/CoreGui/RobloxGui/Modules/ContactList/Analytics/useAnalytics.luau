local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ContactList = script:FindFirstAncestor("ContactList")
local ContactListContext = require(ContactList.Context.ContactListContext)

return function() -- line: 10
	-- upvalues: React (copy), ContactListContext (copy)
	return {
		fireEvent = React.useContext(ContactListContext).fireAnalyticsEvent
	}
end
