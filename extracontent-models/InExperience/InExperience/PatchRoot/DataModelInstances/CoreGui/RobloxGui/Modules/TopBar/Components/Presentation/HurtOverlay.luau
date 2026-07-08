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

local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar
local FFlagUseNewHurtOverlayImage = CoreGuiCommon.Flags.FFlagUseNewHurtOverlayImage
local FFlagUseNewHurtOverlayAnimation = CoreGuiCommon.Flags.FFlagUseNewHurtOverlayAnimation
local t1 = {
	frequency = 0.75,
	dampingRatio = 1
}
local color3 = Color3.fromRGB(187, 0, 4)
local color3_2 = Color3.new(1, 1, 1)
local v20 = Roact.PureComponent:extend("HurtOverlay")

v20.validateProps = t.strictInterface(if not FFlagTopBarSignalizeHealthBar then {
	healthEnabled = t.boolean,
	health = t.number,
	maxHealth = t.number,
	isDead = t.boolean
} else {})

function v20.init(p1) -- line: 46
	-- upvalues: Roact (copy), FFlagUseNewHurtOverlayAnimation (copy), FFlagTopBarSignalizeHealthBar (copy), Constants (copy), Otter (copy), t1 (copy), CoreGuiCommon (copy), Signals (copy), StarterGui (copy)
	local v23, v24 = Roact.createBinding(0)

	p1.animationBinding = v23
	p1.animationBindingUpdate = v24

	if not FFlagUseNewHurtOverlayAnimation then
		p1.positionBinding = p1.animationBinding:map(function(p2) -- line: 51
			return UDim2.new(-10 * p2, 0, -10 * p2, 0)
		end)
		p1.sizeBinding = p1.animationBinding:map(function(p3) -- line: 54
			return UDim2.new(1 + 19 * p3, 0, 1 + 19 * p3, 0)
		end)
	end

	if FFlagTopBarSignalizeHealthBar then
		local v25, v26 = Roact.createBinding(false)

		p1.isAnimating = v25
		p1.setIsAnimating = v26

		local v27, v28 = Roact.createBinding(Constants.InitialHealth)

		p1.health = v27
		p1.setHealth = v28

		local v29, v30 = Roact.createBinding(Constants.InitialHealth)

		p1.maxHealth = v29
		p1.setMaxHealth = v30

		local v31, v32 = Roact.createBinding(false)

		p1.isDead = v31
		p1.setIsDead = v32
		p1.prevHealth = p1.health:getValue()
		p1.prevIsDead = p1.isDead:getValue()
		p1.showHurtOverlay = Roact.joinBindings({
			p1.isAnimating,
			p1.health,
			p1.maxHealth,
			p1.isDead
		}):map(function(p4) -- line: 67
			-- upvalues: p1 (copy), Constants (copy), FFlagUseNewHurtOverlayAnimation (copy), Otter (copy), t1 (copy)
			local v47 = p4[1]
			local v48 = p4[2]
			local v49 = p4[3]
			local v50 = p4[4]
			local prevHealth = p1.prevHealth
			local prevIsDead = p1.prevIsDead

			p1.prevHealth = v48
			p1.prevIsDead = v50

			if v48 < prevHealth and ((not v50 or not prevIsDead) and (prevHealth - v48) / v49 >= Constants.HealthPercentForOverlay) then
				if FFlagUseNewHurtOverlayAnimation then
					p1.setIsAnimating(true)
					p1.motor:setGoal(Otter.ease(0, {
						duration = 0.1
					}))
					p1.motor:start()
				else
					p1.motor:setGoal(Otter.instant(0))
					p1.motor:step(0)
					p1.motor:setGoal(Otter.spring(1, t1))
					p1.motor:start()
					p1.setIsAnimating(true)
				end

				return true
			end

			return v47
		end)

		if CoreGuiCommon.Stores.GetLocalHumanoidStore then
			p1.localHumanoidStore = CoreGuiCommon.Stores.GetLocalHumanoidStore(false)
			p1.disposeHealthConnection = Signals.createEffect(function(p5) -- line: 104
				-- upvalues: p1 (copy), Constants (copy)
				local v54 = p1.localHumanoidStore.getHealthValue(p5)

				p1.setHealth(v54.health or Constants.InitialHealth)
				p1.setMaxHealth(v54.maxHealth or Constants.InitialHealth)
				p1.setIsDead(v54.isDead)
			end)
		end
	else
		p1.state = {
			isAnimating = false
		}
	end

	p1.motor = Otter.createSingleMotor(not FFlagUseNewHurtOverlayAnimation and 0 or 1)
	p1.motor:onStep(function(p6) -- line: 119
		-- upvalues: p1 (copy)
		p1.animationBindingUpdate(p6)
	end)
	p1.motor:onComplete(not FFlagUseNewHurtOverlayAnimation and function() -- line: 138
		-- upvalues: FFlagTopBarSignalizeHealthBar (copy), p1 (copy)
		if FFlagTopBarSignalizeHealthBar then
			p1.setIsAnimating(false)

			return
		end

		p1:setState({
			isAnimating = false
		})
	end or function(p7) -- line: 123
		-- upvalues: p1 (copy), Otter (copy), FFlagTopBarSignalizeHealthBar (copy)
		if p7 == 0 then
			p1.motor:setGoal(Otter.ease(1, {
				duration = 0.5
			}))
			p1.motor:start()

			return
		end

		if p7 == 1 then
			if FFlagTopBarSignalizeHealthBar then
				p1.setIsAnimating(false)

				return
			end

			p1:setState({
				isAnimating = false
			})
		end
	end)

	if FFlagTopBarSignalizeHealthBar then
		local function getHealthEnabled() -- line: 149
			-- upvalues: StarterGui (copy)
			return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
		end

		p1.coreGuiChangedSignalConn = StarterGui.CoreGuiChangedSignal:Connect(function(p8, b1: boolean) -- line: 154
			-- upvalues: p1 (copy)
			if p8 == Enum.CoreGuiType.Health or p8 == Enum.CoreGuiType.All then
				p1:setState({
					mountHurtOverlay = b1
				})
			end
		end)
		p1:setState({
			mountHurtOverlay = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
		})
	end
end
function v20.renderOverlay(p9) -- line: 168
	-- upvalues: FFlagTopBarSignalizeHealthBar (copy), FFlagUseNewHurtOverlayImage (copy), color3 (copy), CachedPolicyService (copy), color3_2 (copy), Roact (copy), FFlagUseNewHurtOverlayAnimation (copy)
	local v35 = nil

	if not FFlagTopBarSignalizeHealthBar then
		v35 = p9.props.healthEnabled and p9.state.isAnimating
	end

	local v36 = not FFlagUseNewHurtOverlayImage and "rbxasset://textures/ui/TopBar/WhiteOverlayAsset.png" or "rbxasset://textures/ui/TopBar/HurtOverlayAsset.png"
	local v37 = color3

	if CachedPolicyService:IsSubjectToChinaPolicies() then
		v37 = color3_2
	end

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Visible = if not FFlagTopBarSignalizeHealthBar then v35 else p9.showHurtOverlay,
		Image = v36,
		ImageColor3 = v37,
		ImageTransparency = if not FFlagUseNewHurtOverlayAnimation then nil else p9.animationBinding,
		Size = if not FFlagUseNewHurtOverlayAnimation then p9.sizeBinding else UDim2.fromScale(1, 1),
		AnchorPoint = if not FFlagUseNewHurtOverlayAnimation then nil else Vector2.new(0.5, 0.5),
		Position = if not FFlagUseNewHurtOverlayAnimation then p9.positionBinding else UDim2.fromScale(0.5, 0.5)
	})
end
function v20.render(p10) -- line: 194
	-- upvalues: FFlagTopBarSignalizeHealthBar (copy)
	if FFlagTopBarSignalizeHealthBar then
		if p10.state.mountHurtOverlay then
			return (p10:renderOverlay())
		end

		return nil
	end

	return p10:renderOverlay()
end
function v20.didUpdate(p11, p12, _) -- line: 202
	-- upvalues: FFlagTopBarSignalizeHealthBar (copy), Constants (copy), Otter (copy), t1 (copy)
	if FFlagTopBarSignalizeHealthBar then
		return
	end

	if p11.props.health < p12.health and ((not p11.props.isDead or not p12.isDead) and (p12.health - p11.props.health) / p11.props.maxHealth >= Constants.HealthPercentForOverlay) then
		p11.motor:setGoal(Otter.instant(0))
		p11.motor:step(0)
		p11.motor:setGoal(Otter.spring(1, t1))
		p11.motor:start()
		p11:setState({
			isAnimating = true
		})
	end
end

if FFlagTopBarSignalizeHealthBar then
	function v20.onUnmount(p14) -- line: 224
		p14.coreGuiChangedSignalConn:Disconnect()
		p14.disposeHealthConnection()
	end
end

local function mapStateToProps(p15) -- line: 230
	return {
		health = p15.health.currentHealth,
		maxHealth = p15.health.maxHealth,
		isDead = p15.health.isDead,
		healthEnabled = p15.coreGuiEnabled[Enum.CoreGuiType.Health]
	}
end

if FFlagTopBarSignalizeHealthBar then
	return v20
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(v20)
