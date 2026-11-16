local audience = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/UniverseActivationStoreTypes").Audience
local privacyType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/UniverseConfigurationStoreTypes").PrivacyType

local v5 = {
	{ audience = audience.Public, privacyType = privacyType.Public },
	{ audience = audience.Friends, privacyType = privacyType.FriendsOnly }
}

return function(list)
	for k, v6 in v5 do
		if table.find(list, v6.audience) then
			return v6.privacyType
		end
	end

	return privacyType.Private
end
