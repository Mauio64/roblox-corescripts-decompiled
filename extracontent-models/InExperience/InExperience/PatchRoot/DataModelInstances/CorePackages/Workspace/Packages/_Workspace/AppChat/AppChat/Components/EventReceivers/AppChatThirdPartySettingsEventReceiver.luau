local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function AppChatThirdPartySettingsEventReceiver(): nil
	local v = useDispatch()
	local v2 = useProperty(ThirdPartyUserService, "FriendCommunicationRestrictionStatus")
	local v3 = Responsive.usePreferredInput()
	React.useEffect(function()
		if v and v2 then
			local v4 = v2

			if v3 ~= Responsive.Input.Directional and v2 == Enum.ChatRestrictionStatus.Unknown then
				v4 = Enum.ChatRestrictionStatus.NotRestricted
			end

			v(ThirdPartyChatSettingsLoaded(v4))
		end
	end, { v, v2, v3 })
	return nil
end

return AppChatThirdPartySettingsEventReceiver
