local v1 = table.freeze({
	Pending = "Pending",
	InProgress = "InProgress",
	Done = "Done",
	Error = "Error",
	Deleted = "Deleted"
})
local v2 = table.freeze({
	Gameplay = "Gameplay",
	Art = "Art",
	Audio = "Audio",
	Marketing = "Marketing"
})

return {
	SubagentTaskStatus = v1,
	SubagentTaskCategory = v2
}
