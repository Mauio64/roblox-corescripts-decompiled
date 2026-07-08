local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local cFrame = CFrame.new((Vector3.new(0, 150, 0)))
local v6 = game:DefineFastInt("InspectAndBuyClusterCompositionTimeoutMs", 3000)
local t1 = {}

t1.__index = t1

local function setupCharacterModels(p1) -- line: 25
	-- upvalues: Players (copy), RobloxReplicatedStorage (copy)
	local v14, v15

	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		v14 = Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
		v15 = Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	else
		v14 = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
		v15 = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	end

	v14.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	v15.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	v14.HumanoidRootPart.Anchored = true
	v15.HumanoidRootPart.Anchored = true
	v14.Parent = RobloxReplicatedStorage
	v15.Parent = RobloxReplicatedStorage
	v14.HumanoidRootPart.CFrame = CFrame.new(p1)
	v15:SetPrimaryPartCFrame(v14.HumanoidRootPart.CFrame)

	return v14, v15
end

function t1.new(p2, p3, p4, p5) -- line: 60
	-- upvalues: t1 (copy), setupCharacterModels (copy), RobloxReplicatedStorage (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.mockApplyDescription = p5

	local v21, v22 = setupCharacterModels(p3)

	t2.r6 = v21
	t2.r15current = v22
	t2.r15offScreen = v22:Clone()
	t2.r15offScreen.Parent = RobloxReplicatedStorage
	t2.avatarType = p4
	t2.worldModelRef = p2
	t2.inProgressPromise = nil
	t2.waitingPromise = nil
	t2.r6Promise = nil
	t2.destroyed = false

	return t2
end
function t1.setupAnimations(p6, p7, p8) -- line: 92
	p7.Parent = p6.r6
	p8.Parent = p6.r15current
	p8.Archivable = true

	local clone = p8:Clone()

	clone.Parent = p6.r15offScreen
	clone.Archivable = false
	p8.Archivable = false
end
function t1.getCurrentCharacter(p9) -- line: 102
	if p9.avatarType == Enum.HumanoidRigType.R15 then
		return p9.r15current
	end

	return p9.r6
end
function t1.isR15(p10) -- line: 110
	return p10.avatarType == Enum.HumanoidRigType.R15
end
function t1.syncRotation(_, p12, p13) -- line: 114
	local _, _, _, v35, v36, v37, v38, v39, v40, v41, v42, v43 = p12.HumanoidRootPart.CFrame:components()
	local p = p13.HumanoidRootPart.CFrame.p

	p13.HumanoidRootPart.CFrame = CFrame.new(p.X, p.Y, p.Z, v35, v36, v37, v38, v39, v40, v41, v42, v43)
end

local function hasLayeredAccessoryUpdates(p14, p15) -- line: 122
	local Accessories = p14:GetAccessories(false)
	local Accessories2 = p15:GetAccessories(false)

	if #Accessories2 == 0 then
		return false
	end

	if #Accessories ~= #Accessories2 then
		return true
	end

	local t3 = {}

	for _, v in ipairs(Accessories) do
		t3[v.AssetId] = true
	end

	for _, v in ipairs(Accessories2) do
		if not t3[v.AssetId] then
			return true
		end
	end

	return false
end
local function hasWrapLayer(p16) -- line: 148
	return p16:FindFirstChildWhichIsA("WrapLayer", true) ~= nil
end

function t1._doUpdateR6(p17, p18) -- line: 152
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 153
		-- upvalues: p17 (copy), p18 (copy)
		p17.r6.Parent = p17.worldModelRef:getValue()

		if p17.mockApplyDescription then
			p17.mockApplyDescription(p17.r6, p18)
		elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			p17.r6.Humanoid:ApplyDescriptionAsync(p18)
		else
			p17.r6.Humanoid:ApplyDescription(p18)
		end

		resolve(p17:getCurrentCharacter())
	end)
end
function t1._doSimpleUpdateR15(p20, p21) -- line: 169
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 170
		-- upvalues: p20 (copy), p21 (copy)
		p20.r15current.Parent = p20.worldModelRef:getValue()

		if p20.mockApplyDescription then
			p20.mockApplyDescription(p20.r15current, p21)
		elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			p20.r15current.Humanoid:ApplyDescriptionAsync(p21)
		else
			p20.r15current.Humanoid:ApplyDescription(p21)
		end

		resolve(p20.r15current)
	end)
end
function t1._updateOffscreenR15(p23, p24) -- line: 186
	-- upvalues: Promise (copy), cFrame (copy)
	return Promise.new(function(resolve, _) -- line: 187
		-- upvalues: p23 (copy), cFrame (copy), p24 (copy)
		p23.r15offScreen.HumanoidRootPart.CFrame = cFrame
		p23.r15offScreen.Parent = p23.worldModelRef:getValue()

		if p23.mockApplyDescription then
			p23.mockApplyDescription(p23.r15offScreen, p24)
		elseif game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			p23.r15offScreen.Humanoid:ApplyDescriptionAsync(p24)
		else
			p23.r15offScreen.Humanoid:ApplyDescription(p24)
		end

		resolve(p23.r15offScreen)
	end)
end

local function waitForClusterCompositionFinished(p26) -- line: 207
	-- upvalues: Promise (copy), v6 (copy)
	if p26:FindFirstChildWhichIsA("WrapLayer", true) ~= nil then
		return Promise.race({
			Promise.fromEvent(p26.Humanoid.ClusterCompositionFinished),
			Promise.delay(v6 * 0.001)
		}):andThen(function() -- line: 214
			return true
		end)
	end

	return Promise.resolve(false)
end

function t1._completeUpdate(p27) -- line: 222
	-- upvalues: cFrame (copy), RobloxReplicatedStorage (copy)
	local HumanoidRootPartCFrame = p27.r15current.HumanoidRootPart.CFrame

	p27.r15offScreen.HumanoidRootPart.CFrame = HumanoidRootPartCFrame
	p27.r15current.HumanoidRootPart.CFrame = cFrame
	p27.r15current.Parent = RobloxReplicatedStorage

	local r15current = p27.r15current
	local r15offScreen = p27.r15offScreen

	p27.r15offScreen = r15current
	p27.r15current = r15offScreen

	return p27.r15current
end
function t1._doUpdateR15(p28, p29) -- line: 234
	-- upvalues: hasLayeredAccessoryUpdates (copy), waitForClusterCompositionFinished (copy)
	local AppliedDescription = p28.r15current.Humanoid:GetAppliedDescription()

	if not hasLayeredAccessoryUpdates(AppliedDescription, p29) then
		return p28:_doSimpleUpdateR15(p29)
	end

	p28.inProgressPromise = p28:_updateOffscreenR15(p29):andThen(waitForClusterCompositionFinished):andThen(function() -- line: 242
		-- upvalues: p28 (copy)
		return p28:_completeUpdate()
	end)

	return p28.inProgressPromise
end
function t1.maybeUpdateCharacter(p30, p31) -- line: 255
	-- upvalues: Promise (copy)
	if p30.avatarType == Enum.HumanoidRigType.R6 then
		p30.r6Promise = p30:_doUpdateR6(p31)

		return p30.r6Promise
	end

	if p30.inProgressPromise and p30.inProgressPromise:getStatus() == Promise.Status.Started then
		local waitingPromise = p30.waitingPromise

		p30.waitingPromise = p30.inProgressPromise:andThen(function() -- line: 266
			-- upvalues: p30 (copy), p31 (copy)
			return p30:_doUpdateR15(p31)
		end)

		if waitingPromise then
			waitingPromise:cancel()
		end

		return p30.waitingPromise
	end

	return p30:_doUpdateR15(p31)
end
function t1.switchAvatarType(p32, p33) -- line: 281
	-- upvalues: RobloxReplicatedStorage (copy)
	if p33 == p32.avatarType then
		return p32:getCurrentCharacter()
	end

	p32:_cancelPromises()
	p32.avatarType = p33

	local r6, r15current

	if p33 == Enum.HumanoidRigType.R6 then
		r6 = p32.r6
		r15current = p32.r15current
	else
		r6 = p32.r15current
		r15current = p32.r6
	end

	r15current.Parent = RobloxReplicatedStorage
	r15current.Humanoid:UnequipTools()
	p32:syncRotation(r15current, r6)

	return r6
end
function t1.start(_) -- line: 307
end

local function cancelPromise(p35) -- line: 309
	if p35 then
		p35:cancel()
	end
end

function t1._cancelPromises(p36) -- line: 315
	local inProgressPromise = p36.inProgressPromise

	if inProgressPromise then
		inProgressPromise:cancel()
	end

	local waitingPromise = p36.waitingPromise

	if waitingPromise then
		waitingPromise:cancel()
	end

	local r6Promise = p36.r6Promise

	if r6Promise then
		r6Promise:cancel()
	end

	p36.inProgressPromise = nil
	p36.waitingPromise = nil
	p36.r6Promise = nil
end
function t1.stop(p37) -- line: 324
	-- upvalues: RobloxReplicatedStorage (copy)
	p37.r6.Parent = RobloxReplicatedStorage
	p37.r15current.Parent = RobloxReplicatedStorage
	p37.r15offScreen.Parent = RobloxReplicatedStorage
	p37:_cancelPromises()
end
function t1.onDestroy(p38) -- line: 332
	p38:_cancelPromises()
	p38.r6:Destroy()
	p38.r15current:Destroy()
	p38.r15offScreen:Destroy()
end

return t1
