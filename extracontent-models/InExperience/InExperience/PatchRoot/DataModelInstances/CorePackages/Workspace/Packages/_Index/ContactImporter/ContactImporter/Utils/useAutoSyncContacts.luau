local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local React = require(ParentParentParent.React)
local ContactsProtocol = require(ParentParentParent.ContactsProtocol).ContactsProtocol
local AppStorageService = game:GetService("AppStorageService")
local useSelector = dependencies.useSelector
local useDispatch = dependencies.useDispatch
local AutoSyncContacts = require(ParentParent.Networking.AutoSyncContacts)

return function(p1) -- line: 20
	-- upvalues: useDispatch (copy), useSelector (copy), AutoSyncContacts (copy), ContactsProtocol (copy), AppStorageService (copy), React (copy)
	local v11 = useDispatch()
	local v12 = useSelector(function(p2) -- line: 22
		return p2.LocalUserId
	end)
	local v13 = p1 or function() -- line: 27
		-- upvalues: v11 (copy), AutoSyncContacts (copy), v12 (copy), ContactsProtocol (copy), AppStorageService (copy)
		v11(AutoSyncContacts(v12, ContactsProtocol.default, AppStorageService))
	end

	React.useEffect(v13, {})
end
