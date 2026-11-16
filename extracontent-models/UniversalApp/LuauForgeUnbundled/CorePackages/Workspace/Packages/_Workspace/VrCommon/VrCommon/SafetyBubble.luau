local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local class = {}
class.__index = class

local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create
local FIntSafetyBubbleRadius = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/FIntSafetyBubbleRadius")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/FIntSafetyBubbleTransparencyPercent") * 0.01

function class.new()
	local object = setmetatable({}, class)

	object.subjects = {}

	object.mode = UserGameSettings.VRSafetyBubbleMode
	object.enabled = object.mode ~= Enum.VRSafetyBubbleMode.Anyone
	object.updateCadence = 0.2

	object.Toggled = create("BindableEvent")({ Name = "SafetyBubbleToggled" })

	UserGameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function()
		object.mode = UserGameSettings.VRSafetyBubbleMode
		local v6 = object.mode ~= Enum.VRSafetyBubbleMode.Anyone

		if object.enabled ~= v6 then
			object.enabled = v6
			object.Toggled:Fire()

			RbxAnalyticsService:ReportCounter("VR-SafetyBubble-" .. (v6 and "On" or "Off"))
		end
	end)

	return object
end

function class:ToggleEnabled()
	UserGameSettings.VRSafetyBubbleMode = self.enabled and Enum.VRSafetyBubbleMode.Anyone
		or Enum.VRSafetyBubbleMode.NoOne
end

function class:HasToolAncestor(p2)
	if p2 == nil or p2.Parent == nil then
		return false
	end

	return p2.Parent:IsA("Tool") or self:HasToolAncestor(p2.Parent)
end

function class:IsValidPartToModify(instance): boolean
	if instance:IsA("BasePart") or instance:IsA("Decal") then
		return not self:HasToolAncestor(instance)
	end

	return false
end

function class:CachePartsRecursive(instance, p2)
	if instance then
		if self:IsValidPartToModify(instance) then
			self.subjects[p2].cachedParts[instance] = true
			self.subjects[p2].transparencyDirty = true
		end

		for i, child in pairs(instance:GetChildren()) do
			self:CachePartsRecursive(child, p2)
		end
	end
end

function class:TeardownTransparency(p3)
	for k, cachedPart in pairs(self.subjects[p3].cachedParts) do
		k.LocalTransparencyModifier = 0
	end

	self.subjects[p3].cachedParts = {}
	self.subjects[p3].transparencyDirty = true
	self.subjects[p3].lastTransparency = nil

	if self.subjects[p3].descendantAddedConn then
		self.subjects[p3].descendantAddedConn:disconnect()
		self.subjects[p3].descendantAddedConn = nil
	end

	if self.subjects[p3].descendantRemovingConn then
		self.subjects[p3].descendantRemovingConn:disconnect()
		self.subjects[p3].descendantRemovingConn = nil
	end

	for k, toolDescendantAddedConn in pairs(self.subjects[p3].toolDescendantAddedConns) do
		toolDescendantAddedConn:Disconnect()
		self.subjects[p3].toolDescendantAddedConns[k] = nil
	end

	for k, toolDescendantRemovingConn in pairs(self.subjects[p3].toolDescendantRemovingConns) do
		toolDescendantRemovingConn:Disconnect()
		self.subjects[p3].toolDescendantRemovingConns[k] = nil
	end
end

function class:GetSubjectIndex(p3)
	local v6 = #self.subjects
	local v7 = 1

	while v7 <= v6 do
		if self.subjects[v7].character == p3 then
			return v7
		end

		v7 += 1
	end

	return 0
end

function class:SubjectExists(p2): boolean
	return self:GetSubjectIndex(p2) > 0
end

function class:SetupTransparency(instance)
	local subjectIndex = self:GetSubjectIndex(instance)

	if subjectIndex == 0 then
		return
	end

	if self.subjects[subjectIndex].descendantAddedConn then
		self.subjects[subjectIndex].descendantAddedConn:disconnect()
	end

	self.subjects[subjectIndex].descendantAddedConn = instance.DescendantAdded:Connect(function(descendant)
		subjectIndex = self:GetSubjectIndex(instance)

		if subjectIndex == 0 then
			return
		end

		if self:IsValidPartToModify(descendant) then
			self.subjects[subjectIndex].cachedParts[descendant] = true
			self.subjects[subjectIndex].transparencyDirty = true
		end
	end)

	if self.descendantRemovingConn then
		self.descendantRemovingConn:disconnect()
	end

	self.descendantRemovingConn = instance.DescendantRemoving:connect(function(p2)
		subjectIndex = self:GetSubjectIndex(instance)

		if subjectIndex == 0 then
			return
		end

		if self.subjects[subjectIndex] and self.subjects[subjectIndex].cachedParts[p2] then
			self.subjects[subjectIndex].cachedParts[p2] = nil

			p2.LocalTransparencyModifier = 0
		end
	end)

	self:CachePartsRecursive(instance, subjectIndex)
end

function class:AddSubject(character)
	local v6 = #self.subjects
	local v7 = 1

	while v7 <= v6 do
		if self.subjects[v7].character == character then
			return
		end

		v7 += 1
	end

	table.insert(self.subjects, {
		transparencyDirty = false,
		lastTransparency = nil,
		descendantAddedConn = nil,
		descendantRemovingConn = nil,
		toolDescendantAddedConns = {},
		toolDescendantRemovingConns = {},
		cachedParts = {},
		character = nil
	})

	self.subjects[v7].character = character
	self:SetupTransparency(character)
end

function class:update(p2)
	local currentCamera = workspace.CurrentCamera

	if not currentCamera then
		return
	end

	if self.enabled then
		local v6 = math.max(FIntSafetyBubbleRadius * currentCamera.HeadScale, 0.1)

		local character = nil
		local v7 = v6 + 3
		local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
		local v8 = currentCamera.CFrame * userCFrame

		self.updateCadence -= p2

		if self.updateCadence <= 0 then
			self.updateCadence = 0.2

			for k, v9 in pairs(Players:GetPlayers()) do
				if not (v9.Character and v9 ~= Players.LocalPlayer) then
					continue
				end

				if
					self.mode == Enum.VRSafetyBubbleMode.OnlyFriends
					and Players.LocalPlayer:IsFriendsWithAsync(v9.UserId)
				then
					local subjectIndex = self:GetSubjectIndex(v9.Character)

					if subjectIndex > 0 then
						self:TeardownTransparency(subjectIndex)
						table.remove(self.subjects, subjectIndex)
					end
				elseif not self:SubjectExists(v9.Character) and v9.Character then
					local boundingBox, v10 = v9.Character:GetBoundingBox()
					local v11 = (boundingBox.Position - v8.Position).Magnitude - v10.Z

					if v11 < v7 then
						character = v9.Character
						v7 = v11
					end
				end
			end

			if character then
				self:AddSubject(character)
			end
		end

		if not self.subjects or #self.subjects == 0 then
			return
		end

		local count = #self.subjects

		while count > 0 do
			local boundingBox, v9 = self.subjects[count].character:GetBoundingBox()
			local v10 = (boundingBox.Position - v8.Position).Magnitude - v9.Z

			if v6 * 2 < v10 then
				self:TeardownTransparency(count)
				table.remove(self.subjects, count)
			end

			count -= 1
		end

		local count2 = #self.subjects
		local v9 = 1

		while v9 <= count2 do
			local v10 = 0

			local character2 = self.subjects[v9].character
			local v11

			if character2.PrimaryPart then
				v11 = (Vector3.new(
					character2:GetPrimaryPartCFrame().p.x,
					v8.Position.Y,
					character2:GetPrimaryPartCFrame().p.z
				) - v8.Position).Magnitude
			else
				local boundingBox, v12 = character2:GetBoundingBox()
				v11 = (boundingBox.Position - v8.Position).Magnitude - v12.Z
			end

			if v11 < v6 then
				if count2 > 3 then
					v10 = 1
				else
					local v12 = v6 * 0.75
					v10 = if v11 < v12 then v5 else (1 - (v11 - v12) / (v6 - v12)) * v5
				end
			end

			if not self.subjects[v9].lastTransparency then
				self.subjects[v9].transparencyDirty = true
			end

			local v12 = (math.clamp)(v10, 0, 1)

			if self.subjects[v9].transparencyDirty or self.subjects[v9].lastTransparency ~= v12 then
				for k, cachedPart in pairs(self.subjects[v9].cachedParts) do
					k.LocalTransparencyModifier = v12
				end

				self.subjects[v9].transparencyDirty = false
				self.subjects[v9].lastTransparency = v12
			end

			local tool = character2:FindFirstChildOfClass("Tool")

			if tool then
				for i, part in pairs(tool:GetChildren()) do
					if part:IsA("BasePart") then
						part.LocalTransparencyModifier = v12
					end
				end
			end

			v9 += 1
		end
	elseif self.subjects and #self.subjects > 0 then
		for i = 1, #self.subjects do
			self:TeardownTransparency(i)
		end

		self.subjects = {}
	end
end

return class
