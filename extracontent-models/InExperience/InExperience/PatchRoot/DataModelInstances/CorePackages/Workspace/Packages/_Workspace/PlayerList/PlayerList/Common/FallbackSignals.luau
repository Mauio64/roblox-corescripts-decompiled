local ParentParent = script.Parent.Parent.Parent

return {
	getHasActiveLeaderboard = require(ParentParent.Signals).createSignal(false)
}
