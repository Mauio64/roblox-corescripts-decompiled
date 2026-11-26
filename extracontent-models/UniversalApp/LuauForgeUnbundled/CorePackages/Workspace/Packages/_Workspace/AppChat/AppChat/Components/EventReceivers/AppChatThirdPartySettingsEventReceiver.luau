local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/GuiObjectUtils").useProperty
local ThirdPartyChatSettingsLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/ThirdPartyChatSettingsLoaded")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function AppChatThirdPartySettingsEventReceiver(): nil
	local v5 = useDispatch()
	local v6 = useProperty(ThirdPartyUserService, "FriendCommunicationRestrictionStatus")
	local v7 = Responsive.usePreferredInput()
	React.useEffect(function()
		if v5 and v6 then
			local v8 = v6

			if v7 ~= Responsive.Input.Directional and v6 == Enum.ChatRestrictionStatus.Unknown then
				v8 = Enum.ChatRestrictionStatus.NotRestricted
			end

			v5(ThirdPartyChatSettingsLoaded(v8))
		end
	end, { v5, v6, v7 })
	return nil
end

return AppChatThirdPartySettingsEventReceiver
