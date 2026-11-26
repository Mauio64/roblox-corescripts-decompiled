require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

return {
	LoadStatus = {
		Idle = "Idle",
		Loading = "Loading",
		Success = "Success",
		Failed = "Failed"
	},
	pendingSentinel = function(p2)
		return `pending:{p2}`
	end,
	isPendingSentinel = function(value): boolean
		return string.sub(value, 1, 8) == "pending:"
	end
}
