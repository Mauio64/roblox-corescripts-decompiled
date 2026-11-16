local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Signals = require(CorePackages.Packages.Signals)
local Otter = require(CorePackages.Packages.Otter)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)

RobloxGui:FindFirstChild("Modules"):FindFirstChild("Common")

local parent = script.Parent.Parent.Parent
local Constants = require(parent.Constants)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar
local FFlagUseNewHurtOverlayImage = CoreGuiCommon.Flags.FFlagUseNewHurtOverlayImage
local FFlagUseNewHurtOverlayAnimation = CoreGuiCommon.Flags.FFlagUseNewHurtOverlayAnimation

local v = { frequency = 0.75, dampingRatio = 1 }

local color = Color3.fromRGB(187, 0, 4)
local color2 = Color3.new(1, 1, 1)

local extended = Roact.PureComponent:extend("HurtOverlay")

extended.validateProps = t.strictInterface(FFlagTopBarSignalizeHealthBar and {} or {
	healthEnabled = t.boolean,
	health = t.number,
	maxHealth = t.number,
	isDead = t.boolean
})

function extended:init()
	local binding, animationBindingUpdate = Roact.createBinding(0)
	self.animationBinding = binding
	self.animationBindingUpdate = animationBindingUpdate

	if not FFlagUseNewHurtOverlayAnimation then
		self.positionBinding = self.animationBinding:map(function(p)
			return UDim2.new(-10 * p, 0, -10 * p, 0)
		end)

		self.sizeBinding = self.animationBinding:map(function(p)
			return UDim2.new(1 + 19 * p, 0, 1 + 19 * p, 0)
		end)
	end

	if FFlagTopBarSignalizeHealthBar then
		local binding2, setIsAnimating = Roact.createBinding(false)
		self.isAnimating = binding2
		self.setIsAnimating = setIsAnimating
		local binding3, setHealth = Roact.createBinding(Constants.InitialHealth)
		self.health = binding3
		self.setHealth = setHealth
		local binding4, setMaxHealth = Roact.createBinding(Constants.InitialHealth)
		self.maxHealth = binding4
		self.setMaxHealth = setMaxHealth
		local binding5, setIsDead = Roact.createBinding(false)
		self.isDead = binding5
		self.setIsDead = setIsDead
		self.prevHealth = self.health:getValue()
		self.prevIsDead = self.isDead:getValue()

		self.showHurtOverlay = Roact.joinBindings({
			self.isAnimating,
			self.health,
			self.maxHealth,
			self.isDead
		}):map(function(list)
			local item = list[1]
			local item2 = list[2]
			local item3 = list[3]
			local item4 = list[4]
			local prevHealth = self.prevHealth
			local prevIsDead = self.prevIsDead

			self.prevHealth = item2
			self.prevIsDead = item4

			if
				not (item2 < prevHealth)
				or item4 and prevIsDead
				or not ((prevHealth - item2) / item3 >= Constants.HealthPercentForOverlay)
			then
				return item
			end

			if FFlagUseNewHurtOverlayAnimation then
				self.setIsAnimating(true)
				self.motor:setGoal(Otter.ease(0, { duration = 0.1 }))
				self.motor:start()
			else
				self.motor:setGoal(Otter.instant(0))
				self.motor:step(0)
				self.motor:setGoal(Otter.spring(1, v))
				self.motor:start()
				self.setIsAnimating(true)
			end

			return true
		end)

		if CoreGuiCommon.Stores.GetLocalHumanoidStore then
			self.localHumanoidStore = CoreGuiCommon.Stores.GetLocalHumanoidStore(false)
			self.disposeHealthConnection = Signals.createEffect(function(p)
				local healthValue = self.localHumanoidStore.getHealthValue(p)

				self.setHealth(healthValue.health or Constants.InitialHealth)
				self.setMaxHealth(healthValue.maxHealth or Constants.InitialHealth)
				self.setIsDead(healthValue.isDead)
			end)
		end
	else
		self.state = { isAnimating = false }
	end

	self.motor = Otter.createSingleMotor(FFlagUseNewHurtOverlayAnimation and 1 or 0)
	self.motor:onStep(function(p)
		self.animationBindingUpdate(p)
	end)
	local motor = self.motor
	local v2

	if FFlagUseNewHurtOverlayAnimation then
		v2 = function(p)
			if p == 0 then
				self.motor:setGoal(Otter.ease(1, { duration = 0.5 }))
				self.motor:start()
			elseif p == 1 then
				if FFlagTopBarSignalizeHealthBar then
					self.setIsAnimating(false)
				else
					self:setState({ isAnimating = false })
				end
			end
		end
	else
		v2 = function()
			if FFlagTopBarSignalizeHealthBar then
				self.setIsAnimating(false)
			else
				self:setState({ isAnimating = false })
			end
		end
	end

	motor:onComplete(v2)

	if FFlagTopBarSignalizeHealthBar then
		local function getHealthEnabled() -- 1 equivalent call inferred from this helper
			return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
		end

		self.coreGuiChangedSignalConn = StarterGui.CoreGuiChangedSignal:Connect(function(p, mountHurtOverlay: boolean)
			if p == Enum.CoreGuiType.Health or p == Enum.CoreGuiType.All then
				self:setState({ mountHurtOverlay = mountHurtOverlay })
			end
		end)

		self:setState({ mountHurtOverlay = getHealthEnabled() }) -- inferred equivalent call
	end
end

function extended:renderOverlay()
	local visible

	if not FFlagTopBarSignalizeHealthBar then
		visible = self.props.healthEnabled and self.state.isAnimating
	end

	local imageColor = color

	if CachedPolicyService:IsSubjectToChinaPolicies() then
		imageColor = color2
	end

	local createElement = Roact.createElement

	if FFlagTopBarSignalizeHealthBar then
		visible = self.showHurtOverlay
	end

	local v2 = {
		Visible = visible,
		BackgroundTransparency = 1,
		Image = FFlagUseNewHurtOverlayImage and "rbxasset://textures/ui/TopBar/HurtOverlayAsset.png" or "rbxasset://textures/ui/TopBar/WhiteOverlayAsset.png",
		ImageColor3 = imageColor,
		ImageTransparency = 0,
		Size = 0,
		AnchorPoint = 0,
		Position = 0
	}
	local imageTransparency

	if FFlagUseNewHurtOverlayAnimation then
		imageTransparency = self.animationBinding
	end

	v2.ImageTransparency = imageTransparency
	local size

	if FFlagUseNewHurtOverlayAnimation then
		size = UDim2.fromScale(1, 1)
	else
		size = self.sizeBinding
	end

	v2.Size = size
	local anchorPoint

	if FFlagUseNewHurtOverlayAnimation then
		anchorPoint = Vector2.new(0.5, 0.5)
	end

	v2.AnchorPoint = anchorPoint
	local position

	if FFlagUseNewHurtOverlayAnimation then
		position = UDim2.fromScale(0.5, 0.5)
	else
		position = self.positionBinding
	end

	v2.Position = position
	return createElement("ImageLabel", v2)
end

function extended:render()
	if not FFlagTopBarSignalizeHealthBar then
		return self:renderOverlay()
	end

	if self.state.mountHurtOverlay then
		return (self:renderOverlay())
	end

	return nil
end

function extended.didUpdate(object, p, _)
	if FFlagTopBarSignalizeHealthBar then
		return
	end

	if
		object.props.health < p.health
		and not (object.props.isDead and p.isDead)
		and (p.health - object.props.health) / object.props.maxHealth >= Constants.HealthPercentForOverlay
	then
		object.motor:setGoal(Otter.instant(0))
		object.motor:step(0)
		object.motor:setGoal(Otter.spring(1, v))
		object.motor:start()
		object:setState({ isAnimating = true })
	end
end

if FFlagTopBarSignalizeHealthBar then
	function extended.onUnmount(p)
		p.coreGuiChangedSignalConn:Disconnect()
		p.disposeHealthConnection()
	end
end

local function mapStateToProps(p)
	return {
		health = p.health.currentHealth,
		maxHealth = p.health.maxHealth,
		isDead = p.health.isDead,
		healthEnabled = p.coreGuiEnabled[Enum.CoreGuiType.Health]
	}
end

if FFlagTopBarSignalizeHealthBar then
	return extended
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(extended)
