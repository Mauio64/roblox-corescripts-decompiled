local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local contactsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ContactsProtocol").ContactsProtocol
local AppStorageService = game:GetService("AppStorageService")

local useSelector = dependencies.useSelector
local useDispatch = dependencies.useDispatch
local useEffectOnce = dependencies.useEffectOnce
local AutoSyncContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Networking/AutoSyncContacts")

return function(p2, p3)
	local v5 = useDispatch()
	local v6 = useSelector(function(p4)
		return p4.LocalUserId
	end)

	useEffectOnce(p3 or function()
		v5(AutoSyncContacts(v6, contactsProtocol.default, AppStorageService))
	end, p2)
end
