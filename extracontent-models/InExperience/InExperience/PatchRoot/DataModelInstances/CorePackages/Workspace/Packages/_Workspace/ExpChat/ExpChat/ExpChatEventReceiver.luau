local Chat = game:GetService("Chat")
local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)
local SocialUpsell = require(parent.SocialUpsell)

local SocialUpsellEventReceiver = SocialUpsell.SocialUpsellEventReceiver

local function ExpChatEventReceiver()
	local onAgeVerifiedChange = React.useCallback(function()
		if game:GetEngineFeature("ChatReconcileAccess") then
			Chat:ReconcileCommunicationAccess()
		end
	end, {})

	return React.createElement(SocialUpsellEventReceiver, {
		onAgeVerifiedChange = onAgeVerifiedChange
	})
end

return ExpChatEventReceiver
