local StarterGui = game:GetService("StarterGui")

local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local parent = CoreGuiCommon.Parent
local Constants = require(CoreGuiCommon.Constants)

local CachedPolicyService = require(parent.CachedPolicyService)
local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Flags = require(CoreGuiCommon.Flags)
local FFlagUseNewHurtOverlayImage = Flags.FFlagUseNewHurtOverlayImage
local Flags2 = require(CoreGuiCommon.Flags)
local FFlagUseNewHurtOverlayAnimation = Flags2.FFlagUseNewHurtOverlayAnimation

local Stores = require(CoreGuiCommon.Stores)
local GetLocalHumanoidStore = Stores.GetLocalHumanoidStore
local Image = Foundation.Image

local color = Color3.fromRGB(187, 0, 4)
local color2 = Color3.new(1, 1, 1)

local v = { showOverlay = 0, hideOverlay = 0 }
local createState = Motion.createState
local size

if not FFlagUseNewHurtOverlayAnimation then
	size = UDim2.fromScale(1.5, 1.5)
end

v.showOverlay = createState({ size = size, transparency = 0 }, {
	default = Motion.transition(Motion.TransitionPreset.Default, {
		duration = FFlagUseNewHurtOverlayAnimation and 0.1 or 0
	})
})

local createState2 = Motion.createState
local size2

if not FFlagUseNewHurtOverlayAnimation then
	size2 = UDim2.fromScale(3, 3)
end

v.hideOverlay = createState2({ size = size2, transparency = 1 }, {
	default = Motion.transition(Motion.TransitionPreset.Default, {
		duration = FFlagUseNewHurtOverlayAnimation and 0.5 or 0.3
	})
})

function HurtOverlay(p)
	local mockStarterGui = p.mockStarterGui or StarterGui
	local v2, v3 = Motion.useMotion(v.hideOverlay)

	local state, setState = React.useState(mockStarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health))

	local v4 = SignalsReact.useSignalState(GetLocalHumanoidStore)
	local ref = React.useRef(v4.getHealthValue(false))

	React.useEffect(function()
		local effect = Signals.createEffect(function(p2)
			local healthValue = v4.getHealthValue(p2)
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

			v3(v.showOverlay, {
				onAnimationComplete = function(p3)
					if p3 == true then
						v3(v.hideOverlay)
					end
				end
			})
		end)

		local coreGuiChangedSignalConnection = mockStarterGui.CoreGuiChangedSignal:Connect(function(p2, flag: boolean)
			if p2 == Enum.CoreGuiType.Health or p2 == Enum.CoreGuiType.All then
				setState(flag)
			end
		end)

		return function()
			effect()
			coreGuiChangedSignalConnection:Disconnect()
		end
	end, { v4 })
	local image = FFlagUseNewHurtOverlayImage and "rbxasset://textures/ui/TopBar/HurtOverlayAsset.png"
		or "rbxasset://textures/ui/TopBar/WhiteOverlayAsset.png"
	local color3 = color

	if CachedPolicyService:IsSubjectToChinaPolicies() then
		color3 = color2
	end

	local v5

	if not state then
		return v5
	end

	local createElement = React.createElement
	local v6 = {
		tag = "anchor-center-center position-center-center",
		testId = "hurt-overlay",
		Image = image,
		imageStyle = v2.transparency:map(function(transparency)
			return { Color3 = color3, Transparency = transparency }
		end),
		ScaleType = Enum.ScaleType.Crop,
		Size = 0
	}
	local size3

	if FFlagUseNewHurtOverlayAnimation then
		size3 = UDim2.fromScale(1, 1)
	else
		size3 = v2.size
	end

	v6.Size = size3
	return (createElement(Image, v6))
end

return React.memo(HurtOverlay)
