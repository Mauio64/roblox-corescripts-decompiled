local Chat = game:GetService("Chat")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local SocialUpsellEventReceiver = require(Parent.SocialUpsell).SocialUpsellEventReceiver

local function ExpChatEventReceiver() -- line: 10
	-- upvalues: React (copy), Chat (copy), SocialUpsellEventReceiver (copy)
	local v6 = React.useCallback(function() -- line: 11
		-- upvalues: Chat (copy)
		if game:GetEngineFeature("ChatReconcileAccess") then
			Chat:ReconcileCommunicationAccess()
		end
	end, {})

	return React.createElement(SocialUpsellEventReceiver, {
		onAgeVerifiedChange = v6
	})
end

return ExpChatEventReceiver
