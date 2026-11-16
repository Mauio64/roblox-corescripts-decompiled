local getFFlagEnableMergeOmniFeedSorts = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/Flags").GetFFlagEnableMergeOmniFeedSorts
require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/ApolloClient")

local makeMergeOverlappingArraysPolicy = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/makeMergeOverlappingArraysPolicy")
local makeDefaultReadPolicy = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/makeDefaultReadPolicy")

local v6 = {
	topicLayoutData = { read = makeDefaultReadPolicy({}) },
	recommendations = 0,
	experiences = 0,
	hasMoreRows = 0
}

local v7 = { read = makeDefaultReadPolicy({}), merge = 0 }
local v8 = if getFFlagEnableMergeOmniFeedSorts() then makeMergeOverlappingArraysPolicy("contentId") else nil
v7.merge = v8
v6.recommendations = v7

v6.experiences = {}
v6.hasMoreRows = {}
return { fields = v6 }
