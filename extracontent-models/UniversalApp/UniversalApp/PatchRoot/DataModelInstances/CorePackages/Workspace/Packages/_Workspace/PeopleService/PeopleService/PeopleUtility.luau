local Players = game:GetService("Players")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local UserProfiles = require(scriptParentParent.UserProfiles)
local sortTableByValue = require(scriptParentParent.CoreScriptsRoactCommon).Utilities.sortTableByValue

require(scriptParent.createPersonStore)

local GetFFlagPeoplePageEnablePersonSignalStore = require(scriptParent.Flags).GetFFlagPeoplePageEnablePersonSignalStore
local _, result = pcall(function() -- line: 20
	return game:GetService("PlatformFriendsService")
end)
local UserProfileStore = UserProfiles.Stores.UserProfileStore

local function comparePeople(p1, p2) -- line: 73
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer
	local v25 = p1.Name:lower()
	local v26 = p2.Name:lower()

	if p1 == LocalPlayer then
		v25 = " "
	end

	if p2 == LocalPlayer then
		v26 = " "
	end

	return v25 < v26
end

local v11 = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else function(t1: {[any]: any}) -- line: 96
	-- upvalues: sortTableByValue (copy), Players (copy)
	for v29, v30 in (sortTableByValue(t1, function(p3, p4) -- line: 97
		-- upvalues: Players (copy)
		local v37 = p3.value.getPerson()
		local v38 = p4.value.getPerson()
		local LocalPlayer = Players.LocalPlayer
		local v40 = v37.Name:lower()
		local v41 = v38.Name:lower()

		if v37 == LocalPlayer then
			v40 = " "
		end

		if v38 == LocalPlayer then
			v41 = " "
		end

		return v40 < v41
	end)) do
		local v31 = t1[v30.key]

		if v31 then
			v31.setOrder(v29)
		end
	end
end

return {
	getInExperienceCombinedName = function(t2: {[any]: any}) -- line: 27
		-- upvalues: UserProfileStore (copy)
		local t3 = {}

		for v14, v15 in UserProfileStore.get().fetchNamesByUserIds(t2)(false).data do
			t3[t2[v14]] = v15.names.getInExperienceCombinedName
		end

		return t3
	end,
	getPlatformData = function(t4: {[any]: any}) -- line: 41
		-- upvalues: UserProfileStore (copy)
		local t5 = {}

		for v18, v19 in UserProfileStore.get().fetchNamesByUserIds(t4)(false).data do
			t5[t4[v18]] = {
				platformName = v19.names.getPlatformName,
				platformProfileId = v19.getPlatformProfileId
			}
		end

		return t5
	end,
	canShowPlatformProfile = function(s1: string) -- line: 58
		-- upvalues: result (copy)
		return game:GetEngineFeature("PlatformFriendsService") and (game:GetEngineFeature("PlatformFriendsProfile") and (result and (result:IsProfileEnabled() and (s1 and s1 ~= ""))))
	end,
	showPlatformProfile = function(s2: string) -- line: 67
		-- upvalues: result (copy)
		if game:GetEngineFeature("PlatformFriendsService") and (game:GetEngineFeature("PlatformFriendsProfile") and (result and (result:IsProfileEnabled() and (s2 and s2 ~= "")))) then
			result:ShowProfile(s2)
		end
	end,
	comparePeople = comparePeople,
	sortPeople = function(t6: {[any]: any}) -- line: 90
		-- upvalues: comparePeople (copy)
		table.sort(t6, comparePeople)

		return t6
	end,
	sortPersonStores = if not GetFFlagPeoplePageEnablePersonSignalStore() then nil else v11,
	showPersonButtons = function(p5, n1: number?) -- line: 111
		-- upvalues: Players (copy)
		local LocalPlayer = Players.LocalPlayer

		return p5 ~= nil and (LocalPlayer ~= nil and (p5 ~= LocalPlayer and (n1 > 0 and LocalPlayer.UserId > 0)))
	end
}
