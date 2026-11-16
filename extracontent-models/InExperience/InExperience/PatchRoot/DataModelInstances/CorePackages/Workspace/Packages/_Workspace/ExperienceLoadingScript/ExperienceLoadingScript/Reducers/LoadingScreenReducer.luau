local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local parent = ExperienceLoadingScript.Parent

local Rodux = require(parent.Rodux)
local SetIsSubjectToChinaPolicies = require(ExperienceLoadingScript.Actions.SetIsSubjectToChinaPolicies)
local SetGameProductInfo = require(ExperienceLoadingScript.Actions.SetGameProductInfo)
local SetUniverseId = require(ExperienceLoadingScript.Actions.SetUniverseId)

local reducer = Rodux.createReducer(nil, {
	[SetGameProductInfo.name] = function(_, p)
		return p.productInfo
	end
})

local reducer2 = Rodux.createReducer(nil, {
	[SetUniverseId.name] = function(_, p)
		return { universeId = p.universeId, placeId = p.placeId }
	end
})

local reducer3 = Rodux.createReducer(nil, {
	[SetIsSubjectToChinaPolicies.name] = function(_, p)
		return p.isSubjectToChinaPolicies
	end
})

return Rodux.combineReducers({
	isSubjectToChinaPolicies = reducer3,
	productInfo = reducer,
	gameIds = reducer2
})
