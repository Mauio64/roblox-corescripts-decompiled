local parent = script.Parent.Parent
local types = parent.Types
local isPhoneVerified = require(parent.Reducers.isPhoneVerified)
local userSettings = require(parent.Reducers.userSettings)
local userSettingsMetadata = require(parent.Reducers.userSettingsMetadata)

require(types.ReducerTypes)

local v = { isPhoneVerified = false, userSettings = {}, userSettingsMetadata = {} }

return function(p)
	return function(p2, p3)
		local v2 = p2 or v
		local phoneVerified = isPhoneVerified(p)
		local v3 = userSettings(p)
		local v4 = userSettingsMetadata(p)

		return {
			isPhoneVerified = phoneVerified(v2.isPhoneVerified, p3),
			userSettings = v3(v2.userSettings, p3),
			userSettingsMetadata = v4(v2.userSettingsMetadata, p3)
		}
	end
end
