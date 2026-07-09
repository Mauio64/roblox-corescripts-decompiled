local PromptFriendRequestModalContainer = require(script.Components.PromptFriendRequestModalContainer)
local launchUserRelationshipModal = require(script.InExperience.launchUserRelationshipModal)

return {
	["jest.config"] = script["jest.config"],
	launchPromptFriendRequestModal = function(n1: number) -- line: 6
		-- upvalues: launchUserRelationshipModal (copy), PromptFriendRequestModalContainer (copy)
		launchUserRelationshipModal(PromptFriendRequestModalContainer, {
			userId = n1
		})
	end
}
