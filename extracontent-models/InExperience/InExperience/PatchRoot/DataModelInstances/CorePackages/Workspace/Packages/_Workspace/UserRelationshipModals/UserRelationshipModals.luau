local PromptFriendRequestModalContainer = require(script.Components.PromptFriendRequestModalContainer)
local launchUserRelationshipModal = require(script.InExperience.launchUserRelationshipModal)

return {
	["jest.config"] = script["jest.config"],
	launchPromptFriendRequestModal = function(userId: number)
		launchUserRelationshipModal(PromptFriendRequestModalContainer, { userId = userId })
	end
}
