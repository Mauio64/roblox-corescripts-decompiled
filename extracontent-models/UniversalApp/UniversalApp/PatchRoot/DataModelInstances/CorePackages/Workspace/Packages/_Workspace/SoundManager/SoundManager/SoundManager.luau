local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local RobloxGui = CoreGui.RobloxGui
local ParentParent = script.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local v6 = require(ParentParent.Lumberyak).Logger.new(nil, "SoundManager")
local Sounds = require(script.Parent.Sounds)
local SoundEffects = require(script.Parent.SoundEffects)
local SoundGroups = require(script.Parent.SoundGroups)
local t1 = {}

t1.__index = t1

local t2 = {
	Looped = false,
	PlaybackSpeed = 1,
	Volume = 1,
	FadeInTime = nil,
	FadeOutTime = nil,
	SoundEffects = nil
}
local t3 = {}

local function fadeVolume(p1, n1: number, n2: number, s1: string) -- line: 36
	-- upvalues: t3 (copy), RunService (copy)
	if n1 < 0 then
		error(s1 .. " cannot have a negative fadeIn/fadeOut time.")
	end

	local v18 = (n2 - p1.Volume) / n1

	local function onHeartBeat(p2) -- line: 45
		-- upvalues: v18 (copy), p1 (copy), t3 (copy), n2 (copy)
		local v72 = v18 * p2
		local v73 = p1.Volume + v72

		if v73 <= 0 then
			p1.Volume = 0
			p1:Stop()
			t3[p1.SoundId]:Disconnect()

			return
		end

		if v73 >= n2 then
			p1.Volume = n2
			t3[p1.SoundId]:Disconnect()

			return
		end

		p1.Volume = v73
	end

	if t3[p1.SoundId] and t3[p1.SoundId].Connected then
		t3[p1.SoundId]:Disconnect()
	end

	t3[p1.SoundId] = RunService.Heartbeat:Connect(onHeartBeat)
end

function t1._createSoundEffect(_: {[any]: any}, s2: string, s3: string, t5: {[any]: any}, p3) -- line: 76
	-- upvalues: SoundEffects (copy)
	if not SoundEffects[s2] then
		error(s2 .. " does not exist in list of SoundEffects")
	end

	local v25 = Instance.new(s2)

	for k, v in pairs(t5) do
		v25[k] = v
	end

	v25.Parent = p3
	v25.Name = s3
end
function t1.PlaySound(p4, s4: string, p5, p6) -- line: 107
	-- upvalues: RobloxGui (copy), Sounds (copy), Cryo (copy), t2 (copy), fadeVolume (copy)
	local SoundManager_Sounds = RobloxGui:FindFirstChild("SoundManager_Sounds")

	if not SoundManager_Sounds then
		error("SoundManager's Sounds folder is missing. SoundManager has not been initialized.")
	end

	local v33 = Sounds[s4]

	if not v33 then
		error(s4 .. " does not exist in library of Sounds")

		return
	end

	local v34 = Cryo.Dictionary.join(t2, v33.DefaultPlaybackProperties or {}, p5 or {})
	local Name = SoundManager_Sounds:FindFirstChild(v33.Name)

	if not Name then
		Name = Instance.new("Sound")
		Name.Parent = SoundManager_Sounds
		Name.SoundId = v33.SoundId
		Name.Name = v33.Name
	end

	for _, child in pairs(Name:GetChildren()) do
		child:Destroy()
	end

	if p6 then
		Name.SoundGroup = RobloxGui:FindFirstChild("SoundManager_SoundGroups"):FindFirstChild(p6.Name)
	end

	for k, v in pairs(v34) do
		if k ~= "FadeInTime" and k ~= "FadeOutTime" and k ~= "Effects" then
			Name[k] = v
		end
	end

	for _, v in ipairs(v34.SoundEffects or {}) do
		p4:_createSoundEffect(v.Type, v.Name, v.Properties, Name)
	end

	if v34.FadeInTime then
		Name.Volume = 0
		fadeVolume(Name, v34.FadeInTime, v34.Volume, s4)
	end

	Name:Play()
end
function t1.StopSound(_: {[any]: any}, s5: string) -- line: 168
	-- upvalues: RobloxGui (copy), Sounds (copy), fadeVolume (copy)
	local SoundManager_Sounds = RobloxGui:FindFirstChild("SoundManager_Sounds")

	if not SoundManager_Sounds then
		error("SoundManager's Sounds folder is missing. SoundManager has not been initialized.")
	end

	local v45 = Sounds[s5]

	if not v45 then
		error(s5 .. " does not exist in list of Sounds")

		return
	end

	local Name = SoundManager_Sounds:FindFirstChild(v45.Name)

	if not Name then
		error(s5 .. " does not exist")

		return
	end

	local DefaultPlaybackProperties = v45.DefaultPlaybackProperties
	local v48 = if not DefaultPlaybackProperties then nil else DefaultPlaybackProperties.FadeOutTime

	if v48 then
		fadeVolume(Name, v48, 0, s5)

		return
	end

	Name:Stop()
end
function t1.CreateSoundGroup(t7: {[any]: any}, s6: string) -- line: 202
	-- upvalues: SoundGroups (copy), RobloxGui (copy)
	local v51 = SoundGroups[s6]

	if not v51 then
		error("SoundGroup does not exist in list of SoundGroups")

		return
	end

	local SoundManager_SoundGroups = RobloxGui:FindFirstChild("SoundManager_SoundGroups")

	if not SoundManager_SoundGroups then
		error("SoundManager's SoundGroups folder is missing. SoundManager has not been initialized.")

		return
	end

	if SoundManager_SoundGroups:FindFirstChild(s6) then
		warn("SoundGroup already exists")

		return
	end

	local SoundGroup = Instance.new("SoundGroup")

	SoundGroup.Name = v51.Name
	SoundGroup.Parent = SoundManager_SoundGroups
	SoundGroup.Volume = v51.Volume

	for _, v in ipairs(v51.SoundEffects) do
		t7:_createSoundEffect(v.Type, v.Name, v.Properties, SoundGroup)
	end
end
function t1.SoundGroupAddSoundEffect(t8: {[any]: any}, s7: string, p7) -- line: 236
	-- upvalues: SoundGroups (copy), RobloxGui (copy)
	if not SoundGroups[s7] then
		error("SoundGroup does not exist in list of SoundGroups")

		return
	end

	local SoundManager_SoundGroups = RobloxGui:FindFirstChild("SoundManager_SoundGroups")

	if not SoundManager_SoundGroups then
		error("SoundManager's SoundGroups folder is missing. SoundManager has not been initialized.")

		return
	end

	local s7_2 = SoundManager_SoundGroups:FindFirstChild(s7)

	if not s7_2 then
		error("SoundGroup Instance not created")

		return
	end

	if s7_2:FindFirstChild(p7.Name) then
		error("SoundEffect with name " .. p7.Name .. " already exists for sound group " .. s7)

		return
	end

	t8:_createSoundEffect(p7.Type, p7.Name, p7.Properties, s7_2)
end
function t1.SoundGroupRemoveSoundEffect(_: {[any]: any}, s8: string, s9: string) -- line: 269
	-- upvalues: SoundGroups (copy), RobloxGui (copy)
	local v64 = SoundGroups[s8]

	if not v64 then
		error("SoundGroup does not exist in list of SoundGroups")

		return
	end

	local SoundManager_SoundGroups = RobloxGui:FindFirstChild("SoundManager_SoundGroups")

	if not SoundManager_SoundGroups then
		error("SoundManager's SoundGroups folder is missing. SoundManager has not been initialized.")

		return
	end

	local s8_2 = SoundManager_SoundGroups:FindFirstChild(s8)

	if not s8_2 then
		error("SoundGroup Instance not created")

		return
	end

	local s9_2 = s8_2:FindFirstChild(s9)

	if not s9_2 then
		error(s9 .. " not found in " .. v64.Name)
	end

	s9_2:Destroy()
end
function t1.init() -- line: 300
	-- upvalues: t1 (copy), RobloxGui (copy), v6 (copy)
	local self = setmetatable({}, t1)

	if not RobloxGui:FindFirstChild("SoundManager_Sounds") then
		local Folder = Instance.new("Folder")

		Folder.Name = "SoundManager_Sounds"
		Folder.Parent = RobloxGui

		local Folder2 = Instance.new("Folder")

		Folder2.Name = "SoundManager_SoundGroups"
		Folder2.Parent = RobloxGui

		return self
	end

	v6:warning("SoundManager already initialized")

	return self
end

return t1
