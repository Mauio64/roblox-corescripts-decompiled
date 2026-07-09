local ParentParent = script.Parent.Parent
local NetworkingUserSettings = require(ParentParent.dependencies).NetworkingUserSettings

return function() -- line: 5
	-- upvalues: NetworkingUserSettings (copy)
	return function(p1) -- line: 6
		-- upvalues: NetworkingUserSettings (copy)
		p1:dispatch(NetworkingUserSettings.GetUserSettingsMetadata.API())
	end
end
