local Parent = script:FindFirstAncestor("ApolloLocalState").Parent
local GetFFlagEnableMergeOmniFeedSorts = require(script.Parent.Parent.Flags).GetFFlagEnableMergeOmniFeedSorts

require(Parent.ApolloClient)

local makeMergeOverlappingArraysPolicy = require(script.Parent.utils.makeMergeOverlappingArraysPolicy)
local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

return {
	fields = {
		topicLayoutData = {
			read = makeDefaultReadPolicy({})
		},
		recommendations = {
			read = makeDefaultReadPolicy({}),
			merge = if not GetFFlagEnableMergeOmniFeedSorts() then nil else makeMergeOverlappingArraysPolicy("contentId")
		},
		experiences = {},
		hasMoreRows = {}
	}
}
