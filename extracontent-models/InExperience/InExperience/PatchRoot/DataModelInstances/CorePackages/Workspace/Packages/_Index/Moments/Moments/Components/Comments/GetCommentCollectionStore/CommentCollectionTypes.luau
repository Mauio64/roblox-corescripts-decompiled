local parent = script:FindFirstAncestor("Moments").Parent
require(parent.MomentsTypes)
local CommentCollectionTypes = {}
CommentCollectionTypes.LoadStatus = {
	Idle = "Idle",
	Loading = "Loading",
	Success = "Success",
	Failed = "Failed"
}

function CommentCollectionTypes.pendingSentinel(p: string)
	return `pending:{p}`
end

function CommentCollectionTypes.isPendingSentinel(value: string): boolean
	return string.sub(value, 1, 8) == "pending:"
end

return CommentCollectionTypes
