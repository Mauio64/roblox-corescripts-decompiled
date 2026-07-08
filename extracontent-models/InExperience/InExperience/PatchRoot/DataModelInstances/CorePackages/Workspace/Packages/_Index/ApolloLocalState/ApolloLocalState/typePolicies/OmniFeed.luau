local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)
local GetFFlagEnableMergeOmniFeedSorts = require(script.Parent.Parent.Flags).GetFFlagEnableMergeOmniFeedSorts
local makeMergeOverlappingArraysPolicy = require(script.Parent.utils.makeMergeOverlappingArraysPolicy)

return {
	keyFields = { "pageType" },
	fields = {
		sorts = {
			merge = if not GetFFlagEnableMergeOmniFeedSorts() then nil else makeMergeOverlappingArraysPolicy("topicId")
		},
		nextPageToken = {
			read = makeDefaultReadPolicy("")
		},
		globalLayoutData = {
			read = makeDefaultReadPolicy({})
		}
	}
}
