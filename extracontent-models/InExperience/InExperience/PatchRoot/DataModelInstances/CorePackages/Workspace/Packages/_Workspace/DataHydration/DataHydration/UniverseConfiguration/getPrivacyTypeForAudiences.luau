local DataHydration = script:FindFirstAncestor("DataHydration")

local UniverseActivationStoreTypes = require(DataHydration.UniverseActivation.UniverseActivationStoreTypes)
local Audience = UniverseActivationStoreTypes.Audience
local UniverseConfigurationStoreTypes = require(script.Parent.UniverseConfigurationStoreTypes)

local PrivacyType = UniverseConfigurationStoreTypes.PrivacyType

local v = {
	{ audience = Audience.Public, privacyType = PrivacyType.Public },
	{ audience = Audience.Friends, privacyType = PrivacyType.FriendsOnly }
}

return function(list)
	for _, v2 in v do
		if table.find(list, v2.audience) then
			return v2.privacyType
		end
	end

	return PrivacyType.Private
end
