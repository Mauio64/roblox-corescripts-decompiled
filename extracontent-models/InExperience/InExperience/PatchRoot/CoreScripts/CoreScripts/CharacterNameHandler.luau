local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

game:GetService("CoreGui")

local UserProfileStore = require(CorePackages.Workspace.Packages.UserProfiles).Stores.UserProfileStore
local FFlagUserProfileStoreQueryRefetch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUserProfileStoreQueryRefetch
local v5 = game:DefineFastFlag("FixCharacterNameHandlerNilProfileCrash", false)
local t1 = {}
local _ = {
	CharacterAdded = "CharacterAdded",
	CharacterRemoving = "CharacterRemoving",
	HumanoidDisplayNameChanged = "HumanoidDisplayNameChanged",
	CharacterHumanoidAdded = "CharacterHumanoidAdded"
}

local function setName(p1, p2, t2: {[any]: any}) -- line: 29
	-- upvalues: t1 (copy)
	local inExperienceCombinedName = t2.names.inExperienceCombinedName
	local displayName = t2.names.displayName

	if t2.names.displayName == p1.DisplayName then
		p1.InternalDisplayName = inExperienceCombinedName
		t1[p2].HumanoidDisplayNameChanged = p1:GetPropertyChangedSignal("DisplayName"):Connect(function() -- line: 36
			-- upvalues: displayName (copy), p1 (copy)
			if displayName ~= p1.DisplayName then
				p1.InternalDisplayName = ""
			end
		end)
	end
end
local function checkHumanoid(p3, p4, t3: {[any]: any}) -- line: 44
	-- upvalues: setName (copy), t1 (copy)
	local Humanoid = p4:FindFirstChildWhichIsA("Humanoid")

	if Humanoid then
		setName(Humanoid, p3, t3)
	end

	t1[p3].CharacterHumanoidAdded = p4.ChildAdded:Connect(function(child) -- line: 49
		-- upvalues: setName (copy), p3 (copy), t3 (copy)
		if child:IsA("Humanoid") then
			setName(child, p3, t3)
		end
	end)
end
local function setNameOnCharacterAdded(p5, t4: {[any]: any}) -- line: 56
	-- upvalues: t1 (copy), checkHumanoid (copy)
	t1[p5] = {}

	if p5.Character then
		checkHumanoid(p5, p5.Character, t4)
	end

	t1[p5].CharacterAdded = p5.CharacterAdded:Connect(function(character) -- line: 62
		-- upvalues: checkHumanoid (copy), p5 (copy), t4 (copy)
		checkHumanoid(p5, character, t4)
	end)
	t1[p5].CharacterRemoving = p5.CharacterRemoving:Connect(function() -- line: 65
		-- upvalues: t1 (copy), p5 (copy)
		local CharacterHumanoidAdded = t1[p5].CharacterHumanoidAdded
		local HumanoidDisplayNameChanged = t1[p5].HumanoidDisplayNameChanged

		if CharacterHumanoidAdded then
			t1[p5].CharacterHumanoidAdded:Disconnect()
		end

		if HumanoidDisplayNameChanged then
			t1[p5].HumanoidDisplayNameChanged:Disconnect()
		end
	end)
end
local function setCurrentPlayersNames() -- line: 77
	-- upvalues: Players (copy), UserProfileStore (copy), v5 (copy), setNameOnCharacterAdded (copy)
	local players = Players:GetPlayers()
	local t5 = {}
	local t6 = {}

	for _, v in pairs(players) do
		table.insert(t5, (tostring(v.UserId)))
		t6[tostring(v.UserId)] = v
	end

	UserProfileStore.get().fetchNamesByUserIds(t5, function(p6) -- line: 85
		-- upvalues: t6 (copy), v5 (copy), setNameOnCharacterAdded (copy)
		local status = p6.status
		local data = p6.data

		if status == "success" then
			for _, v43 in data do
				local v44 = t6[v43.userId]

				if not v5 or v44 and v43.names ~= nil then
					setNameOnCharacterAdded(v44, {
						names = {
							inExperienceCombinedName = v43.names.getInExperienceCombinedName(false),
							displayName = v43.names.getDisplayName(false)
						}
					})
				end
			end
		end
	end)
end
local function onPlayerAdded(p7) -- line: 104
	-- upvalues: UserProfileStore (copy), v5 (copy), setNameOnCharacterAdded (copy)
	UserProfileStore.get().fetchNamesByUserIds({ (tostring(p7.UserId)) }, function(p8) -- line: 105
		-- upvalues: v5 (copy), setNameOnCharacterAdded (copy), p7 (copy)
		local status = p8.status
		local data = p8.data
		local v48 = not v5 or #data > 0 and data[1].names ~= nil

		if status == "success" and v48 then
			local v49 = data[1]

			setNameOnCharacterAdded(p7, {
				names = {
					inExperienceCombinedName = v49.names.getInExperienceCombinedName(false),
					displayName = v49.names.getDisplayName(false)
				}
			})
		end
	end)
end
local function onPlayerRemoving(p9) -- line: 122
	-- upvalues: t1 (copy), FFlagUserProfileStoreQueryRefetch (copy), UserProfileStore (copy)
	local v32 = t1[p9]

	if t1[p9] then
		for _, v in pairs(v32) do
			v:Disconnect()
		end

		t1[p9] = nil
	end

	if FFlagUserProfileStoreQueryRefetch then
		UserProfileStore.get().invalidateCachedNamesForUserIds({ (tostring(p9.UserId)) })
	end
end

setCurrentPlayersNames()
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
