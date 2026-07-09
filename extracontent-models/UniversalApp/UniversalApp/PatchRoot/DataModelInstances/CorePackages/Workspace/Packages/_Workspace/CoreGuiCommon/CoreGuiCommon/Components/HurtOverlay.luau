local StarterGui = game:GetService("StarterGui")
local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local CoreGuiCommonParent = CoreGuiCommon.Parent
local Constants = require(CoreGuiCommon.Constants)
local CachedPolicyService = require(CoreGuiCommonParent.CachedPolicyService)
local Foundation = require(CoreGuiCommonParent.Foundation)
local Motion = require(CoreGuiCommonParent.Motion)
local React = require(CoreGuiCommonParent.React)
local Signals = require(CoreGuiCommonParent.Signals)
local SignalsReact = require(CoreGuiCommonParent.SignalsReact)
local FFlagUseNewHurtOverlayImage = require(CoreGuiCommon.Flags).FFlagUseNewHurtOverlayImage
local FFlagUseNewHurtOverlayAnimation = require(CoreGuiCommon.Flags).FFlagUseNewHurtOverlayAnimation
local GetLocalHumanoidStore = require(CoreGuiCommon.Stores).GetLocalHumanoidStore
local FoundationImage = Foundation.Image
local color3 = Color3.fromRGB(187, 0, 4)
local color3_2 = Color3.new(1, 1, 1)
local t1 = {
	showOverlay = Motion.createState({
		transparency = 0,
		size = if not FFlagUseNewHurtOverlayAnimation then UDim2.fromScale(1.5, 1.5) else nil
	}, {
		default = Motion.transition(Motion.TransitionPreset.Default, {
			duration = not FFlagUseNewHurtOverlayAnimation and 0 or 0.1
		})
	}),
	hideOverlay = Motion.createState({
		transparency = 1,
		size = if not FFlagUseNewHurtOverlayAnimation then UDim2.fromScale(3, 3) else nil
	}, {
		default = Motion.transition(Motion.TransitionPreset.Default, {
			duration = not FFlagUseNewHurtOverlayAnimation and 0.3 or 0.5
		})
	})
}

function HurtOverlay(t2: {[any]: any}) -- line: 51
	-- upvalues: StarterGui (copy), Motion (copy), t1 (copy), React (copy), SignalsReact (copy), GetLocalHumanoidStore (copy), Signals (copy), Constants (copy), FFlagUseNewHurtOverlayImage (copy), color3 (copy), CachedPolicyService (copy), color3_2 (copy), FoundationImage (copy), FFlagUseNewHurtOverlayAnimation (copy)
	local v19 = t2.mockStarterGui or StarterGui
	local v20, v21 = Motion.useMotion(t1.hideOverlay)
	local v22, v23 = React.useState(v19:GetCoreGuiEnabled(Enum.CoreGuiType.Health))
	local v24 = SignalsReact.useSignalState(GetLocalHumanoidStore)
	local v25 = React.useRef(v24.getHealthValue(false))

	React.useEffect(function() -- line: 60
		-- upvalues: Signals (copy), v24 (copy), v25 (copy), Constants (copy), v21 (copy), t1 (copy), v19 (copy), v23 (copy)
		local v28 = Signals.createEffect(function(p1) -- line: 61
			-- upvalues: v24 (copy), v25 (copy), Constants (copy), v21 (copy), t1 (copy)
			local v32 = v24.getHealthValue(p1)
			local current = v25.current

			v25.current = v32

			if not v32.health or (not v32.maxHealth or not current.health) or v32.isDead and current.isDead then
				return
			end

			if (current.health - v32.health) / v32.maxHealth < Constants.HealthPercentForOverlay then
				return
			end

			v21(t1.showOverlay, {
				onAnimationComplete = function(p2) -- line: 79
					-- upvalues: v21 (copy), t1 (copy)
					if p2 == true then
						v21(t1.hideOverlay)
					end
				end
			})
		end)
		local connection = v19.CoreGuiChangedSignal:Connect(function(p3, b1: boolean) -- line: 88
			-- upvalues: v23 (copy)
			if p3 == Enum.CoreGuiType.Health or p3 == Enum.CoreGuiType.All then
				v23(b1)
			end
		end)

		return function() -- line: 95
			-- upvalues: v28 (copy), connection (copy)
			v28()
			connection:Disconnect()
		end
	end, { v24 })

	local v26 = not FFlagUseNewHurtOverlayImage and "rbxasset://textures/ui/TopBar/WhiteOverlayAsset.png" or "rbxasset://textures/ui/TopBar/HurtOverlayAsset.png"
	local u27 = color3

	if CachedPolicyService:IsSubjectToChinaPolicies() then
		u27 = color3_2
	end

	return if not v22 then nil else React.createElement(FoundationImage, {
		tag = "anchor-center-center position-center-center",
		testId = "hurt-overlay",
		Image = v26,
		imageStyle = v20.transparency:map(function(p4) -- line: 114
			-- upvalues: u27 (ref)
			return {
				Color3 = u27,
				Transparency = p4
			}
		end),
		ScaleType = Enum.ScaleType.Crop,
		Size = if not FFlagUseNewHurtOverlayAnimation then v20.size else UDim2.fromScale(1, 1)
	})
end

return React.memo(HurtOverlay)
