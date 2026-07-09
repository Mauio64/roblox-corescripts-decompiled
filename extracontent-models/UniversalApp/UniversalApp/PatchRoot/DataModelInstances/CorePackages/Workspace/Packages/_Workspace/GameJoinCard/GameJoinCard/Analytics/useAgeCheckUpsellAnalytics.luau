local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(Parent.React)
local dependencyArray = require(Parent.RoactUtils).Hooks.dependencyArray
local GameJoinCardButtonAction = require(script.Parent.AnalyticsConstants).GameJoinCardButtonAction
local useGameJoinCardAnalytics = require(script.Parent.useGameJoinCardAnalytics)

return {
	useAgeCheckCompletionLogger = function(s1: string) -- line: 45
		-- upvalues: React (copy), useGameJoinCardAnalytics (copy)
		local v7 = if s1 == "" then nil else s1

		return React.useCallback(function(p1) -- line: 49
			-- upvalues: useGameJoinCardAnalytics (copy), v7 (copy)
			useGameJoinCardAnalytics.logJoinCardAgeCheckVerificationOutcome({
				universeId = v7,
				outcome = p1
			})
		end, { v7 })
	end,
	useAgeCheckPressLogger = function(t1: {[any]: any}) -- line: 57
		-- upvalues: React (copy), useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), dependencyArray (copy)
		local userId = t1.userId
		local absolutePosition = t1.absolutePosition
		local joinAgeCheckUpsellFlow = t1.joinAgeCheckUpsellFlow
		local v12 = if t1.universeId == "" then nil else t1.universeId

		return React.useCallback(function() -- line: 63
			-- upvalues: useGameJoinCardAnalytics (copy), GameJoinCardButtonAction (copy), userId (copy), v12 (copy), absolutePosition (copy), joinAgeCheckUpsellFlow (copy)
			useGameJoinCardAnalytics.logGameJoinCardButtonEvent(GameJoinCardButtonAction.AgeCheckUnlock, {
				friendId = userId,
				universeId = v12,
				absolutePosition = absolutePosition
			})
			joinAgeCheckUpsellFlow()
		end, dependencyArray(userId, v12, absolutePosition, joinAgeCheckUpsellFlow))
	end
}
