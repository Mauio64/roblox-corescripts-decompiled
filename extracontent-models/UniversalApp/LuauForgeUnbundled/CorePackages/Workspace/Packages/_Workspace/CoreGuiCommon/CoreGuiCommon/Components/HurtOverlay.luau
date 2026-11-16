local StarterGui = game:GetService("StarterGui")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Constants")

local CachedPolicyService = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CachedPolicyService")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/SignalsReact")

local fFlagUseNewHurtOverlayImage = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Flags").FFlagUseNewHurtOverlayImage
local fFlagUseNewHurtOverlayAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Flags").FFlagUseNewHurtOverlayAnimation

local getLocalHumanoidStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores").GetLocalHumanoidStore
local image = Foundation.Image

local color = Color3.fromRGB(187, 0, 4)
local color2 = Color3.new(1, 1, 1)

local v5 = { showOverlay = 0, hideOverlay = 0 }
local createState = Motion.createState
local v7 = if not fFlagUseNewHurtOverlayAnimation then UDim2.fromScale(1.5, 1.5) else nil
v5.showOverlay = createState({ size = v7, transparency = 0 }, {
	default = Motion.transition(Motion.TransitionPreset.Default, {
		duration = fFlagUseNewHurtOverlayAnimation and 0.1 or 0
	})
})

local createState2 = Motion.createState
local v9 = if not fFlagUseNewHurtOverlayAnimation then UDim2.fromScale(3, 3) else nil
v5.hideOverlay = createState2({ size = v9, transparency = 1 }, {
	default = Motion.transition(Motion.TransitionPreset.Default, {
		duration = fFlagUseNewHurtOverlayAnimation and 0.5 or 0.3
	})
})

function LUAUFORGE_MODULE_GLOBALS_hQn_HurtOverlay(p2)
	local mockStarterGui = p2.mockStarterGui or StarterGui
	local v10, v11 = Motion.useMotion(v5.hideOverlay)

	local state, setState = React.useState(mockStarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health))

	local v12 = SignalsReact.useSignalState(getLocalHumanoidStore)
	local ref = React.useRef(v12.getHealthValue(false))

	React.useEffect(function()
		local effect = Signals.createEffect(function(p3)
			local healthValue = v12.getHealthValue(p3)
			local current = ref.current
			ref.current = healthValue

			if
				not healthValue.health
				or not healthValue.maxHealth
				or not current.health
				or healthValue.isDead and current.isDead
			then
				return
			end

			if (current.health - healthValue.health) / healthValue.maxHealth < Constants.HealthPercentForOverlay then
				return
			end

			v11(v5.showOverlay, {
				onAnimationComplete = function(p4)
					if p4 == true then
						v11(v5.hideOverlay)
					end
				end
			})
		end)

		local coreGuiChangedSignalConnection = mockStarterGui.CoreGuiChangedSignal:Connect(function(p3, p4)
			if p3 == Enum.CoreGuiType.Health or p3 == Enum.CoreGuiType.All then
				setState(p4)
			end
		end)

		return function()
			effect()
			coreGuiChangedSignalConnection:Disconnect()
		end
	end, { v12 })
	local v13 = fFlagUseNewHurtOverlayImage and "rbxasset://textures/ui/TopBar/HurtOverlayAsset.png"
		or "rbxasset://textures/ui/TopBar/WhiteOverlayAsset.png"
	local v14 = color

	if CachedPolicyService:IsSubjectToChinaPolicies() then
		v14 = color2
	end

	local v15

	if not state then
		return v15
	end

	local createElement = React.createElement
	local v17 = {
		tag = "anchor-center-center position-center-center",
		testId = "hurt-overlay",
		Image = v13,
		imageStyle = v10.transparency:map(function(p3)
			return { Color3 = v14, Transparency = p3 }
		end),
		ScaleType = Enum.ScaleType.Crop,
		Size = 0
	}
	local v18 = if fFlagUseNewHurtOverlayAnimation then UDim2.fromScale(1, 1) else v10.size
	v17.Size = v18
	v15 = createElement(image, v17)

	return v15
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hQn_HurtOverlay)
