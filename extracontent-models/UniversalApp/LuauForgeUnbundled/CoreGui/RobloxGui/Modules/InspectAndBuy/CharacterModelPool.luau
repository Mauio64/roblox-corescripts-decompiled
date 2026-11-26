local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CorePackages = game:GetService("CorePackages")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/dRg")

local module2 = require("@luauforge/bundled/ipN")

local module3 = require("@luauforge/bundled/dPh")
local module4 = require("@luauforge/bundled/dPi")

local isSpatial = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isSpatial

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local getMakeupDescriptionsFromHumanoidDescription = AvatarExperienceCommon.Utils.getMakeupDescriptionsFromHumanoidDescription

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAvatarLoadWithRetry = AvatarExperienceFlags.FFlagAXAvatarLoadWithRetry
local fFlagAXFixR6CharacterPlacement = AvatarExperienceFlags.FFlagAXFixR6CharacterPlacement
local fFlagAXUseSignalsForApplyingLayeredClothing = AvatarExperienceFlags.FFlagAXUseSignalsForApplyingLayeredClothing
local getApplyingLayeredClothingStore

if fFlagAXUseSignalsForApplyingLayeredClothing then
	getApplyingLayeredClothingStore = AvatarExperienceCommon.Stores.getApplyingLayeredClothingStore
else
	getApplyingLayeredClothingStore = nil
end

local cframe

if fFlagAXFixR6CharacterPlacement then
	cframe = CFrame.new(0, 3, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
else
	cframe = CFrame.new(-3.3, 3, 0.2, 0, 0, -1, 0, 1, 0, 1, 0, 0)
end

local cframe2 = CFrame.new(0, 150, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local defineFastFlag = game:DefineFastFlag("FixVRAvatarPlacement", false)

if isVRAppBuild() then
	cframe = CFrame.lookAt(Vector3.new(0, 0, -6), Vector3.new(0, 0, 0))

	if defineFastFlag then
		cframe = CFrame.lookAt(Vector3.new(0, 3, -6), Vector3.new(0, 3, 0))
	end

	cframe2 = CFrame.lookAt(Vector3.new(6, 1, 100), Vector3.new(0, 1, 100))
end

local defineFastInt = game:DefineFastInt("AXClusterCompositionTimeoutMs", 3000)

local class = {}
class.__index = class

local function setupCharacterModels(p2)
	local v5, v6

	if fFlagAXAvatarLoadWithRetry then
		v5 = p2.r6
		v6 = p2.r15
	else
		v5 = Players:CreateHumanoidModelFromDescriptionAsync(
			Instance.new("HumanoidDescription"),
			Enum.HumanoidRigType.R6
		)

		v6 = Players:CreateHumanoidModelFromDescriptionAsync(
			Instance.new("HumanoidDescription"),
			Enum.HumanoidRigType.R15
		)
	end

	v5.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	v6.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	v5.HumanoidRootPart.Anchored = true
	v6.HumanoidRootPart.Anchored = true
	v5.Parent = ReplicatedStorage
	v6.Parent = ReplicatedStorage

	v5.HumanoidRootPart.CFrame = cframe2
	v6:SetPrimaryPartCFrame(cframe2)

	return v5, v6
end

function class.new(store, analytics, characterMover, p2, mockApplyDescription)
	local v5 = {}
	setmetatable(v5, class)

	v5.store = store
	v5.analytics = analytics
	v5.characterMover = characterMover

	v5.mockApplyDescription = mockApplyDescription

	local v6, v7 = setupCharacterModels(p2)

	v5.r6 = v6

	v5.r6IsOffscreen = true
	v5.r15current = v7
	v5.r15offScreen = v7:Clone()
	v5.r15offScreen.Parent = ReplicatedStorage

	v5.avatarType = module.AvatarType.R15

	v5.inProgressPromise = nil

	v5.waitingPromise = nil

	v5.r6Promise = nil

	v5.destroyed = false

	return v5
end

function class:setupAnimations(p2, instance)
	p2.Parent = self.r6
	instance.Parent = self.r15current
	instance.Archivable = true
	local clone = instance:Clone()
	clone.Parent = self.r15offScreen
	clone.Archivable = false
	instance.Archivable = false
end

function class:getCurrentCharacter()
	if self.avatarType == module.AvatarType.R15 then
		return self.r15current
	end

	return self.r6
end

function class:isR15(): boolean
	return self.avatarType == module.AvatarType.R15
end

function class:syncRotation(p3, p4)
	local components, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15 = p3.HumanoidRootPart.CFrame:components()
	local p5 = p4.HumanoidRootPart.CFrame.p
	p4.HumanoidRootPart.CFrame = CFrame.new(p5.X, p5.Y, p5.Z, v7, v8, v9, v10, v11, v12, v13, v14, v15)
end

local function hasLayeredAccessoryUpdates(object, object2): boolean
	local accessories = object:GetAccessories(false)
	local accessories2 = object2:GetAccessories(false)

	if #accessories2 == 0 then
		return false
	end

	if #accessories ~= #accessories2 then
		return true
	end

	local assetIdSet = {}

	for k, accessory in accessories do
		assetIdSet[accessory.AssetId] = true
	end

	for k, accessory in accessories2 do
		if not assetIdSet[accessory.AssetId] then
			return true
		end
	end

	return false
end

local function hasLayeredMakeupUpdates(appliedDescription, p2): boolean
	local makeupDescriptionsFromHumanoidDescription = getMakeupDescriptionsFromHumanoidDescription(appliedDescription)
	local makeupDescriptionsFromHumanoidDescription2 = getMakeupDescriptionsFromHumanoidDescription(p2)

	if #makeupDescriptionsFromHumanoidDescription2 == 0 then
		return false
	end

	if #makeupDescriptionsFromHumanoidDescription ~= #makeupDescriptionsFromHumanoidDescription2 then
		return true
	end

	local assetIdSet = {}

	for k, v5 in makeupDescriptionsFromHumanoidDescription do
		assetIdSet[v5.AssetId] = true
	end

	for k, v5 in makeupDescriptionsFromHumanoidDescription2 do
		if not assetIdSet[v5.AssetId] then
			return true
		end
	end

	return false
end

local function hasWrapLayer(instance): boolean
	return instance:FindFirstChildWhichIsA("WrapLayer", true) ~= nil
end

function class:_doUpdateR6(p2)
	if not (defineFastFlag and isSpatial()) then
		return Promise.new(function(callback, p3)
			if self.mockApplyDescription then
				self.mockApplyDescription(self.r6, p2)
			else
				self.r6.Humanoid:ApplyDescriptionAsync(p2)
			end

			if self.r6IsOffscreen then
				self.r6.HumanoidRootPart.CFrame = cframe
				self.r6IsOffscreen = false
			end

			callback(self:getCurrentCharacter(), self:_stillWaitingOnLCUpdates())
		end)
	end

	if self.r6IsOffscreen then
		self.r6.HumanoidRootPart.CFrame = cframe
		self.r6IsOffscreen = false
	end

	return Promise.new(function(callback, p3)
		if self.mockApplyDescription then
			self.mockApplyDescription(self.r6, p2)
		else
			self.r6.Humanoid:ApplyDescriptionAsync(p2)
		end

		callback(self:getCurrentCharacter(), self:_stillWaitingOnLCUpdates())
	end)
end

function class:_doSimpleUpdateR15(p2)
	return Promise.new(function(callback, p3)
		local lastTime = tick()

		if self.mockApplyDescription then
			self.mockApplyDescription(self.r15current, p2)
		else
			self.r15current.Humanoid:ApplyDescriptionAsync(p2)
		end

		local v5 = (tick() - lastTime) * 1000
		module2(self.analytics, "AXCharacterStandardUpdateTimer", v5)

		callback(self.r15current, self:_stillWaitingOnLCUpdates())
	end)
end

function class:_updateOffscreenR15(p2)
	if fFlagAXUseSignalsForApplyingLayeredClothing then
		getApplyingLayeredClothingStore(false).startedApplyingLayeredClothing()
	else
		self.store:dispatch(module3())
	end

	return Promise.new(function(callback, p3)
		self.r15offScreen.HumanoidRootPart.CFrame = cframe2
		self.r15offScreen.Parent = workspace

		if self.mockApplyDescription then
			self.mockApplyDescription(self.r15offScreen, p2)
		else
			self.r15offScreen.Humanoid:ApplyDescriptionAsync(p2)
		end

		callback(self.r15offScreen)
	end)
end

local function waitForClusterCompositionFinished(instance)
	if instance:FindFirstChildWhichIsA("WrapLayer", true) ~= nil then
		return Promise.race({
			Promise.fromEvent(instance.Humanoid.ClusterCompositionFinished),
			Promise.delay(defineFastInt * 0.001)
		}):andThen(function(): boolean
			return true
		end)
	end

	return Promise.resolve(false)
end

function class:_stillWaitingOnLCUpdates(): boolean
	if self.avatarType == module.AvatarType.R6 then
		return false
	end

	if
		self.avatarType == module.AvatarType.R15
		and self.queuedHumanoidDescription
		and hasLayeredAccessoryUpdates(
			self.r15current.Humanoid.HumanoidDescription,
			self.queuedHumanoidDescription
		)
	then
		return true
	end

	return false
end

function class:_completeUpdate(p2, p3)
	local cframe3 = self.r15current.HumanoidRootPart.CFrame
	self.r15offScreen.HumanoidRootPart.CFrame = cframe3

	self.characterMover:cancelCurrentTween()

	self.r15current.HumanoidRootPart.CFrame = cframe2
	self.r15current.Parent = ReplicatedStorage

	local r15current = self.r15current
	local r15offScreen = self.r15offScreen
	self.r15offScreen = r15current
	self.r15current = r15offScreen

	if fFlagAXUseSignalsForApplyingLayeredClothing then
		getApplyingLayeredClothingStore(false).finishedApplyingLayeredClothing()
	else
		self.store:dispatch(module4())
	end

	local v5 = (tick() - p2) * 1000

	if p3 then
		module2(self.analytics, "AXCharacterLayeredUpdateTimer", v5)
	else
		module2(self.analytics, "AXCharacterStandardUpdateTimer", v5)
	end

	return self.r15current, self:_stillWaitingOnLCUpdates()
end

function class:_doUpdateR15(p2)
	local appliedDescription = self.r15current.Humanoid:GetAppliedDescription()

	if
		hasLayeredAccessoryUpdates(appliedDescription, p2)
		or hasLayeredMakeupUpdates(appliedDescription, p2)
	then
		local now = tick()
		self.inProgressPromise = self:_updateOffscreenR15(p2):andThen(waitForClusterCompositionFinished):andThen(function(p3)
			return self:_completeUpdate(now, p3)
		end)

		return self.inProgressPromise
	end

	return self:_doSimpleUpdateR15(p2)
end

function class:maybeUpdateCharacter(queuedHumanoidDescription)
	if self.avatarType == module.AvatarType.R6 then
		self.r6Promise = self:_doUpdateR6(queuedHumanoidDescription)
		return self.r6Promise
	end

	if not self.inProgressPromise or self.inProgressPromise:getStatus() ~= Promise.Status.Started then
		return self:_doUpdateR15(queuedHumanoidDescription)
	end

	if self.waitingPromise then
		self.waitingPromise:cancel()
	end

	self.queuedHumanoidDescription = queuedHumanoidDescription

	self.waitingPromise = self.inProgressPromise:andThen(function()
		self.inProgressPromise = self.waitingPromise
		self.waitingPromise = nil

		self.queuedHumanoidDescription = nil

		return self:_doUpdateR15(queuedHumanoidDescription)
	end)

	return self.waitingPromise
end

function class:switchAvatarType(avatarType)
	if avatarType == self.avatarType then
		return self:getCurrentCharacter()
	end

	self:_cancelPromises()

	self.avatarType = avatarType
	local v5, v6

	if avatarType == module.AvatarType.R6 then
		v5 = self.r6
		v6 = self.r15current
	else
		v5 = self.r15current
		v6 = self.r6
	end

	v6.Parent = ReplicatedStorage
	v6.Humanoid:UnequipTools()

	self:syncRotation(v6, v5)

	return v5
end

function class.start(p2)
	if isVRAppBuild() then
		p2.r15current.HumanoidRootPart.CFrame = cframe
	end
end

local function cancelPromise(object)
	if object then
		object:cancel()
	end
end

function class:_cancelPromises()
	local inProgressPromise = self.inProgressPromise

	if inProgressPromise then
		inProgressPromise:cancel()
	end

	local waitingPromise = self.waitingPromise

	if waitingPromise then
		waitingPromise:cancel()
	end

	local r6Promise = self.r6Promise

	if r6Promise then
		r6Promise:cancel()
	end

	self.inProgressPromise = nil
	self.waitingPromise = nil
	self.r6Promise = nil
end

function class:stop()
	if fFlagAXUseSignalsForApplyingLayeredClothing then
		getApplyingLayeredClothingStore(false).finishedApplyingLayeredClothing()
	else
		self.store:dispatch(module4())
	end

	self.r6.Parent = ReplicatedStorage
	self.r15current.Parent = ReplicatedStorage
	self.r15offScreen.Parent = ReplicatedStorage

	self:_cancelPromises()
end

function class:onDestroy()
	if fFlagAXUseSignalsForApplyingLayeredClothing then
		getApplyingLayeredClothingStore(false).finishedApplyingLayeredClothing()
	else
		self.store:dispatch(module4())
	end

	self:_cancelPromises()

	self.r6:Destroy()
	self.r15current:Destroy()
	self.r15offScreen:Destroy()
end

return class
