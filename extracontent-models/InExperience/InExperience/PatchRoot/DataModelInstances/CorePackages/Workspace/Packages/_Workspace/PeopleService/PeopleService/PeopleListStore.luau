local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Cryo = require(scriptParentParent.Cryo)
local Signals = require(scriptParentParent.Signals)
local createSignalMap = require(scriptParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap
local createPersonStore = require(scriptParent.createPersonStore)
local PeopleUtility = require(scriptParent.PeopleUtility)
local GetFFlagPeoplePageEnablePersonSignalStore = require(scriptParent.Flags).GetFFlagPeoplePageEnablePersonSignalStore

local function createPeopleListStore(p1) -- line: 36
	-- upvalues: GetFFlagPeoplePageEnablePersonSignalStore (copy), createSignalMap (copy), PeopleUtility (copy), Signals (copy), Cryo (copy), createPersonStore (copy)
	local v11 = p1 or game:GetService("Players")
	local players = v11:GetPlayers()
	local v13 = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else {}
	local v14 = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else createSignalMap()
	local u15 = PeopleUtility.sortPeople(players)
	local v16, v17 = Signals.createSignal(u15)
	local v18, v19 = Signals.createSignal({})
	local t1 = {}
	local t2 = {}
	local u22 = Cryo.List.map(u15, function(p2) -- line: 62
		return p2.UserId
	end)

	local function fetchProfiles(t3: {[any]: any}) -- line: 67
		-- upvalues: t1 (ref), PeopleUtility (copy), Cryo (copy), v19 (copy)
		local t4 = {}

		for _, v34 in t3 do
			local str = tostring(v34)

			if not t1[str] then
				table.insert(t4, str)
			end
		end

		if #t4 > 0 then
			local v36 = PeopleUtility.getInExperienceCombinedName(t4)

			t1 = Cryo.Dictionary.join(t1, v36)
			v19(t1)
		end
	end
	local function fetchPlatformData(t5: {[any]: any}) -- line: 90
		-- upvalues: t2 (ref), PeopleUtility (copy), Cryo (copy)
		local t6 = {}

		for _, v40 in t5 do
			local str = tostring(v40)

			if not t2[str] then
				table.insert(t6, str)
			end
		end

		if #t6 > 0 then
			local v42 = PeopleUtility.getPlatformData(t6)

			t2 = Cryo.Dictionary.join(t2, v42)
		end
	end

	local v25 = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else function(p3) -- line: 112
		-- upvalues: v13 (copy), createPersonStore (copy), v14 (copy), PeopleUtility (copy)
		if v13[p3.UserId] then
			return
		end

		local v44 = createPersonStore(p3)

		v13[p3.UserId] = v44
		v14.setData(p3.UserId, {
			getPerson = v44.getPerson,
			getOrder = v44.getOrder
		}, false)
		PeopleUtility.sortPersonStores(v13)
	end

	local function addPerson(p4) -- line: 130
		-- upvalues: GetFFlagPeoplePageEnablePersonSignalStore (copy), v25 (copy), u15 (ref), PeopleUtility (copy), Cryo (copy), v17 (copy), u22 (ref), fetchProfiles (copy), fetchPlatformData (copy)
		if GetFFlagPeoplePageEnablePersonSignalStore() then
			v25(p4)
		end

		local n1 = 1

		for v47, v48 in u15 do
			if PeopleUtility.comparePeople(p4, v48) then
				n1 = v47

				break
			end

			n1 = v47 + 1
		end

		u15 = if not (n1 > #u15) then if not GetFFlagPeoplePageEnablePersonSignalStore() or n1 ~= 1 then Cryo.List.join(Cryo.List.getRange(u15, 1, n1 - 1), { p4 }, Cryo.List.getRange(u15, n1, #u15)) else Cryo.List.join({ p4 }, u15) else Cryo.List.join(u15, { p4 })
		v17(u15)
		u22 = Cryo.List.join(u22, { p4.UserId })
		fetchProfiles({ p4.UserId })
		fetchPlatformData({ p4.UserId })
	end
	local function removePerson(p5) -- line: 171
		-- upvalues: GetFFlagPeoplePageEnablePersonSignalStore (copy), v13 (copy), v14 (copy), Cryo (copy), u15 (ref), v17 (copy), u22 (ref), t1 (ref), t2 (ref), v19 (copy)
		if GetFFlagPeoplePageEnablePersonSignalStore() and v13[p5.UserId] then
			v13[p5.UserId] = nil
			v14.removeData(p5.UserId, false)
		end

		local v50 = Cryo.List.filter(u15, function(p6) -- line: 180
			-- upvalues: p5 (copy)
			return p6 ~= p5
		end)

		if #v50 == #u15 then
			return
		end

		u15 = v50
		v17(u15)

		local UserId = p5.UserId

		u22 = Cryo.List.filter(u22, function(n2: number) -- line: 195
			-- upvalues: UserId (copy)
			return n2 ~= UserId
		end)

		local str = tostring(UserId)

		t1[str] = nil
		t2[str] = nil
		v19(t1)
	end

	fetchProfiles(u22)
	fetchPlatformData(u22)
	v11.PlayerAdded:Connect(addPerson)
	v11.PlayerRemoving:Connect(removePerson)

	if GetFFlagPeoplePageEnablePersonSignalStore() then
		for _, player in v11:GetPlayers() do
			v25(player)
		end
	end

	return {
		people = v16,
		peopleSignalMap = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else v14,
		peopleProfiles = v18,
		getProfile = function(n3: number) -- line: 207
			-- upvalues: t1 (ref), fetchProfiles (copy)
			local str = tostring(n3)

			if not t1[str] then
				fetchProfiles({ n3 })
			end

			return t1[str]
		end,
		getPlatformName = function(n4: number) -- line: 219
			-- upvalues: t2 (ref), fetchPlatformData (copy)
			local str = tostring(n4)

			if not t2[str] then
				fetchPlatformData({ n4 })
			end

			return t2[str].platformName
		end,
		getPlatformProfileId = function(n5: number) -- line: 231
			-- upvalues: t2 (ref), fetchPlatformData (copy)
			local str = tostring(n5)

			if not t2[str] then
				fetchPlatformData({ n5 })
			end

			return t2[str].platformProfileId
		end
	}
end

if GetFFlagPeoplePageEnablePersonSignalStore() then
	return createPeopleListStore
end

return (createPeopleListStore())
