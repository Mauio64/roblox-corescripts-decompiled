local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local ContactsContext = require(UserList.Context.ContactsContext)
require(UserList.Common.Types)

local function useContactsData(p: string)
	local contact = React.useContext(ContactsContext).contacts[p]

	return React.useMemo(function()
		if contact == nil then
			return nil
		end

		return {
			isLoading = contact.isLoading or false,
			name = contact.name or "",
			avatarThumbnailUrl = contact.avatarThumbnailUrl or ""
		}
	end, { p, contact })
end

return useContactsData
