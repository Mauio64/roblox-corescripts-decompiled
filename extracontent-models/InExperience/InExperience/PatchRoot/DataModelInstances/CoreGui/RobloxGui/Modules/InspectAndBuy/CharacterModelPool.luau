local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)

local cframe = CFrame.new(Vector3.new(0, 150, 0))

local defineFastInt = game:DefineFastInt("InspectAndBuyClusterCompositionTimeoutMs", 3000)

local CharacterModelPool = {}
CharacterModelPool.__index = CharacterModelPool

local function setupCharacterModels(position)
	local humanoidModelFromDescriptionAsync = Players:CreateHumanoidModelFromDescriptionAsync(
		Instance.new("HumanoidDescription"),
		Enum.HumanoidRigType.R6
	)

	local humanoidModelFromDescriptionAsync2 = Players:CreateHumanoidModelFromDescriptionAsync(
		Instance.new("HumanoidDescription"),
		Enum.HumanoidRigType.R15
	)

	humanoidModelFromDescriptionAsync.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoidModelFromDescriptionAsync2.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoidModelFromDescriptionAsync.HumanoidRootPart.Anchored = true
	humanoidModelFromDescriptionAsync2.HumanoidRootPart.Anchored = true
	humanoidModelFromDescriptionAsync.Parent = RobloxReplicatedStorage
	humanoidModelFromDescriptionAsync2.Parent = RobloxReplicatedStorage

	humanoidModelFromDescriptionAsync.HumanoidRootPart.CFrame = CFrame.new(position)

	humanoidModelFromDescriptionAsync2:SetPrimaryPartCFrame(humanoidModelFromDescriptionAsync.HumanoidRootPart.CFrame)

	return humanoidModelFromDescriptionAsync, humanoidModelFromDescriptionAsync2
end

function CharacterModelPool.new(worldModelRef, p, avatarType, mockApplyDescription)
	local v = {}
	setmetatable(v, CharacterModelPool)

	v.mockApplyDescription = mockApplyDescription

	local r6, r15current = setupCharacterModels(p)

	v.r6 = r6
	v.r15current = r15current
	v.r15offScreen = r15current:Clone()
	v.r15offScreen.Parent = RobloxReplicatedStorage

	v.avatarType = avatarType
	v.worldModelRef = worldModelRef

	v.inProgressPromise = nil

	v.waitingPromise = nil

	v.r6Promise = nil

	v.destroyed = false

	return v
end

function CharacterModelPool.setupAnimations(data, p, instance)
	p.Parent = data.r6
	instance.Parent = data.r15current
	instance.Archivable = true
	local clone = instance:Clone()
	clone.Parent = data.r15offScreen
	clone.Archivable = false
	instance.Archivable = false
end

function CharacterModelPool:getCurrentCharacter()
	if self.avatarType == Enum.HumanoidRigType.R15 then
		return self.r15current
	end

	return self.r6
end

function CharacterModelPool.isR15(p): boolean
	return p.avatarType == Enum.HumanoidRigType.R15
end

function CharacterModelPool:syncRotation(p, p2)
	local _, _, _, v, v2, v3, v4, v5, v6, v7, v8, v9 = p.HumanoidRootPart.CFrame:components()
	local p3 = p2.HumanoidRootPart.CFrame.p
	p2.HumanoidRootPart.CFrame = CFrame.new(p3.X, p3.Y, p3.Z, v, v2, v3, v4, v5, v6, v7, v8, v9)
end

local function hasLayeredAccessoryUpdates(appliedDescription, object): boolean
	local accessories = appliedDescription:GetAccessories(false)
	local accessories2 = object:GetAccessories(false)

	if #accessories2 == 0 then
		return false
	end

	if #accessories ~= #accessories2 then
		return true
	end

	local assetIdSet = {}

	for _, accessory in ipairs(accessories) do
		assetIdSet[accessory.AssetId] = true
	end

	for _, accessory in ipairs(accessories2) do
		if not assetIdSet[accessory.AssetId] then
			return true
		end
	end

	return false
end

local function hasWrapLayer(instance): boolean -- 1 equivalent call inferred from this helper
	return instance:FindFirstChildWhichIsA("WrapLayer", true) ~= nil
end

function CharacterModelPool:_doUpdateR6(p)
	return Promise.new(function(callback, _)
		self.r6.Parent = self.worldModelRef:getValue()

		if self.mockApplyDescription then
			self.mockApplyDescription(self.r6, p)
		else
			self.r6.Humanoid:ApplyDescriptionAsync(p)
		end

		callback(self:getCurrentCharacter())
	end)
end

function CharacterModelPool:_doSimpleUpdateR15(p)
	return Promise.new(function(callback, _)
		self.r15current.Parent = self.worldModelRef:getValue()

		if self.mockApplyDescription then
			self.mockApplyDescription(self.r15current, p)
		else
			self.r15current.Humanoid:ApplyDescriptionAsync(p)
		end

		callback(self.r15current)
	end)
end

function CharacterModelPool:_updateOffscreenR15(p)
	return Promise.new(function(callback, _)
		self.r15offScreen.HumanoidRootPart.CFrame = cframe
		self.r15offScreen.Parent = self.worldModelRef:getValue()

		if self.mockApplyDescription then
			self.mockApplyDescription(self.r15offScreen, p)
		else
			self.r15offScreen.Humanoid:ApplyDescriptionAsync(p)
		end

		callback(self.r15offScreen)
	end)
end

local function waitForClusterCompositionFinished(instance)
	if hasWrapLayer(instance) then -- inferred equivalent call
		return Promise.race({
			Promise.fromEvent(instance.Humanoid.ClusterCompositionFinished),
			Promise.delay(defineFastInt * 0.001)
		}):andThen(function(): boolean
			return true
		end)
	end

	return Promise.resolve(false)
end

function CharacterModelPool:_completeUpdate()
	local cframe2 = self.r15current.HumanoidRootPart.CFrame
	self.r15offScreen.HumanoidRootPart.CFrame = cframe2

	self.r15current.HumanoidRootPart.CFrame = cframe
	self.r15current.Parent = RobloxReplicatedStorage

	local r15current = self.r15current
	local r15offScreen = self.r15offScreen
	self.r15offScreen = r15current
	self.r15current = r15offScreen

	return self.r15current
end

function CharacterModelPool:_doUpdateR15(p)
	if not hasLayeredAccessoryUpdates(self.r15current.Humanoid:GetAppliedDescription(), p) then
		return self:_doSimpleUpdateR15(p)
	end

	self.inProgressPromise = self:_updateOffscreenR15(p):andThen(waitForClusterCompositionFinished):andThen(function()
		return self:_completeUpdate()
	end)

	return self.inProgressPromise
end

function CharacterModelPool:maybeUpdateCharacter(p)
	if self.avatarType == Enum.HumanoidRigType.R6 then
		self.r6Promise = self:_doUpdateR6(p)
		return self.r6Promise
	end

	if not self.inProgressPromise or self.inProgressPromise:getStatus() ~= Promise.Status.Started then
		return self:_doUpdateR15(p)
	end

	local waitingPromise = self.waitingPromise

	self.waitingPromise = self.inProgressPromise:andThen(function()
		return self:_doUpdateR15(p)
	end)

	if waitingPromise then
		waitingPromise:cancel()
	end

	return self.waitingPromise
end

function CharacterModelPool:switchAvatarType(avatarType)
	if avatarType == self.avatarType then
		return self:getCurrentCharacter()
	end

	self:_cancelPromises()

	self.avatarType = avatarType
	local selected, v

	if avatarType == Enum.HumanoidRigType.R6 then
		selected = self.r6
		v = self.r15current
	else
		selected = self.r15current
		v = self.r6
	end

	v.Parent = RobloxReplicatedStorage
	v.Humanoid:UnequipTools()

	self:syncRotation(v, selected)

	return selected
end

function CharacterModelPool.start(_) end

local function cancelPromise(object) -- 3 equivalent calls inferred from this helper
	if object then
		object:cancel()
	end
end

function CharacterModelPool:_cancelPromises()
	cancelPromise(self.inProgressPromise) -- inferred equivalent call
	cancelPromise(self.waitingPromise) -- inferred equivalent call
	cancelPromise(self.r6Promise) -- inferred equivalent call
	self.inProgressPromise = nil
	self.waitingPromise = nil
	self.r6Promise = nil
end

function CharacterModelPool:stop()
	self.r6.Parent = RobloxReplicatedStorage
	self.r15current.Parent = RobloxReplicatedStorage
	self.r15offScreen.Parent = RobloxReplicatedStorage

	self:_cancelPromises()
end

function CharacterModelPool:onDestroy()
	self:_cancelPromises()

	self.r6:Destroy()
	self.r15current:Destroy()
	self.r15offScreen:Destroy()
end

return CharacterModelPool
