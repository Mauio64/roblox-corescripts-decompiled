local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local RoactUtils = require(ChallengeDialogParent.RoactUtils)
local screenSizeSelector = require(ChallengeDialog.Common.Utils).screenSizeSelector
local getMiddleContentWidth = require(ChallengeDialog.Common.Utils).getMiddleContentWidth
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function(p1) -- line: 15
	-- upvalues: useSelector (copy), screenSizeSelector (copy), getMiddleContentWidth (copy)
	local v8 = useSelector(screenSizeSelector)
	local v9 = getMiddleContentWidth(v8.X)

	return function() -- line: 18
		-- upvalues: p1 (copy), v9 (copy)
		return p1(v9)
	end
end
