local Parent = script:FindFirstAncestor("VrCommon").Parent
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local t1 = {}

t1.__index = t1

local Create = require(Parent.AppCommonLib).Create
local FIntSafetyBubbleRadius = require(script.Parent.FIntSafetyBubbleRadius)
local v9 = require(script.Parent.FIntSafetyBubbleTransparencyPercent) * 0.01

function t1.new() -- line: 26
	-- upvalues: t1 (copy), UserGameSettings (copy), Create (copy), RbxAnalyticsService (copy)
	local self = setmetatable({}, t1)

	self.subjects = {}
	self.mode = UserGameSettings.VRSafetyBubbleMode
	self.enabled = self.mode ~= Enum.VRSafetyBubbleMode.Anyone
	self.updateCadence = 0.2
	self.Toggled = Create("BindableEvent")({
		Name = "SafetyBubbleToggled"
	})
	UserGameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function() -- line: 39
		-- upvalues: self (copy), UserGameSettings (copy), RbxAnalyticsService (copy)
		self.mode = UserGameSettings.VRSafetyBubbleMode

		local v75 = self.mode ~= Enum.VRSafetyBubbleMode.Anyone

		if v75 ~= self.enabled then
			self.enabled = v75
			self.Toggled:Fire()

			local v76 = not v75 and "Off" or "On"

			RbxAnalyticsService:ReportCounter("VR-SafetyBubble-" .. v76)
		end
	end)

	return self
end
function t1.ToggleEnabled(p1) -- line: 54
	-- upvalues: UserGameSettings (copy)
	UserGameSettings.VRSafetyBubbleMode = p1.enabled and Enum.VRSafetyBubbleMode.Anyone or Enum.VRSafetyBubbleMode.NoOne
end
function t1.HasToolAncestor(p2, p3) -- line: 59
	if p3 == nil or p3.Parent == nil then
		return false
	end

	return p3.Parent:IsA("Tool") or p2:HasToolAncestor(p3.Parent)
end
function t1.IsValidPartToModify(t2: {[any]: any}, p4) -- line: 66
	if p4:IsA("BasePart") or p4:IsA("Decal") then
		return not t2:HasToolAncestor(p4)
	end

	return false
end
function t1.CachePartsRecursive(p5, p6, p7) -- line: 73
	if p6 then
		if p5:IsValidPartToModify(p6) then
			p5.subjects[p7].cachedParts[p6] = true
			p5.subjects[p7].transparencyDirty = true
		end

		for _, child in pairs(p6:GetChildren()) do
			p5:CachePartsRecursive(child, p7)
		end
	end
end
function t1.TeardownTransparency(p8, p9) -- line: 85
	for k, _ in pairs(p8.subjects[p9].cachedParts) do
		k.LocalTransparencyModifier = 0
	end

	p8.subjects[p9].cachedParts = {}
	p8.subjects[p9].transparencyDirty = true
	p8.subjects[p9].lastTransparency = nil

	if p8.subjects[p9].descendantAddedConn then
		p8.subjects[p9].descendantAddedConn:disconnect()
		p8.subjects[p9].descendantAddedConn = nil
	end

	if p8.subjects[p9].descendantRemovingConn then
		p8.subjects[p9].descendantRemovingConn:disconnect()
		p8.subjects[p9].descendantRemovingConn = nil
	end

	for k, v in pairs(p8.subjects[p9].toolDescendantAddedConns) do
		v:Disconnect()
		p8.subjects[p9].toolDescendantAddedConns[k] = nil
	end

	for k, v in pairs(p8.subjects[p9].toolDescendantRemovingConns) do
		v:Disconnect()
		p8.subjects[p9].toolDescendantRemovingConns[k] = nil
	end
end
function t1.GetSubjectIndex(p10, p11) -- line: 111
	local v31 = #p10.subjects
	local n1 = 1

	while n1 <= v31 do
		if p11 == p10.subjects[n1].character then
			return n1
		end

		n1 += 1
	end

	return 0
end
function t1.SubjectExists(p12, p13) -- line: 125
	return p12:GetSubjectIndex(p13) > 0
end
function t1.SetupTransparency(p14, p15) -- line: 131
	local SubjectIndex = p14:GetSubjectIndex(p15)

	if SubjectIndex == 0 then
		return
	end

	if p14.subjects[SubjectIndex].descendantAddedConn then
		p14.subjects[SubjectIndex].descendantAddedConn:disconnect()
	end

	p14.subjects[SubjectIndex].descendantAddedConn = p15.DescendantAdded:Connect(function(descendant) -- line: 140
		-- upvalues: SubjectIndex (ref), p14 (copy), p15 (copy)
		SubjectIndex = p14:GetSubjectIndex(p15)

		if SubjectIndex == 0 then
			return
		end

		if p14:IsValidPartToModify(descendant) then
			p14.subjects[SubjectIndex].cachedParts[descendant] = true
			p14.subjects[SubjectIndex].transparencyDirty = true
		end
	end)

	if p14.descendantRemovingConn then
		p14.descendantRemovingConn:disconnect()
	end

	p14.descendantRemovingConn = p15.DescendantRemoving:connect(function(p16) -- line: 156
		-- upvalues: SubjectIndex (ref), p14 (copy), p15 (copy)
		SubjectIndex = p14:GetSubjectIndex(p15)

		if SubjectIndex == 0 then
			return
		end

		if p14.subjects[SubjectIndex] and p14.subjects[SubjectIndex].cachedParts[p16] then
			p14.subjects[SubjectIndex].cachedParts[p16] = nil
			p16.LocalTransparencyModifier = 0
		end
	end)
	p14:CachePartsRecursive(p15, SubjectIndex)
end
function t1.AddSubject(p17, p18) -- line: 172
	local v40 = #p17.subjects
	local n2 = 1

	while n2 <= v40 do
		if p18 == p17.subjects[n2].character then
			return
		end

		n2 += 1
	end

	local t3 = {
		transparencyDirty = false,
		lastTransparency = nil,
		descendantAddedConn = nil,
		descendantRemovingConn = nil,
		character = nil,
		toolDescendantAddedConns = {},
		toolDescendantRemovingConns = {},
		cachedParts = {}
	}

	table.insert(p17.subjects, t3)
	p17.subjects[n2].character = p18
	p17:SetupTransparency(p18)
end
function t1.update(p19, p20) -- line: 202
	-- upvalues: FIntSafetyBubbleRadius (copy), VRService (copy), Players (copy), v9 (copy)
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	if not p19.enabled then
		if p19.subjects and #p19.subjects > 0 then
			for i = 1, #p19.subjects do
				p19:TeardownTransparency(i)
			end

			p19.subjects = {}
		end

		return
	end

	local v47 = math.max(FIntSafetyBubbleRadius * CurrentCamera.HeadScale, 0.1)
	local Character = nil
	local v49 = v47 + 3
	local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local v51 = CurrentCamera.CFrame * UserCFrame

	p19.updateCadence = p19.updateCadence - p20

	if p19.updateCadence <= 0 then
		p19.updateCadence = 0.2

		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and player ~= Players.LocalPlayer then
				if p19.mode == Enum.VRSafetyBubbleMode.OnlyFriends and if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players.LocalPlayer:IsFriendsWith(player.UserId) else Players.LocalPlayer:IsFriendsWithAsync(player.UserId) then
					local SubjectIndex = p19:GetSubjectIndex(player.Character)

					if SubjectIndex > 0 then
						p19:TeardownTransparency(SubjectIndex)
						table.remove(p19.subjects, SubjectIndex)
					end
				elseif not p19:SubjectExists(player.Character) and player.Character then
					local v55, v56 = player.Character:GetBoundingBox()
					local v57 = (v55.Position - v51.Position).Magnitude - v56.Z

					if v57 < v49 then
						v49 = v57
						Character = player.Character
					end
				end
			end
		end

		if Character then
			p19:AddSubject(Character)
		end
	end

	if not p19.subjects or #p19.subjects == 0 then
		return
	end

	local v58 = #p19.subjects

	while v58 > 0 do
		local v59, v60 = p19.subjects[v58].character:GetBoundingBox()

		if (v59.Position - v51.Position).Magnitude - v60.Z > v47 * 2 then
			p19:TeardownTransparency(v58)
			table.remove(p19.subjects, v58)
		end

		v58 -= 1
	end

	local v61 = #p19.subjects
	local n3 = 1

	while n3 <= v61 do
		local n4 = 0
		local character = p19.subjects[n3].character
		local Magnitude

		if character.PrimaryPart then
			Magnitude = (Vector3.new(character:GetPrimaryPartCFrame().p.x, v51.Position.Y, character:GetPrimaryPartCFrame().p.z) - v51.Position).Magnitude
		else
			local v66, v67 = character:GetBoundingBox()

			Magnitude = (v66.Position - v51.Position).Magnitude - v67.Z
		end

		if Magnitude < v47 then
			if v61 > 3 then
				n4 = 1
			else
				local v68 = v47 * 0.75

				n4 = if not (Magnitude < v68) then (1 - (Magnitude - v68) / (v47 - v68)) * v9 else v9
			end
		end

		if not p19.subjects[n3].lastTransparency then
			p19.subjects[n3].transparencyDirty = true
		end

		local v69 = math.clamp(n4, 0, 1)

		if p19.subjects[n3].transparencyDirty or v69 ~= p19.subjects[n3].lastTransparency then
			for k, _ in pairs(p19.subjects[n3].cachedParts) do
				k.LocalTransparencyModifier = v69
			end

			p19.subjects[n3].transparencyDirty = false
			p19.subjects[n3].lastTransparency = v69
		end

		local Tool = character:FindFirstChildOfClass("Tool")

		if Tool then
			for _, child in pairs(Tool:GetChildren()) do
				if child:IsA("BasePart") then
					child.LocalTransparencyModifier = v69
				end
			end
		end

		n3 += 1
	end
end

return t1
