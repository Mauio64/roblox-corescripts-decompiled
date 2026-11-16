local parent = script.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local React = require(parent2.React)

local ContactsProtocol = require(parent2.ContactsProtocol)
local contactsProtocol = ContactsProtocol.ContactsProtocol
local AppStorageService = game:GetService("AppStorageService")

local useSelector = dependencies.useSelector
local useDispatch = dependencies.useDispatch
local useEffectOnce = dependencies.useEffectOnce
local AutoSyncContacts = require(parent.Networking.AutoSyncContacts)

local FFlagGateContactAutoSyncByPolicy = require(parent.Flags.FFlagGateContactAutoSyncByPolicy)

return function(flag: boolean?, p)
	local v = useDispatch()
	local v2 = useSelector(function(p2)
		return p2.LocalUserId
	end)

	local v3 = p or function()
		v(AutoSyncContacts(v2, contactsProtocol.default, AppStorageService))
	end

	if FFlagGateContactAutoSyncByPolicy then
		useEffectOnce(v3, flag)
	else
		React.useEffect(v3, {})
	end
end
