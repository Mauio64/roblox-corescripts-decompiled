local parent = script:FindFirstAncestor("ApolloLocalState").Parent
local Flags = require(script.Parent.Parent.Flags)
local GetFFlagEnableMergeOmniFeedSorts = Flags.GetFFlagEnableMergeOmniFeedSorts
require(parent.ApolloClient)

local makeMergeOverlappingArraysPolicy = require(script.Parent.utils.makeMergeOverlappingArraysPolicy)
local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

local fields = {
	topicLayoutData = { read = makeDefaultReadPolicy({}) },
	recommendations = 0,
	experiences = 0,
	hasMoreRows = 0
}

local recommendations = { read = makeDefaultReadPolicy({}), merge = 0 }
local merge

if GetFFlagEnableMergeOmniFeedSorts() then
	merge = makeMergeOverlappingArraysPolicy("contentId")
end

recommendations.merge = merge
fields.recommendations = recommendations

fields.experiences = {}
fields.hasMoreRows = {}
return { fields = fields }
