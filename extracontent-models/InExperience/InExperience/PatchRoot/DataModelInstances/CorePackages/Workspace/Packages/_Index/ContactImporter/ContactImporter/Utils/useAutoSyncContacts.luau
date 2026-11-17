local parent = script.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)

local ContactsProtocol = require(parent2.ContactsProtocol)
local contactsProtocol = ContactsProtocol.ContactsProtocol
local AppStorageService = game:GetService("AppStorageService")

local useSelector = dependencies.useSelector
local useDispatch = dependencies.useDispatch
local useEffectOnce = dependencies.useEffectOnce
local AutoSyncContacts = require(parent.Networking.AutoSyncContacts)

return function(flag: boolean?, p)
	local v = useDispatch()
	local v2 = useSelector(function(p2)
		return p2.LocalUserId
	end)

	useEffectOnce(p or function()
		v(AutoSyncContacts(v2, contactsProtocol.default, AppStorageService))
	end, flag)
end
