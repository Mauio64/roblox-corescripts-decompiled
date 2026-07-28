local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local useSelector = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useSelector
local RoduxPresence = require(SocialTabsPage.Rodux.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local FFlagSocialTabsPagePresenceSignalsMigration = require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration)
local React = require(SocialTabsPageParent.React)
local Signals = require(SocialTabsPageParent.Signals)
local SignalsReact = require(SocialTabsPageParent.SignalsReact)
local DataHydration = require(SocialTabsPageParent.DataHydration)
local v11 = if not FFlagSocialTabsPagePresenceSignalsMigration then nil else DataHydration.Presence.PresenceStore.get()
local v12 = if not FFlagSocialTabsPagePresenceSignalsMigration then nil else DataHydration.Presence.PresenceEnums.PresenceType
local t1 = {
	[PresenceType.InGame] = 3,
	[PresenceType.Online] = 2,
	[PresenceType.InStudio] = 1,
	[PresenceType.Offline] = 0
}

local function getPresenceWeight(n1: number?) -- line: 36
	-- upvalues: t1 (copy)
	return t1[n1] or 0
end

local v15 = if not FFlagSocialTabsPagePresenceSignalsMigration then nil else {
	[v12.InGame] = 3,
	[v12.Online] = 2,
	[v12.InStudio] = 1,
	[v12.Offline] = 0
}

local function getStorePresenceWeight(s1: string) -- line: 49
	-- upvalues: v15 (copy)
	return v15[s1] or 0
end
local function usersOrderEqual(t2: {[any]: any}?, t3: {[any]: any}?) -- line: 55
	if t2 == t3 then
		return true
	end

	if not t2 or not t3 or #t2 ~= #t3 then
		return false
	end

	for v23, v24 in t2 do
		if v24.id ~= t3[v23].id then
			return false
		end
	end

	return true
end
local function useSortedUsersByPresence(t4: {[any]: any}) -- line: 81
	-- upvalues: FFlagSocialTabsPagePresenceSignalsMigration (copy), React (copy), Signals (copy), v11 (copy), v12 (copy), v15 (copy), usersOrderEqual (copy), SignalsReact (copy), useSelector (copy), RoduxPresence (copy), PresenceType (copy), t1 (copy)
	if FFlagSocialTabsPagePresenceSignalsMigration then
		local v26 = React.useMemo(function() -- line: 83
			-- upvalues: Signals (copy), t4 (copy), v11 (copy), v12 (copy), v15 (copy), usersOrderEqual (copy)
			return Signals.createComputed(function(p1) -- line: 84
				-- upvalues: t4 (copy), v11 (copy), v12 (copy), v15 (copy)
				if #t4 == 0 then
					return t4
				end

				local t5 = {}

				for v38, v39 in t4 do
					local v40 = v11.GetPresenceByUserId((tostring(v39.id))).data(p1)
					local v41 = if not v40 then v12.Offline else v40.userPresenceType

					table.insert(t5, {
						user = v39,
						weight = v15[v41] or 0,
						originalIndex = v38
					})
				end

				table.sort(t5, function(p2, p3) -- line: 103
					if p2.weight ~= p3.weight then
						return p2.weight > p3.weight
					end

					return p2.originalIndex < p3.originalIndex
				end)

				local t6 = {}

				for _, v44 in t5 do
					table.insert(t6, v44.user)
				end

				return t6
			end, usersOrderEqual)
		end, { t4 })

		return SignalsReact.useSignalState(v26)
	end

	return useSelector(function(p4) -- line: 120
		-- upvalues: t4 (copy), RoduxPresence (copy), PresenceType (copy), t1 (copy)
		if #t4 == 0 then
			return t4
		end

		local t7 = {}

		for v29, v30 in t4 do
			local v31 = RoduxPresence.Selectors.getUserPresenceByUserId(p4, v30.id)
			local v32 = if not v31 then PresenceType.Offline else v31.userPresenceType

			table.insert(t7, {
				user = v30,
				weight = t1[v32] or 0,
				originalIndex = v29
			})
		end

		table.sort(t7, function(p5, p6) -- line: 136
			if p5.weight ~= p6.weight then
				return p5.weight > p6.weight
			end

			return p5.originalIndex < p6.originalIndex
		end)

		local t8 = {}

		for _, v35 in t7 do
			table.insert(t8, v35.user)
		end

		return t8
	end, usersOrderEqual)
end

return useSortedUsersByPresence
