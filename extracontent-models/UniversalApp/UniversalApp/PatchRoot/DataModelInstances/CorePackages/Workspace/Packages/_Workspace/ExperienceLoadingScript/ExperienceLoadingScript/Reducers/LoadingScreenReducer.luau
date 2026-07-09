local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local Rodux = require(ExperienceLoadingScriptParent.Rodux)
local SetIsSubjectToChinaPolicies = require(ExperienceLoadingScript.Actions.SetIsSubjectToChinaPolicies)
local SetGameProductInfo = require(ExperienceLoadingScript.Actions.SetGameProductInfo)
local SetUniverseId = require(ExperienceLoadingScript.Actions.SetUniverseId)
local v7 = Rodux.createReducer(nil, {
	[SetGameProductInfo.name] = function(_, p2) -- line: 10
		return p2.productInfo
	end
})
local v8 = Rodux.createReducer(nil, {
	[SetUniverseId.name] = function(_, p4) -- line: 16
		return {
			universeId = p4.universeId,
			placeId = p4.placeId
		}
	end
})
local v9 = Rodux.createReducer(nil, {
	[SetIsSubjectToChinaPolicies.name] = function(_, p6) -- line: 25
		return p6.isSubjectToChinaPolicies
	end
})

return Rodux.combineReducers({
	isSubjectToChinaPolicies = v9,
	productInfo = v7,
	gameIds = v8
})
