local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React")

local contactsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ContactsProtocol").ContactsProtocol
local AppStorageService = game:GetService("AppStorageService")

local useSelector = dependencies.useSelector
local useDispatch = dependencies.useDispatch
local useEffectOnce = dependencies.useEffectOnce
local AutoSyncContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Networking/AutoSyncContacts")

local FFlagGateContactAutoSyncByPolicy = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/FFlagGateContactAutoSyncByPolicy")

return function(p2, p3)
	local v5 = useDispatch()
	local v6 = useSelector(function(p4)
		return p4.LocalUserId
	end)

	local v7 = p3 or function()
		v5(AutoSyncContacts(v6, contactsProtocol.default, AppStorageService))
	end

	if FFlagGateContactAutoSyncByPolicy then
		useEffectOnce(v7, p2)
	else
		React.useEffect(v7, {})
	end
end
