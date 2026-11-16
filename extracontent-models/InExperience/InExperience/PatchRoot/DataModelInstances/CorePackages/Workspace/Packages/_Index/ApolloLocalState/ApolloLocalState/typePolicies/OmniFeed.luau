local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

local Flags = require(script.Parent.Parent.Flags)
local GetFFlagEnableMergeOmniFeedSorts = Flags.GetFFlagEnableMergeOmniFeedSorts

local makeMergeOverlappingArraysPolicy = require(script.Parent.utils.makeMergeOverlappingArraysPolicy)
local merge

if GetFFlagEnableMergeOmniFeedSorts() then
	merge = makeMergeOverlappingArraysPolicy("topicId")
end

return {
	keyFields = { "pageType" },
	fields = {
		sorts = { merge = merge },
		nextPageToken = { read = makeDefaultReadPolicy("") },
		globalLayoutData = { read = makeDefaultReadPolicy({}) }
	}
}
