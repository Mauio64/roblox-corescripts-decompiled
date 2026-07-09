local CrossPlay = script:FindFirstAncestor("CrossPlay")
local createGetUserSettingsPlatform = require(CrossPlay.Networking.networkRequests.createGetUserSettingsPlatform)
local createUpdateUserSettingsPlatform = require(CrossPlay.Networking.networkRequests.createUpdateUserSettingsPlatform)

return function(p1) -- line: 12
	-- upvalues: createGetUserSettingsPlatform (copy), createUpdateUserSettingsPlatform (copy)
	return {
		GetUserSettingsPlatform = createGetUserSettingsPlatform(p1),
		UpdateUserSettingsPlatform = createUpdateUserSettingsPlatform(p1)
	}
end
