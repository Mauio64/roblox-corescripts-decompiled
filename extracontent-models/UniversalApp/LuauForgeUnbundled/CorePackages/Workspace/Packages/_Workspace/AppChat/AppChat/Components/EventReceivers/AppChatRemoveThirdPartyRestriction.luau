local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local ThirdPartyChatSettingsLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/ThirdPartyChatSettingsLoaded")

local function AppChatRemoveThirdPartyRestriction(): nil
	local v5 = useDispatch()
	React.useEffect(function()
		if v5 then
			v5(ThirdPartyChatSettingsLoaded(Enum.ChatRestrictionStatus.NotRestricted))
		end
	end, { v5 })
	return nil
end

return AppChatRemoveThirdPartyRestriction
