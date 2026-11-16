local parent = script.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Signals = require(parent2.Signals)

local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local createSignalMap = CoreScriptsRoactCommon.Utilities.createSignalMap

local createPersonStore = require(parent.createPersonStore)
local PeopleUtility = require(parent.PeopleUtility)

local Flags = require(parent.Flags)
local GetFFlagPeoplePageEnablePersonSignalStore = Flags.GetFFlagPeoplePageEnablePersonSignalStore

local function createPeopleListStore(p)
	local v = p or game:GetService("Players")

	local players = v:GetPlayers()

	local v2 = GetFFlagPeoplePageEnablePersonSignalStore() and {} or nil
	local v3

	if GetFFlagPeoplePageEnablePersonSignalStore() then
		v3 = createSignalMap()
	else
		v3 = nil
	end

	local v4 = PeopleUtility.sortPeople(players)

	local signal, v5 = Signals.createSignal(v4)
	local signal2, v6 = Signals.createSignal({})

	local joined = {}
	local joined2 = {}

	local mapped = Cryo.List.map(v4, function(p2)
		return p2.UserId
	end)

	local function fetchProfiles(items)
		local v7 = {}

		for _, item in items do
			local v8 = tostring(item)

			if not joined[v8] then
				table.insert(v7, v8)
			end
		end

		if #v7 > 0 then
			local v8 = PeopleUtility.getInExperienceCombinedName(v7)

			joined = Cryo.Dictionary.join(joined, v8)

			v6(joined)
		end
	end

	local function fetchPlatformData(items)
		local v7 = {}

		for _, item in items do
			local v8 = tostring(item)

			if not joined2[v8] then
				table.insert(v7, v8)
			end
		end

		if #v7 > 0 then
			local platformData = PeopleUtility.getPlatformData(v7)

			joined2 = Cryo.Dictionary.join(joined2, platformData)
		end
	end

	local fn = GetFFlagPeoplePageEnablePersonSignalStore() and function(p2)
		if v2[p2.UserId] then
			return
		end

		local personStore = createPersonStore(p2)
		v2[p2.UserId] = personStore

		v3.setData(p2.UserId, { getPerson = personStore.getPerson, getOrder = personStore.getOrder }, false)

		PeopleUtility.sortPersonStores(v2)
	end or nil

	local function addPerson(p2)
		if GetFFlagPeoplePageEnablePersonSignalStore() then
			fn(p2)
		end

		local v7 = 1

		for k, v8 in v4 do
			if PeopleUtility.comparePeople(p2, v8) then
				v7 = k
				break
			end

			v7 = k + 1
		end

		local joined3

		if #v4 < v7 then
			joined3 = Cryo.List.join(v4, { p2 })
		elseif GetFFlagPeoplePageEnablePersonSignalStore() and v7 == 1 then
			joined3 = Cryo.List.join({ p2 }, v4)
		else
			joined3 = Cryo.List.join(Cryo.List.getRange(v4, 1, v7 - 1), { p2 }, Cryo.List.getRange(v4, v7, #v4))
		end

		v4 = joined3
		v5(v4)

		mapped = Cryo.List.join(mapped, { p2.UserId })

		fetchProfiles({ p2.UserId })
		fetchPlatformData({ p2.UserId })
	end

	local function removePerson(p2)
		if GetFFlagPeoplePageEnablePersonSignalStore() and v2[p2.UserId] then
			v2[p2.UserId] = nil
			v3.removeData(p2.UserId, false)
		end

		local filtered = Cryo.List.filter(v4, function(p3): boolean
			return p3 ~= p2
		end)

		if #filtered == #v4 then
			return
		end

		v4 = filtered
		v5(v4)

		local userId = p2.UserId
		mapped = Cryo.List.filter(mapped, function(p3: number): boolean
			return p3 ~= userId
		end)

		local v7 = tostring(userId)
		joined[v7] = nil
		joined2[v7] = nil
		v6(joined)
	end

	local function getProfile(p2: number)
		local v7 = tostring(p2)

		if not joined[v7] then
			fetchProfiles({ p2 })
		end

		return joined[v7]
	end

	local function getPlatformName(p2: number)
		local v7 = tostring(p2)

		if not joined2[v7] then
			fetchPlatformData({ p2 })
		end

		return joined2[v7].platformName
	end

	local function getPlatformProfileId(p2: number)
		local v7 = tostring(p2)

		if not joined2[v7] then
			fetchPlatformData({ p2 })
		end

		return joined2[v7].platformProfileId
	end

	fetchProfiles(mapped)
	fetchPlatformData(mapped)

	v.PlayerAdded:Connect(addPerson)
	v.PlayerRemoving:Connect(removePerson)

	if GetFFlagPeoplePageEnablePersonSignalStore() then
		for _, v7 in v:GetPlayers() do
			fn(v7)
		end
	end

	local peopleSignalMap

	if GetFFlagPeoplePageEnablePersonSignalStore() then
		peopleSignalMap = v3
	end

	return {
		people = signal,
		peopleSignalMap = peopleSignalMap,
		peopleProfiles = signal2,
		getProfile = getProfile,
		getPlatformName = getPlatformName,
		getPlatformProfileId = getPlatformProfileId
	}
end

if GetFFlagPeoplePageEnablePersonSignalStore() then
	return createPeopleListStore
end

return createPeopleListStore()
