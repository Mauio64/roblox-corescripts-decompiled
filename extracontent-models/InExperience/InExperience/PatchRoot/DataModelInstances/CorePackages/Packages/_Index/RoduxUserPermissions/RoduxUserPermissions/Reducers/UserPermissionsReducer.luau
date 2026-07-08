local ParentParent = script.Parent.Parent
local Types = ParentParent.Types
local isPhoneVerified = require(ParentParent.Reducers.isPhoneVerified)
local userSettings = require(ParentParent.Reducers.userSettings)
local userSettingsMetadata = require(ParentParent.Reducers.userSettingsMetadata)

require(Types.ReducerTypes)

local t1 = {
	isPhoneVerified = false,
	userSettings = {},
	userSettingsMetadata = {}
}

return function(p1) -- line: 15
	-- upvalues: t1 (copy), isPhoneVerified (copy), userSettings (copy), userSettingsMetadata (copy)
	return function(p2, p3) -- line: 16
		-- upvalues: t1 (copy), isPhoneVerified (copy), p1 (copy), userSettings (copy), userSettingsMetadata (copy)
		local v10 = p2 or t1
		local v11 = isPhoneVerified(p1)
		local v12 = userSettings(p1)
		local v13 = userSettingsMetadata(p1)

		return {
			isPhoneVerified = v11(v10.isPhoneVerified, p3),
			userSettings = v12(v10.userSettings, p3),
			userSettingsMetadata = v13(v10.userSettingsMetadata, p3)
		}
	end
end
