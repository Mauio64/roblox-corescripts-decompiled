local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local SocialServerDrivenUiParent = SocialServerDrivenUi.Parent
local SduiCoreSystem = require(SocialServerDrivenUiParent.SduiCoreSystem)
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local SduiComponentType = SduiCoreSystem.SduiComponentType
local FFlagSduiRequestFriendshipAction = require(SocialServerDrivenUiParent.SharedFlags).FFlagSduiRequestFriendshipAction

local function registerSocialComponents() -- line: 17
	-- upvalues: SduiComponentType (copy), FFlagSduiRequestFriendshipAction (copy), SocialServerDrivenUi (copy), getSduiComponentRegistry (copy)
	local t1 = {
		[SduiComponentType.FriendRequestButton] = if not FFlagSduiRequestFriendshipAction then nil else {
			getLazyComponent = function() -- line: 21
				-- upvalues: SocialServerDrivenUi (copy)
				return require(SocialServerDrivenUi.Components.SduiFriendRequestButton)
			end
		}
	}

	getSduiComponentRegistry().registerComponentDefinitions(t1)
end

return registerSocialComponents
