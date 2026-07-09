local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local useSelector = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useSelector
local RoduxPresence = require(SocialTabsPage.Rodux.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local t1 = {
	[PresenceType.InGame] = 3,
	[PresenceType.Online] = 2,
	[PresenceType.InStudio] = 1,
	[PresenceType.Offline] = 0
}

local function getPresenceWeight(n1: number?) -- line: 22
	-- upvalues: t1 (copy)
	return t1[n1] or 0
end
local function usersOrderEqual(t2: {[any]: any}?, t3: {[any]: any}?) -- line: 28
	if t2 == t3 then
		return true
	end

	if not t2 or not t3 or #t2 ~= #t3 then
		return false
	end

	for v13, v14 in t2 do
		if v14.id ~= t3[v13].id then
			return false
		end
	end

	return true
end
local function useSortedUsersByPresence(t4: {[any]: any}) -- line: 48
	-- upvalues: useSelector (copy), RoduxPresence (copy), PresenceType (copy), t1 (copy), usersOrderEqual (copy)
	return useSelector(function(p1) -- line: 49
		-- upvalues: t4 (copy), RoduxPresence (copy), PresenceType (copy), t1 (copy)
		if #t4 == 0 then
			return t4
		end

		local t5 = {}

		for v18, v19 in t4 do
			local v20 = RoduxPresence.Selectors.getUserPresenceByUserId(p1, v19.id)
			local v21 = if not v20 then PresenceType.Offline else v20.userPresenceType

			table.insert(t5, {
				user = v19,
				weight = t1[v21] or 0,
				originalIndex = v18
			})
		end

		table.sort(t5, function(p2, p3) -- line: 65
			if p2.weight ~= p3.weight then
				return p2.weight > p3.weight
			end

			return p2.originalIndex < p3.originalIndex
		end)

		local t6 = {}

		for _, v24 in t5 do
			table.insert(t6, v24.user)
		end

		return t6
	end, usersOrderEqual)
end

return useSortedUsersByPresence
