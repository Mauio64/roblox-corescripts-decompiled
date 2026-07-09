local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local ContactsContext = require(UserList.Context.ContactsContext)

require(UserList.Common.Types)

local function useContactsData(s1: string) -- line: 16
	-- upvalues: React (copy), ContactsContext (copy)
	local v7 = React.useContext(ContactsContext).contacts[s1]

	return React.useMemo(function() -- line: 20
		-- upvalues: v7 (copy)
		if v7 == nil then
			return nil
		end

		return {
			isLoading = v7.isLoading or false,
			name = v7.name or "",
			avatarThumbnailUrl = v7.avatarThumbnailUrl or ""
		}
	end, {
		s1,
		v7
	})
end

return useContactsData
