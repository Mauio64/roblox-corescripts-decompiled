local parent = script:FindFirstAncestor("VrCommon").Parent

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local SafetyBubble = {}
SafetyBubble.__index = SafetyBubble

local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create
local FIntSafetyBubbleRadius = require(script.Parent.FIntSafetyBubbleRadius)
local FIntSafetyBubbleTransparencyPercent = require(script.Parent.FIntSafetyBubbleTransparencyPercent)
local v = FIntSafetyBubbleTransparencyPercent * 0.01

function SafetyBubble.new()
	local object = setmetatable({}, SafetyBubble)

	object.subjects = {}

	object.mode = UserGameSettings.VRSafetyBubbleMode
	object.enabled = object.mode ~= Enum.VRSafetyBubbleMode.Anyone
	object.updateCadence = 0.2

	object.Toggled = Create("BindableEvent")({ Name = "SafetyBubbleToggled" })

	UserGameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function()
		object.mode = UserGameSettings.VRSafetyBubbleMode
		local enabled = object.mode ~= Enum.VRSafetyBubbleMode.Anyone

		if object.enabled ~= enabled then
			object.enabled = enabled
			object.Toggled:Fire()

			RbxAnalyticsService:ReportCounter("VR-SafetyBubble-" .. (enabled and "On" or "Off"))
		end
	end)

	return object
end

function SafetyBubble.ToggleEnabled(p)
	UserGameSettings.VRSafetyBubbleMode = p.enabled and Enum.VRSafetyBubbleMode.Anyone or Enum.VRSafetyBubbleMode.NoOne
end

function SafetyBubble:HasToolAncestor(p)
	return p ~= nil and p.Parent ~= nil and (p.Parent:IsA("Tool") or self:HasToolAncestor(p.Parent))
end

function SafetyBubble:IsValidPartToModify(instance): boolean
	if instance:IsA("BasePart") or instance:IsA("Decal") then
		return not self:HasToolAncestor(instance)
	end

	return false
end

function SafetyBubble:CachePartsRecursive(instance, p)
	if instance then
		if self:IsValidPartToModify(instance) then
			self.subjects[p].cachedParts[instance] = true
			self.subjects[p].transparencyDirty = true
		end

		for _, child in pairs(instance:GetChildren()) do
			self:CachePartsRecursive(child, p)
		end
	end
end

function SafetyBubble:TeardownTransparency(p)
	for k, _ in pairs(self.subjects[p].cachedParts) do
		k.LocalTransparencyModifier = 0
	end

	self.subjects[p].cachedParts = {}
	self.subjects[p].transparencyDirty = true
	self.subjects[p].lastTransparency = nil

	if self.subjects[p].descendantAddedConn then
		self.subjects[p].descendantAddedConn:disconnect()
		self.subjects[p].descendantAddedConn = nil
	end

	if self.subjects[p].descendantRemovingConn then
		self.subjects[p].descendantRemovingConn:disconnect()
		self.subjects[p].descendantRemovingConn = nil
	end

	for k, toolDescendantAddedConn in pairs(self.subjects[p].toolDescendantAddedConns) do
		toolDescendantAddedConn:Disconnect()
		self.subjects[p].toolDescendantAddedConns[k] = nil
	end

	for k, toolDescendantRemovingConn in pairs(self.subjects[p].toolDescendantRemovingConns) do
		toolDescendantRemovingConn:Disconnect()
		self.subjects[p].toolDescendantRemovingConns[k] = nil
	end
end

function SafetyBubble:GetSubjectIndex(p)
	local v2 = #self.subjects
	local v3 = 1

	while v3 <= v2 do
		if self.subjects[v3].character == p then
			return v3
		end

		v3 += 1
	end

	return 0
end

function SafetyBubble:SubjectExists(p): boolean
	return self:GetSubjectIndex(p) > 0
end

function SafetyBubble:SetupTransparency(instance)
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

	self.descendantRemovingConn = instance.DescendantRemoving:connect(function(p)
		subjectIndex = self:GetSubjectIndex(instance)

		if subjectIndex == 0 then
			return
		end

		if self.subjects[subjectIndex] and self.subjects[subjectIndex].cachedParts[p] then
			self.subjects[subjectIndex].cachedParts[p] = nil

			p.LocalTransparencyModifier = 0
		end
	end)

	self:CachePartsRecursive(instance, subjectIndex)
end

function SafetyBubble:AddSubject(character)
	local v2 = #self.subjects
	local v3 = 1

	while v3 <= v2 do
		if self.subjects[v3].character == character then
			return
		end

		v3 += 1
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

	self.subjects[v3].character = character
	self:SetupTransparency(character)
end

function SafetyBubble:update(p)
	local currentCamera = workspace.CurrentCamera

	if not currentCamera then
		return
	end

	if self.enabled then
		local v2 = math.max(FIntSafetyBubbleRadius * currentCamera.HeadScale, 0.1)

		local character = nil
		local v3 = v2 + 3
		local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
		local v4 = currentCamera.CFrame * userCFrame

		self.updateCadence -= p

		if self.updateCadence <= 0 then
			self.updateCadence = 0.2

			for _, v5 in pairs(Players:GetPlayers()) do
				if not (v5.Character and v5 ~= Players.LocalPlayer) then
					continue
				end

				if
					self.mode == Enum.VRSafetyBubbleMode.OnlyFriends
					and Players.LocalPlayer:IsFriendsWithAsync(v5.UserId)
				then
					local subjectIndex = self:GetSubjectIndex(v5.Character)

					if subjectIndex > 0 then
						self:TeardownTransparency(subjectIndex)
						table.remove(self.subjects, subjectIndex)
					end
				elseif not self:SubjectExists(v5.Character) and v5.Character then
					local boundingBox, v6 = v5.Character:GetBoundingBox()
					local v7 = (boundingBox.Position - v4.Position).Magnitude - v6.Z

					if v7 < v3 then
						character = v5.Character
						v3 = v7
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
			local boundingBox, v5 = self.subjects[count].character:GetBoundingBox()
			local v6 = (boundingBox.Position - v4.Position).Magnitude - v5.Z

			if v2 * 2 < v6 then
				self:TeardownTransparency(count)
				table.remove(self.subjects, count)
			end

			count -= 1
		end

		local count2 = #self.subjects
		local v5 = 1

		while v5 <= count2 do
			local v6 = 0

			local character2 = self.subjects[v5].character
			local v7

			if character2.PrimaryPart then
				v7 = (Vector3.new(
					character2:GetPrimaryPartCFrame().p.x,
					v4.Position.Y,
					character2:GetPrimaryPartCFrame().p.z
				) - v4.Position).Magnitude
			else
				local boundingBox, v8 = character2:GetBoundingBox()
				v7 = (boundingBox.Position - v4.Position).Magnitude - v8.Z
			end

			if v7 < v2 then
				if count2 > 3 then
					v6 = 1
				else
					local v8 = v2 * 0.75

					if v7 < v8 then
						v6 = v
					else
						v6 = (1 - (v7 - v8) / (v2 - v8)) * v
					end
				end
			end

			if not self.subjects[v5].lastTransparency then
				self.subjects[v5].transparencyDirty = true
			end

			local v8 = math.clamp(v6, 0, 1)

			if self.subjects[v5].transparencyDirty or self.subjects[v5].lastTransparency ~= v8 then
				for k, _ in pairs(self.subjects[v5].cachedParts) do
					k.LocalTransparencyModifier = v8
				end

				self.subjects[v5].transparencyDirty = false
				self.subjects[v5].lastTransparency = v8
			end

			local tool = character2:FindFirstChildOfClass("Tool")

			if tool then
				for _, part in pairs(tool:GetChildren()) do
					if part:IsA("BasePart") then
						part.LocalTransparencyModifier = v8
					end
				end
			end

			v5 += 1
		end
	elseif self.subjects and #self.subjects > 0 then
		for i = 1, #self.subjects do
			self:TeardownTransparency(i)
		end

		self.subjects = {}
	end
end

return SafetyBubble
