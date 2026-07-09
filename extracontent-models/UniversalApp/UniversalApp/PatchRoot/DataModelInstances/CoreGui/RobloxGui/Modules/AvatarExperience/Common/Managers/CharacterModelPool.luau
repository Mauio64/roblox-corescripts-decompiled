local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local Promise = require(CorePackages.Packages.Promise)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local reportAvatarStat = require(Modules.AvatarExperience.Common.Analytics.reportAvatarStat)
local StartedApplyingLayeredClothing = require(Modules.AvatarExperience.Common.Actions.StartedApplyingLayeredClothing)
local FinishedApplyingLayeredClothing = require(Modules.AvatarExperience.Common.Actions.FinishedApplyingLayeredClothing)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local getMakeupDescriptionsFromHumanoidDescription = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getMakeupDescriptionsFromHumanoidDescription
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXBackgroundSceneManagerRevamp = AvatarExperienceFlags.FFlagAXBackgroundSceneManagerRevamp
local FFlagAXAvatarLoadWithRetry = AvatarExperienceFlags.FFlagAXAvatarLoadWithRetry
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagAXRefetchAvatarOnTimeout = AvatarExperienceFlags.FFlagAXRefetchAvatarOnTimeout
local u19 = if not FFlagAXBackgroundSceneManagerRevamp then CFrame.new(-3.3, 3, 0.2, 0, 0, -1, 0, 1, 0, 1, 0, 0) else CFrame.new(0, 3, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local cFrame = CFrame.new(0, 150, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
local v21 = game:DefineFastFlag("FixVRAvatarPlacement", false)

if IsVRAppBuild() then
	u19 = CFrame.lookAt(Vector3.new(0, 0, -6), (Vector3.new(0, 0, 0)))

	if v21 then
		u19 = CFrame.lookAt(Vector3.new(0, 3, -6), (Vector3.new(0, 3, 0)))
	end

	cFrame = CFrame.lookAt(Vector3.new(6, 1, 100), (Vector3.new(0, 1, 100)))
end

local v22 = game:DefineFastInt("AXClusterCompositionTimeoutMs", 3000)
local t1 = {}

t1.__index = t1

local function setupCharacterModels(p1) -- line: 59
	-- upvalues: FFlagAXAvatarLoadWithRetry (copy), Players (copy), ReplicatedStorage (copy), cFrame (ref)
	local r6, r15

	if FFlagAXAvatarLoadWithRetry then
		r6 = p1.r6
		r15 = p1.r15
	elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		r6 = Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
		r15 = Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	else
		r6 = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
		r15 = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	end

	r6.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	r15.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	r6.HumanoidRootPart.Anchored = true
	r15.HumanoidRootPart.Anchored = true
	r6.Parent = ReplicatedStorage
	r15.Parent = ReplicatedStorage
	r6.HumanoidRootPart.CFrame = cFrame
	r15:SetPrimaryPartCFrame(cFrame)

	return r6, r15
end

function t1.new(p2, p3, p4, p5, p6) -- line: 102
	-- upvalues: t1 (copy), setupCharacterModels (copy), ReplicatedStorage (copy), Constants (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.store = p2
	t2.analytics = p3
	t2.characterMover = p4
	t2.mockApplyDescription = p6

	local v39, v40 = setupCharacterModels(p5)

	t2.r6 = v39
	t2.r6IsOffscreen = true
	t2.r15current = v40
	t2.r15offScreen = v40:Clone()
	t2.r15offScreen.Parent = ReplicatedStorage
	t2.avatarType = Constants.AvatarType.R15
	t2.inProgressPromise = nil
	t2.waitingPromise = nil
	t2.r6Promise = nil
	t2.destroyed = false

	return t2
end
function t1.setupAnimations(p7, p8, p9) -- line: 136
	p8.Parent = p7.r6
	p9.Parent = p7.r15current
	p9.Archivable = true

	local clone = p9:Clone()

	clone.Parent = p7.r15offScreen
	clone.Archivable = false
	p9.Archivable = false
end
function t1.getCurrentCharacter(p10) -- line: 146
	-- upvalues: Constants (copy)
	if p10.avatarType == Constants.AvatarType.R15 then
		return p10.r15current
	end

	return p10.r6
end
function t1.isR15(p11) -- line: 154
	-- upvalues: Constants (copy)
	return p11.avatarType == Constants.AvatarType.R15
end
function t1.syncRotation(_, p13, p14) -- line: 158
	local _, _, _, v53, v54, v55, v56, v57, v58, v59, v60, v61 = p13.HumanoidRootPart.CFrame:components()
	local p = p14.HumanoidRootPart.CFrame.p

	p14.HumanoidRootPart.CFrame = CFrame.new(p.X, p.Y, p.Z, v53, v54, v55, v56, v57, v58, v59, v60, v61)
end

local function hasLayeredAccessoryUpdates(p15, p16) -- line: 166
	local Accessories = p15:GetAccessories(false)
	local Accessories2 = p16:GetAccessories(false)

	if #Accessories2 == 0 then
		return false
	end

	if #Accessories ~= #Accessories2 then
		return true
	end

	local t3 = {}

	for _, v69 in Accessories do
		t3[v69.AssetId] = true
	end

	for _, v71 in Accessories2 do
		if not t3[v71.AssetId] then
			return true
		end
	end

	return false
end

local u26 = nil

if FFlagAXMakeupEquipping then
	function u26(p17, p18) -- line: 194
		-- upvalues: getMakeupDescriptionsFromHumanoidDescription (copy)
		local v74 = getMakeupDescriptionsFromHumanoidDescription(p17)
		local v75 = getMakeupDescriptionsFromHumanoidDescription(p18)

		if #v75 == 0 then
			return false
		end

		if #v74 ~= #v75 then
			return true
		end

		local t4 = {}

		for _, v78 in v74 do
			t4[v78.AssetId] = true
		end

		for _, v80 in v75 do
			if not t4[v80.AssetId] then
				return true
			end
		end

		return false
	end
end

local function hasWrapLayer(p19) -- line: 221
	return p19:FindFirstChildWhichIsA("WrapLayer", true) ~= nil
end

function t1._doUpdateR6(p20, p21) -- line: 225
	-- upvalues: v21 (copy), isSpatial (copy), u19 (ref), Promise (copy)
	if v21 and isSpatial() then
		if p20.r6IsOffscreen then
			p20.r6.HumanoidRootPart.CFrame = u19
			p20.r6IsOffscreen = false
		end

		return Promise.new(function(resolve, _) -- line: 235
			-- upvalues: p20 (copy), p21 (copy)
			if p20.mockApplyDescription then
				p20.mockApplyDescription(p20.r6, p21)
			elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				p20.r6.Humanoid:ApplyDescriptionAsync(p21)
			else
				p20.r6.Humanoid:ApplyDescription(p21)
			end

			resolve(p20:getCurrentCharacter(), p20:_stillWaitingOnLCUpdates())
		end)
	end

	return Promise.new(function(resolve, _) -- line: 250
		-- upvalues: p20 (copy), p21 (copy), u19 (ref)
		if p20.mockApplyDescription then
			p20.mockApplyDescription(p20.r6, p21)
		elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			p20.r6.Humanoid:ApplyDescriptionAsync(p21)
		else
			p20.r6.Humanoid:ApplyDescription(p21)
		end

		if p20.r6IsOffscreen then
			p20.r6.HumanoidRootPart.CFrame = u19
			p20.r6IsOffscreen = false
		end

		resolve(p20:getCurrentCharacter(), p20:_stillWaitingOnLCUpdates())
	end)
end
function t1._doSimpleUpdateR15(p24, p25) -- line: 272
	-- upvalues: Promise (copy), reportAvatarStat (copy)
	return Promise.new(function(resolve, _) -- line: 273
		-- upvalues: p24 (copy), p25 (copy), reportAvatarStat (copy)
		local timestamp = tick()

		if p24.mockApplyDescription then
			p24.mockApplyDescription(p24.r15current, p25)
		elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			p24.r15current.Humanoid:ApplyDescriptionAsync(p25)
		else
			p24.r15current.Humanoid:ApplyDescription(p25)
		end

		local v122 = (tick() - timestamp) * 1000

		reportAvatarStat(p24.analytics, "AXCharacterStandardUpdateTimer", v122)
		resolve(p24.r15current, p24:_stillWaitingOnLCUpdates())
	end)
end
function t1._updateOffscreenR15(p27, p28) -- line: 292
	-- upvalues: StartedApplyingLayeredClothing (copy), Promise (copy), cFrame (ref)
	p27.store:dispatch(StartedApplyingLayeredClothing())

	return Promise.new(function(resolve, _) -- line: 295
		-- upvalues: p27 (copy), cFrame (ref), p28 (copy)
		p27.r15offScreen.HumanoidRootPart.CFrame = cFrame
		p27.r15offScreen.Parent = workspace

		if p27.mockApplyDescription then
			p27.mockApplyDescription(p27.r15offScreen, p28)
		elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			p27.r15offScreen.Humanoid:ApplyDescriptionAsync(p28)
		else
			p27.r15offScreen.Humanoid:ApplyDescription(p28)
		end

		resolve(p27.r15offScreen)
	end)
end

local function waitForClusterCompositionFinished(p30) -- line: 315
	-- upvalues: Promise (copy), v22 (copy)
	if p30:FindFirstChildWhichIsA("WrapLayer", true) ~= nil then
		return Promise.race({
			Promise.fromEvent(p30.Humanoid.ClusterCompositionFinished),
			Promise.delay(v22 * 0.001)
		}):andThen(function() -- line: 322
			return true
		end)
	end

	return Promise.resolve(false)
end

function t1._stillWaitingOnLCUpdates(p31) -- line: 337
	-- upvalues: Constants (copy), hasLayeredAccessoryUpdates (copy)
	if p31.avatarType == Constants.AvatarType.R6 then
		return false
	end

	if p31.avatarType == Constants.AvatarType.R15 and p31.queuedHumanoidDescription and hasLayeredAccessoryUpdates(p31.r15current.Humanoid.HumanoidDescription, p31.queuedHumanoidDescription) then
		return true
	end

	return false
end
function t1._completeUpdate(p32, p33, p34) -- line: 351
	-- upvalues: cFrame (ref), ReplicatedStorage (copy), FinishedApplyingLayeredClothing (copy), reportAvatarStat (copy)
	local HumanoidRootPartCFrame = p32.r15current.HumanoidRootPart.CFrame

	p32.r15offScreen.HumanoidRootPart.CFrame = HumanoidRootPartCFrame
	p32.characterMover:cancelCurrentTween()
	p32.r15current.HumanoidRootPart.CFrame = cFrame
	p32.r15current.Parent = ReplicatedStorage

	local r15current = p32.r15current
	local r15offScreen = p32.r15offScreen

	p32.r15offScreen = r15current
	p32.r15current = r15offScreen
	p32.store:dispatch(FinishedApplyingLayeredClothing())

	local v96 = (tick() - p33) * 1000

	if p34 then
		reportAvatarStat(p32.analytics, "AXCharacterLayeredUpdateTimer", v96)
	else
		reportAvatarStat(p32.analytics, "AXCharacterStandardUpdateTimer", v96)
	end

	return p32.r15current, p32:_stillWaitingOnLCUpdates()
end
function t1._doUpdateR15(p35, p36) -- line: 375
	-- upvalues: FFlagAXMakeupEquipping (copy), hasLayeredAccessoryUpdates (copy), u26 (ref), waitForClusterCompositionFinished (copy)
	local AppliedDescription = p35.r15current.Humanoid:GetAppliedDescription()

	if FFlagAXMakeupEquipping then
		if not hasLayeredAccessoryUpdates(AppliedDescription, p36) and not u26(AppliedDescription, p36) then
			return p35:_doSimpleUpdateR15(p36)
		end
	elseif not hasLayeredAccessoryUpdates(AppliedDescription, p36) then
		return p35:_doSimpleUpdateR15(p36)
	end

	local timestamp = tick()

	p35.inProgressPromise = p35:_updateOffscreenR15(p36):andThen(waitForClusterCompositionFinished):andThen(function(p37) -- line: 395
		-- upvalues: p35 (copy), timestamp (copy)
		return p35:_completeUpdate(timestamp, p37)
	end)

	return p35.inProgressPromise
end
function t1.maybeUpdateCharacter(p38, p39) -- line: 401
	-- upvalues: Constants (copy), Promise (copy)
	if p38.avatarType == Constants.AvatarType.R6 then
		p38.r6Promise = p38:_doUpdateR6(p39)

		return p38.r6Promise
	end

	if p38.inProgressPromise and p38.inProgressPromise:getStatus() == Promise.Status.Started then
		if p38.waitingPromise then
			p38.waitingPromise:cancel()
		end

		p38.queuedHumanoidDescription = p39
		p38.waitingPromise = p38.inProgressPromise:andThen(function() -- line: 420
			-- upvalues: p38 (copy), p39 (copy)
			p38.inProgressPromise = p38.waitingPromise
			p38.waitingPromise = nil
			p38.queuedHumanoidDescription = nil

			return p38:_doUpdateR15(p39)
		end)

		return p38.waitingPromise
	end

	return p38:_doUpdateR15(p39)
end
function t1.switchAvatarType(p40, p41) -- line: 444
	-- upvalues: Constants (copy), ReplicatedStorage (copy)
	if p41 == p40.avatarType then
		return p40:getCurrentCharacter()
	end

	p40:_cancelPromises()
	p40.avatarType = p41

	local r6, r15current

	if p41 == Constants.AvatarType.R6 then
		r6 = p40.r6
		r15current = p40.r15current
	else
		r6 = p40.r15current
		r15current = p40.r6
	end

	r15current.Parent = ReplicatedStorage
	r15current.Humanoid:UnequipTools()
	p40:syncRotation(r15current, r6)

	return r6
end
function t1.start(p42) -- line: 470
	-- upvalues: IsVRAppBuild (copy), u19 (ref)
	if IsVRAppBuild() then
		p42.r15current.HumanoidRootPart.CFrame = u19
	end
end

local function cancelPromise(p43) -- line: 476
	if p43 then
		p43:cancel()
	end
end

function t1._cancelPromises(p44) -- line: 482
	local inProgressPromise = p44.inProgressPromise

	if inProgressPromise then
		inProgressPromise:cancel()
	end

	local waitingPromise = p44.waitingPromise

	if waitingPromise then
		waitingPromise:cancel()
	end

	local r6Promise = p44.r6Promise

	if r6Promise then
		r6Promise:cancel()
	end

	p44.inProgressPromise = nil
	p44.waitingPromise = nil
	p44.r6Promise = nil
end
function t1.stop(p45) -- line: 491
	-- upvalues: FFlagAXRefetchAvatarOnTimeout (copy), FinishedApplyingLayeredClothing (copy), ReplicatedStorage (copy)
	if FFlagAXRefetchAvatarOnTimeout then
		p45.store:dispatch(FinishedApplyingLayeredClothing())
	end

	p45.r6.Parent = ReplicatedStorage
	p45.r15current.Parent = ReplicatedStorage
	p45.r15offScreen.Parent = ReplicatedStorage
	p45:_cancelPromises()
end
function t1.onDestroy(p46) -- line: 502
	-- upvalues: FFlagAXRefetchAvatarOnTimeout (copy), FinishedApplyingLayeredClothing (copy)
	if FFlagAXRefetchAvatarOnTimeout then
		p46.store:dispatch(FinishedApplyingLayeredClothing())
	end

	p46:_cancelPromises()
	p46.r6:Destroy()
	p46.r15current:Destroy()
	p46.r15offScreen:Destroy()
end

return t1
