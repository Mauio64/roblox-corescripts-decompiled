local makeDefaultReadPolicy = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/makeDefaultReadPolicy")

local getFFlagEnableMergeOmniFeedSorts = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/Flags").GetFFlagEnableMergeOmniFeedSorts

local makeMergeOverlappingArraysPolicy = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/makeMergeOverlappingArraysPolicy")

local v8 = if getFFlagEnableMergeOmniFeedSorts() then makeMergeOverlappingArraysPolicy("topicId") else nil
return {
	keyFields = { "pageType" },
	fields = {
		sorts = { merge = v8 },
		nextPageToken = { read = makeDefaultReadPolicy("") },
		globalLayoutData = { read = makeDefaultReadPolicy({}) }
	}
}
