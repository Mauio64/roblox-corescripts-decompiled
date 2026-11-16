local parent = script:FindFirstAncestor("GameDetail").Parent
require(parent.Navigation)

local function getFromPropsOrNavigationParams(p, p2: string) -- 3 equivalent calls inferred from this helper
	local v = p.navigation and p.navigation.getParam("extraProps")
	return p[p2] or v and v[p2]
end

local ExperienceDetailsPageUtils = {}
ExperienceDetailsPageUtils.getFromPropsOrNavigationParams = getFromPropsOrNavigationParams

function ExperienceDetailsPageUtils.getUniverseId(p)
	return getFromPropsOrNavigationParams(p, "universeId") or p.navigation and p.navigation.getParam("detail") -- inferred equivalent call
end

function ExperienceDetailsPageUtils.getAnalyticsSource(p)
	return getFromPropsOrNavigationParams(p, "source") or "None" -- inferred equivalent call
end

function ExperienceDetailsPageUtils.getTilePositionIndex(p)
	local v = getFromPropsOrNavigationParams(p, "index") -- inferred equivalent call

	if type(v) == "number" then
		return v
	end

	return type(v) == "string" and tonumber(v) or -1
end

function ExperienceDetailsPageUtils.getResolvedIdentifier(p: string, p2: string)
	return p .. "_" .. p2
end

return ExperienceDetailsPageUtils
