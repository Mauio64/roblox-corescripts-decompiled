local t1 = {}
local Players = game:GetService("Players")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")

RobloxGui:WaitForChild("Modules")

local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local _ = UserSettings().GameSettings
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local FFlagInExperienceUserProfileSettingsEnabled = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceUserProfileSettingsEnabled)
local FFlagBadgeVisibilitySettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagBadgeVisibilitySettingEnabled
local FFlagInExperienceRequestProfileSettings = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceRequestProfileSettings)
local VerifiedBadgeDisplayStore = require(CorePackages.Workspace.Packages.UserProfiles).Stores.VerifiedBadgeDisplayStore
local FFlagEnableVerifiedBadgeStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableVerifiedBadgeStore
local t2 = {}

t2.__index = t2

function t2.new(p1) -- line: 27
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.player = p1
	self.pendingGroupData = {}
	self.pendingCanManage = {}
	self.pendingProfileSettings = {}
	self.groupData = nil
	self.canManage = nil
	self.profileSettings = nil

	return self
end
function t2.getGroupDataAsync(p2) -- line: 39
	if p2.groupData then
		return p2.groupData
	end

	local thread = coroutine.running()

	table.insert(p2.pendingGroupData, thread)
	coroutine.yield()

	return p2.groupData
end
function t2.getCanManageAsync(p3) -- line: 50
	if p3.canManage ~= nil then
		return p3.canManage
	end

	local thread = coroutine.running()

	table.insert(p3.pendingCanManage, thread)
	coroutine.yield()

	return p3.canManage
end
function t2.getProfileSettingsAsync(p4) -- line: 61
	if p4.profileSettings ~= nil then
		return p4.profileSettings
	end

	local thread = coroutine.running()

	table.insert(p4.pendingProfileSettings, thread)
	coroutine.yield()

	return p4.profileSettings
end
function t2.setGroupData(p5, p6) -- line: 72
	p5.groupData = p6

	local pendingGroupData = p5.pendingGroupData

	p5.pendingGroupData = {}

	for _, v in pairs(pendingGroupData) do
		coroutine.resume(v)
	end
end
function t2.setCanManage(p7, p8) -- line: 81
	p7.canManage = not not p8

	local pendingCanManage = p7.pendingCanManage

	p7.pendingCanManage = {}

	for _, v in pairs(pendingCanManage) do
		coroutine.resume(v)
	end
end
function t2.setProfileSettings(p9, p10) -- line: 91
	p9.profileSettings = p10

	local pendingProfileSettings = p9.pendingProfileSettings

	p9.pendingProfileSettings = {}

	for _, v in pairs(pendingProfileSettings) do
		coroutine.resume(v)
	end
end
function t2.destroy(p11) -- line: 100
	-- upvalues: FFlagInExperienceUserProfileSettingsEnabled (copy)
	for _, v in pairs(p11.pendingGroupData) do
		coroutine.resume(v)
	end

	for _, v in pairs(p11.pendingCanManage) do
		coroutine.resume(v)
	end

	if FFlagInExperienceUserProfileSettingsEnabled then
		for _, v in pairs(p11.pendingProfileSettings) do
			coroutine.resume(v)
		end
	end
end

local t3 = {}

local function getPlayerInfo(p12) -- line: 118
	-- upvalues: t3 (copy), t2 (copy)
	local v67 = t3[p12]

	if not v67 and p12.Parent ~= nil then
		v67 = t2.new(p12)
		t3[p12] = v67
	end

	return v67
end

spawn(function() -- line: 127
	-- upvalues: Players (copy), t3 (copy), t2 (copy)
	game:GetService("RobloxReplicatedStorage"):WaitForChild("NewPlayerGroupDetails", 1e999).OnClientEvent:Connect(function(...) -- line: 131
		-- upvalues: Players (copy), t3 (copy), t2 (copy)
		local t4 = { ... }

		if #t4 == 1 then
			local v108 = t4[1]

			for k, v in pairs(v108) do
				local PlayerByUserId = Players:GetPlayerByUserId((tonumber(k)))

				if PlayerByUserId then
					local v112 = t3[PlayerByUserId]

					if not v112 and PlayerByUserId.Parent ~= nil then
						v112 = t2.new(PlayerByUserId)
						t3[PlayerByUserId] = v112
					end

					if v112 then
						v112:setGroupData(v)
					end
				end
			end

			return
		end

		local v113 = t4[1]
		local v114 = t4[2]
		local PlayerByUserId = Players:GetPlayerByUserId((tonumber(v113)))

		if PlayerByUserId then
			local v116 = t3[PlayerByUserId]

			if not v116 and PlayerByUserId.Parent ~= nil then
				v116 = t2.new(PlayerByUserId)
				t3[PlayerByUserId] = v116
			end

			if v116 then
				v116:setGroupData(v114)
			end
		end
	end)
end)
coroutine.wrap(function() -- line: 162
	-- upvalues: Players (copy), t3 (copy), t2 (copy)
	game:GetService("RobloxReplicatedStorage"):WaitForChild("NewPlayerCanManageDetails", 1e999).OnClientEvent:Connect(function(p13, p14) -- line: 168
		-- upvalues: Players (copy), t3 (copy), t2 (copy)
		local PlayerByUserId = Players:GetPlayerByUserId((tonumber(p13)))

		if PlayerByUserId then
			local v120 = t3[PlayerByUserId]

			if not v120 and PlayerByUserId.Parent ~= nil then
				v120 = t2.new(PlayerByUserId)
				t3[PlayerByUserId] = v120
			end

			if v120 then
				v120:setCanManage(p14)
			end
		end
	end)
end)()

if FFlagInExperienceUserProfileSettingsEnabled then
	coroutine.wrap(function() -- line: 180
		-- upvalues: Players (copy), t3 (copy), t2 (copy), FFlagEnableVerifiedBadgeStore (copy), VerifiedBadgeDisplayStore (copy), FFlagInExperienceRequestProfileSettings (copy)
		local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

		RobloxReplicatedStorage:WaitForChild("SendPlayerProfileSettings", 1e999).OnClientEvent:Connect(function(p15, p16) -- line: 186
			-- upvalues: Players (copy), t3 (copy), t2 (copy), FFlagEnableVerifiedBadgeStore (copy), VerifiedBadgeDisplayStore (copy)
			local PlayerByUserId = Players:GetPlayerByUserId((tonumber(p15)))

			if PlayerByUserId then
				local v124 = t3[PlayerByUserId]

				if not v124 and PlayerByUserId.Parent ~= nil then
					v124 = t2.new(PlayerByUserId)
					t3[PlayerByUserId] = v124
				end

				if v124 then
					v124:setProfileSettings(p16)
				end

				if FFlagEnableVerifiedBadgeStore and p16.isInExperienceNameEnabled ~= nil then
					VerifiedBadgeDisplayStore.get().setBadgeVisibility(PlayerByUserId.UserId, not p16.isInExperienceNameEnabled)
				end
			end
		end)

		if FFlagInExperienceRequestProfileSettings then
			RobloxReplicatedStorage:WaitForChild("RequestPlayerProfileSettings", 1e999):FireServer()
		end
	end)()
end

Players.PlayerRemoving:Connect(function(player) -- line: 212
	-- upvalues: t3 (copy)
	if t3[player] then
		local v70 = t3[player]

		t3[player] = nil
		v70:destroy()
	end
end)

local function NewInGroupFunctionFactory(p17) -- line: 220
	-- upvalues: t3 (copy), t2 (copy)
	return function(p18) -- line: 221
		-- upvalues: t3 (copy), t2 (copy), p17 (copy)
		local v126 = t3[p18]

		if not v126 and p18.Parent ~= nil then
			v126 = t2.new(p18)
			t3[p18] = v126
		end

		if v126 then
			local v127 = v126:getGroupDataAsync()

			if v127 and v127[p17] then
				return true
			end
		end

		return false
	end
end

local t5 = {}
local s1 = "SpanishLocalizationExpert"

local function v20(p19) -- line: 221
	-- upvalues: t3 (copy), t2 (copy), s1 (copy)
	local v73 = t3[p19]

	if not v73 and p19.Parent ~= nil then
		v73 = t2.new(p19)
		t3[p19] = v73
	end

	if v73 then
		local v74 = v73:getGroupDataAsync()

		if v74 and v74[s1] then
			return true
		end
	end

	return false
end

local s2 = "BrazilianLocalizationExpert"

local function v22(p20) -- line: 221
	-- upvalues: t3 (copy), t2 (copy), s2 (copy)
	local v76 = t3[p20]

	if not v76 and p20.Parent ~= nil then
		v76 = t2.new(p20)
		t3[p20] = v76
	end

	if v76 then
		local v77 = v76:getGroupDataAsync()

		if v77 and v77[s2] then
			return true
		end
	end

	return false
end

local s3 = "FrenchLocalizationExpert"

local function v24(p21) -- line: 221
	-- upvalues: t3 (copy), t2 (copy), s3 (copy)
	local v79 = t3[p21]

	if not v79 and p21.Parent ~= nil then
		v79 = t2.new(p21)
		t3[p21] = v79
	end

	if v79 then
		local v80 = v79:getGroupDataAsync()

		if v80 and v80[s3] then
			return true
		end
	end

	return false
end

local s4 = "GermanLocalizationExpert"

local function v26(p22) -- line: 221
	-- upvalues: t3 (copy), t2 (copy), s4 (copy)
	local v82 = t3[p22]

	if not v82 and p22.Parent ~= nil then
		v82 = t2.new(p22)
		t3[p22] = v82
	end

	if v82 then
		local v83 = v82:getGroupDataAsync()

		if v83 and v83[s4] then
			return true
		end
	end

	return false
end

t5[1] = v20
t5[2] = v22
t5[3] = v24
t5[4] = v26

local function NewIsLocalizationExpertFunctionFactory() -- line: 240
	-- upvalues: t5 (copy)
	return function(p23) -- line: 241
		-- upvalues: t5 (copy)
		for i = 1, #t5 do
			if t5[i](p23) then
				return true
			end
		end

		return false
	end
end
local function IsPlaceOwnerFunctionFactory() -- line: 251
	-- upvalues: t3 (copy), t2 (copy)
	if game.CreatorType == Enum.CreatorType.Group then
		local s5 = "PlaceCreator"

		return function(p24) -- line: 221
			-- upvalues: t3 (copy), t2 (copy), s5 (copy)
			local v131 = t3[p24]

			if not v131 and p24.Parent ~= nil then
				v131 = t2.new(p24)
				t3[p24] = v131
			end

			if v131 then
				local v132 = v131:getGroupDataAsync()

				if v132 and v132[s5] then
					return true
				end
			end

			return false
		end
	end

	return function(p25) -- line: 255
		return p25.UserId == game.CreatorId
	end
end
local function CanPlayerManagePlace(p26) -- line: 260
	-- upvalues: t3 (copy), t2 (copy)
	local v86 = t3[p26]

	if not v86 and p26.Parent ~= nil then
		v86 = t2.new(p26)
		t3[p26] = v86
	end

	if v86 then
		return v86:getCanManageAsync() or false
	end

	return false
end
local function IsPlayerInExperienceNameEnabled(p27) -- line: 269
	-- upvalues: t3 (copy), t2 (copy)
	local v88 = t3[p27]

	if not v88 and p27.Parent ~= nil then
		v88 = t2.new(p27)
		t3[p27] = v88
	end

	if v88 then
		local v89 = v88:getProfileSettingsAsync()

		if v89 then
			return v89.isInExperienceNameEnabled
		end
	end

	return false
end

local s6 = "Admin"

function t1.IsPlayerAdminAsync(p28) -- line: 221
	-- upvalues: t3 (copy), t2 (copy), s6 (copy)
	local v93 = t3[p28]

	if not v93 and p28.Parent ~= nil then
		v93 = t2.new(p28)
		t3[p28] = v93
	end

	if v93 then
		local v94 = v93:getGroupDataAsync()

		if v94 and v94[s6] then
			return true
		end
	end

	return false
end

local s7 = "Intern"

function t1.IsPlayerInternAsync(p29) -- line: 221
	-- upvalues: t3 (copy), t2 (copy), s7 (copy)
	local v96 = t3[p29]

	if not v96 and p29.Parent ~= nil then
		v96 = t2.new(p29)
		t3[p29] = v96
	end

	if v96 then
		local v97 = v96:getGroupDataAsync()

		if v97 and v97[s7] then
			return true
		end
	end

	return false
end

local s8 = "Star"

function t1.IsPlayerStarAsync(p30) -- line: 221
	-- upvalues: t3 (copy), t2 (copy), s8 (copy)
	local v99 = t3[p30]

	if not v99 and p30.Parent ~= nil then
		v99 = t2.new(p30)
		t3[p30] = v99
	end

	if v99 then
		local v100 = v99:getGroupDataAsync()

		if v100 and v100[s8] then
			return true
		end
	end

	return false
end
function t1.IsPlayerLocalizationExpertAsync(p31) -- line: 241
	-- upvalues: t5 (copy)
	for i = 1, #t5 do
		if t5[i](p31) then
			return true
		end
	end

	return false
end

local v35

if game.CreatorType == Enum.CreatorType.Group then
	local s9 = "PlaceCreator"

	function v35(p32) -- line: 221
		-- upvalues: t3 (copy), t2 (copy), s9 (copy)
		local v104 = t3[p32]

		if not v104 and p32.Parent ~= nil then
			v104 = t2.new(p32)
			t3[p32] = v104
		end

		if v104 then
			local v105 = v104:getGroupDataAsync()

			if v105 and v105[s9] then
				return true
			end
		end

		return false
	end
else
	function v35(p33) -- line: 255
		return p33.UserId == game.CreatorId
	end
end

t1.IsPlayerPlaceOwnerAsync = v35
t1.CanPlayerManagePlaceAsync = CanPlayerManagePlace

if FFlagInExperienceUserProfileSettingsEnabled then
	t1.IsPlayerInExperienceNameEnabledAsync = IsPlayerInExperienceNameEnabled
end

if FFlagBadgeVisibilitySettingEnabled then
	function t1.SetPlayerInExperienceNameEnabled(_, p35) -- line: 280
		-- upvalues: Url (copy), HttpService (copy), HttpRbxApiService (copy)
		pcall(function() -- line: 281
			-- upvalues: Url (copy), HttpService (copy), p35 (copy), HttpRbxApiService (copy)
			local UpdatePlayerProfileSettings = game:GetService("RobloxReplicatedStorage"):WaitForChild("UpdatePlayerProfileSettings", 1e999)
			local v135 = Url.APIS_URL .. "user-profile-api/v1/user/profiles/settings"
			local json = HttpService:JSONEncode({
				userProfileSettings = {
					isInExperienceNameEnabled = p35
				}
			})

			HttpRbxApiService:PostAsyncFullUrl(v135, json, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson, Enum.HttpRequestType.Players)
			UpdatePlayerProfileSettings:FireServer({
				isInExperienceNameEnabled = p35
			})
		end)
	end
end

return t1
