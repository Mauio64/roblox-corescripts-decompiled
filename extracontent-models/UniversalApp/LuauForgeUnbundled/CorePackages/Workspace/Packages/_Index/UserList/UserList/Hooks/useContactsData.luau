local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local ContactsContext = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Context/ContactsContext")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local function useContactsData(p2)
	local contact = React.useContext(ContactsContext).contacts[p2]

	return React.useMemo(function()
		if contact == nil then
			return nil
		end

		return {
			isLoading = contact.isLoading or false,
			name = contact.name or "",
			avatarThumbnailUrl = contact.avatarThumbnailUrl or ""
		}
	end, { p2, contact })
end

return useContactsData
