local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

game:GetService("Workspace")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local SetKeepOutArea = require(ParentParent.Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(ParentParent.Actions.RemoveKeepOutArea)

require(CorePackages.Workspace.Packages.SharedFlags)

local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize
local Chrome = ParentParent.Parent.Chrome
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled

if Enabled() then
	require(Chrome.Service)
end

local v21 = Enabled()
local uDim2 = UDim2.new(0, 80, 0, 6)

if v21 then
	uDim2 = UDim2.new(0, 125, 0, 20)
end

local uDim2_2 = UDim2.new(0, 50, 0, 16)
local uDim2_3 = UDim2.new(0, 80, 0, 20)
local uDim2_4 = UDim2.new(0, 220, 0, 16)
local v26 = Roact.PureComponent:extend("HealthBar")

v26.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	screenSize = if not FFlagTopBarSignalizeScreenSize then t.Vector2 else nil,
	healthEnabled = if not FFlagTopBarSignalizeHealthBar then t.boolean else nil,
	health = if not FFlagTopBarSignalizeHealthBar then t.number else nil,
	maxHealth = if not FFlagTopBarSignalizeHealthBar then t.number else nil,
	setKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil,
	removeKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil
})

local function color3ToVector3(p1) -- line: 63
	return (Vector3.new(p1.r, p1.g, p1.b))
end

local t1 = {}
local HealthRedColor = Constants.HealthRedColor

t1[Vector3.new(HealthRedColor.r, HealthRedColor.g, HealthRedColor.b)] = 0.1

local HealthYellowColor = Constants.HealthYellowColor

t1[Vector3.new(HealthYellowColor.r, HealthYellowColor.g, HealthYellowColor.b)] = 0.5

local HealthGreenColor = Constants.HealthGreenColor

t1[Vector3.new(HealthGreenColor.r, HealthGreenColor.g, HealthGreenColor.b)] = 0.8

local HealthRedColor2 = Constants.HealthRedColor
local HealthGreenColor2 = Constants.HealthGreenColor

local function getHealthBarColor(p2) -- line: 77
	-- upvalues: HealthRedColor2 (copy), HealthGreenColor2 (copy), t1 (copy)
	if p2 <= 0.1 then
		return HealthRedColor2
	end

	if p2 >= 0.8 then
		return HealthGreenColor2
	end

	local vector3 = Vector3.new(0, 0, 0)
	local n1 = 0

	for k, v in pairs(t1) do
		local v43 = p2 - v

		if v43 == 0 then
			return Color3.new(k.x, k.y, k.z)
		end

		local v44 = 1 / (v43 * v43)

		vector3 += v44 * k
		n1 += v44
	end

	local v45 = vector3 / n1

	return Color3.new(v45.x, v45.y, v45.z)
end

function v26.init(p3) -- line: 102
	-- upvalues: Roact (copy), FFlagTopBarSignalizeHealthBar (copy), Constants (copy), CoreGuiCommon (copy), Signals (copy), StarterGui (copy), FFlagTopBarSignalizeKeepOutAreas (copy), FFlagTopBarSignalizeScreenSize (copy), Display (copy), TenFootInterface (copy), uDim2_4 (copy), v21 (copy), uDim2_2 (copy), uDim2_3 (copy), uDim2 (ref)
	p3.rootRef = Roact.createRef()

	if FFlagTopBarSignalizeHealthBar then
		local v47, v48 = Roact.createBinding(Constants.InitialHealth)

		p3.health = v47
		p3.setHealth = v48

		local v49, v50 = Roact.createBinding(Constants.InitialHealth)

		p3.maxHealth = v49
		p3.setMaxHealth = v50

		local v51, v52 = Roact.createBinding(false)

		p3.isDead = v51
		p3.setIsDead = v52
		p3.healthPercent = Roact.joinBindings({
			p3.health,
			p3.maxHealth,
			p3.isDead
		}):map(function(p4) -- line: 108
			local v72 = p4[1]
			local v73 = p4[2]
			local n2 = 1

			if p4[3] then
				return 0
			end

			if v73 > 0 then
				n2 = math.clamp(v72 / v73, 0, 1)
			end

			return n2
		end)
		p3.healthVisible = Roact.joinBindings({
			p3.health,
			p3.maxHealth
		}):map(function(p5) -- line: 122
			return p5[1] < p5[2]
		end)

		if CoreGuiCommon.Stores.GetLocalHumanoidStore then
			p3.localHumanoidStore = CoreGuiCommon.Stores.GetLocalHumanoidStore(false)
			p3.disposeHealthConnection = Signals.createEffect(function(p6) -- line: 128
				-- upvalues: p3 (copy), Constants (copy)
				local v77 = p3.localHumanoidStore.getHealthValue(p6)

				p3.setHealth(v77.health or Constants.InitialHealth)
				p3.setMaxHealth(v77.maxHealth or Constants.InitialHealth)
				p3.setIsDead(v77.isDead)
			end)
		end

		local function getHealthEnabled() -- line: 137
			-- upvalues: StarterGui (copy)
			return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
		end

		p3.coreGuiChangedSignalConn = StarterGui.CoreGuiChangedSignal:Connect(function(p7, b1: boolean) -- line: 142
			-- upvalues: p3 (copy)
			if p7 == Enum.CoreGuiType.Health or p7 == Enum.CoreGuiType.All then
				p3:setState({
					mountHealthBar = b1
				})
			end
		end)
		p3:setState({
			mountHealthBar = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
		})
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		p3.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize
		local v55, v56 = Roact.createBinding(getViewportSize(false))

		p3.screenSizeBinding = v55
		p3.setScreenSizeBinding = v56
		p3.disposeScreenSize = Signals.createEffect(function(p8) -- line: 162
			-- upvalues: p3 (copy), getViewportSize (copy)
			p3.setScreenSizeBinding(getViewportSize(p8))
		end)
		p3.healthbarSizeBinding = p3.screenSizeBinding:map(function(p9) -- line: 166
			-- upvalues: TenFootInterface (copy), uDim2_4 (copy), v21 (copy), uDim2_2 (copy), uDim2_3 (copy), uDim2 (ref)
			if TenFootInterface:IsEnabled() then
				return uDim2_4
			end

			if v21 and p9.X <= 320 then
				return uDim2_2
			end

			if v21 and p9.X <= 393 then
				return uDim2_3
			end

			return uDim2
		end)
	end
end
function v26.onUnmount(p10) -- line: 180
	-- upvalues: FFlagTopBarSignalizeHealthBar (copy), FFlagTopBarSignalizeScreenSize (copy)
	if FFlagTopBarSignalizeHealthBar then
		p10.coreGuiChangedSignalConn:Disconnect()
		p10.disposeHealthConnection()
	end

	if FFlagTopBarSignalizeScreenSize then
		p10.disposeScreenSize()
	end
end
function v26.renderHealth(p11) -- line: 189
	-- upvalues: FFlagTopBarSignalizeHealthBar (copy), FFlagTopBarSignalizeScreenSize (copy), v21 (copy), uDim2_2 (copy), uDim2_3 (copy), uDim2 (ref), TenFootInterface (copy), uDim2_4 (copy), FFlagTopBarSignalizeKeepOutAreas (copy), Constants (copy), getHealthBarColor (copy), Roact (copy), Enabled (copy)
	local u59 = nil

	if not FFlagTopBarSignalizeHealthBar then
		u59 = p11.props.healthEnabled and p11.props.health < p11.props.maxHealth
	end

	local n3 = 1

	if not FFlagTopBarSignalizeHealthBar then
		if p11.props.isDead then
			n3 = 0
		elseif p11.props.maxHealth > 0 then
			n3 = math.clamp(p11.props.health / p11.props.maxHealth, 0, 1)
		end
	end

	local v61 = nil

	if not FFlagTopBarSignalizeScreenSize then
		if v21 then
			v61 = if not (p11.props.screenSize.X <= 320) then if not (p11.props.screenSize.X <= 393) then uDim2 else uDim2_3 else uDim2_2

			if TenFootInterface:IsEnabled() then
				v61 = uDim2_4
			end
		else
			v61 = uDim2

			if TenFootInterface:IsEnabled() then
				v61 = uDim2_4
			end
		end
	end

	local n4 = 4

	if TenFootInterface:IsEnabled() then
		n4 = 0
	end

	local s1, s2, rect

	if v21 then
		s1 = "rbxasset://textures/ui/TopBar/HealthBarBaseTV.png"
		s2 = "rbxasset://textures/ui/TopBar/HealthBarTV.png"
		rect = Rect.new(8, 8, 9, 9)
	else
		s1 = "rbxasset://textures/ui/TopBar/HealthBarBase.png"
		s2 = "rbxasset://textures/ui/TopBar/HealthBar.png"
		rect = Rect.new(3, 3, 4, 4)

		if TenFootInterface:IsEnabled() then
			s1 = "rbxasset://textures/ui/TopBar/HealthBarBaseTV.png"
			s2 = "rbxasset://textures/ui/TopBar/HealthBarTV.png"
			rect = Rect.new(8, 8, 9, 9)
		end
	end

	local function v66(p12) -- line: 249
		-- upvalues: v21 (copy), FFlagTopBarSignalizeHealthBar (copy), p11 (copy), u59 (ref), FFlagTopBarSignalizeKeepOutAreas (copy), Constants (copy)
		if not v21 then
			if (FFlagTopBarSignalizeHealthBar and p11.healthVisible or not FFlagTopBarSignalizeHealthBar and u59) and p12 then
				if FFlagTopBarSignalizeKeepOutAreas then
					p11.keepOutAreasStore.setKeepOutArea(Constants.HealthBarKeepOutAreaId, p12.AbsolutePosition, p12.AbsoluteSize)

					return
				end

				p11.props.setKeepOutArea(Constants.HealthBarKeepOutAreaId, p12.AbsolutePosition, p12.AbsoluteSize)

				return
			end

			if FFlagTopBarSignalizeKeepOutAreas then
				p11.keepOutAreasStore.removeKeepOutArea(Constants.HealthBarKeepOutAreaId)

				return
			end

			p11.props.removeKeepOutArea(Constants.HealthBarKeepOutAreaId)
		end
	end

	if p11.rootRef.current then
		v66(p11.rootRef.current)
	end

	local v67 = if not FFlagTopBarSignalizeHealthBar then getHealthBarColor(n3) else p11.healthPercent:map(getHealthBarColor)

	return Roact.createElement("Frame", {
		AnchorPoint = if not v21 then nil else Vector2.new(1, 0),
		Position = if not v21 then nil else UDim2.new(1, 0, 0, 0),
		Visible = if not FFlagTopBarSignalizeHealthBar then u59 else p11.healthVisible,
		BackgroundTransparency = 1,
		Size = if not FFlagTopBarSignalizeScreenSize then UDim2.new(v61.X, UDim.new(1, 0)) else p11.healthbarSizeBinding:map(function(p13) -- line: 277
			return UDim2.new(p13.X, UDim.new(1, 0))
		end),
		LayoutOrder = p11.props.layoutOrder,
		[Roact.Change.AbsoluteSize] = v66,
		[Roact.Change.AbsolutePosition] = v66,
		[Roact.Ref] = p11.rootRef
	}, {
		Padding = not Enabled and Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, n4)
		}) or nil,
		HealthBar = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = s1,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			Size = if not FFlagTopBarSignalizeScreenSize then v61 else p11.healthbarSizeBinding,
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			Fill = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = s2,
				ImageColor3 = v67,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect,
				Size = if not FFlagTopBarSignalizeHealthBar then UDim2.fromScale(n3, 1) else p11.healthPercent:map(function(p14) -- line: 305
					return UDim2.fromScale(p14, 1)
				end)
			})
		})
	})
end
function v26.render(p15) -- line: 313
	-- upvalues: FFlagTopBarSignalizeHealthBar (copy)
	if FFlagTopBarSignalizeHealthBar then
		if p15.state.mountHealthBar then
			return (p15:renderHealth())
		end

		return nil
	end

	return p15:renderHealth()
end

local function mapStateToProps(p16) -- line: 321
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy), FFlagTopBarSignalizeHealthBar (copy)
	return {
		screenSize = if not FFlagTopBarSignalizeScreenSize then p16.displayOptions.screenSize else nil,
		health = if not FFlagTopBarSignalizeHealthBar then p16.health.currentHealth else nil,
		maxHealth = if not FFlagTopBarSignalizeHealthBar then p16.health.maxHealth else nil,
		healthEnabled = if not FFlagTopBarSignalizeHealthBar then p16.coreGuiEnabled[Enum.CoreGuiType.Health] else nil
	}
end
local function mapDispatchToProps(p17) -- line: 330
	-- upvalues: FFlagTopBarSignalizeKeepOutAreas (copy), SetKeepOutArea (copy), RemoveKeepOutArea (copy)
	if FFlagTopBarSignalizeKeepOutAreas then
		return {}
	end

	return {
		setKeepOutArea = function(p18, p19, p20) -- line: 335
			-- upvalues: p17 (copy), SetKeepOutArea (copy)
			return p17(SetKeepOutArea(p18, p19, p20))
		end,
		removeKeepOutArea = function(p21) -- line: 338
			-- upvalues: p17 (copy), RemoveKeepOutArea (copy)
			return p17(RemoveKeepOutArea(p21))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, (if not FFlagTopBarSignalizeKeepOutAreas then mapDispatchToProps else nil))(v26)
