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

local parent = script.Parent.Parent.Parent
local Constants = require(parent.Constants)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)

local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local SetKeepOutArea = require(parent.Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(parent.Actions.RemoveKeepOutArea)

require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local chrome = parent.Parent.Chrome
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

if Enabled() then
	require(chrome.Service)
end

local enabled = Enabled()

local udim = UDim2.new(0, 80, 0, 6)

if enabled then
	udim = UDim2.new(0, 125, 0, 20)
end

local udim2 = UDim2.new(0, 50, 0, 16)
local udim3 = UDim2.new(0, 80, 0, 20)
local udim4 = UDim2.new(0, 220, 0, 16)

local extended = Roact.PureComponent:extend("HealthBar")

local strictInterface = t.strictInterface
local v = {
	layoutOrder = t.optional(t.integer),
	screenSize = 0,
	healthEnabled = 0,
	health = 0,
	maxHealth = 0,
	setKeepOutArea = 0,
	removeKeepOutArea = 0
}
local screenSize

if not FFlagTopBarSignalizeScreenSize then
	screenSize = t.Vector2
end

v.screenSize = screenSize
local healthEnabled

if not FFlagTopBarSignalizeHealthBar then
	healthEnabled = t.boolean
end

v.healthEnabled = healthEnabled
local health

if not FFlagTopBarSignalizeHealthBar then
	health = t.number
end

v.health = health
local maxHealth

if not FFlagTopBarSignalizeHealthBar then
	maxHealth = t.number
end

v.maxHealth = maxHealth
local setKeepOutArea

if not FFlagTopBarSignalizeKeepOutAreas then
	setKeepOutArea = t.callback
end

v.setKeepOutArea = setKeepOutArea
local removeKeepOutArea

if not FFlagTopBarSignalizeKeepOutAreas then
	removeKeepOutArea = t.callback
end

v.removeKeepOutArea = removeKeepOutArea
extended.validateProps = strictInterface(v)

local function color3ToVector3(data) -- 3 equivalent calls inferred from this helper
	return (Vector3.new(data.r, data.g, data.b))
end

local v2 = {
	[color3ToVector3(Constants.HealthRedColor)] = 0.1, -- inferred equivalent call
	[color3ToVector3(Constants.HealthYellowColor)] = 0.5, -- inferred equivalent call
	[color3ToVector3(Constants.HealthGreenColor)] = 0.8 -- inferred equivalent call
}

local HealthRedColor = Constants.HealthRedColor

local HealthGreenColor = Constants.HealthGreenColor

local function getHealthBarColor(p)
	if p <= 0.1 then
		return HealthRedColor
	end

	if p >= 0.8 then
		return HealthGreenColor
	end

	local total = Vector3.new(0, 0, 0)
	local total2 = 0

	for k, v3 in pairs(v2) do
		local v4 = p - v3

		if v4 == 0 then
			return Color3.new(k.x, k.y, k.z)
		end

		local v5 = 1 / (v4 * v4)
		total += v5 * k
		total2 += v5
	end

	local v3 = total / total2
	return Color3.new(v3.x, v3.y, v3.z)
end

function extended:init()
	self.rootRef = Roact.createRef()

	if FFlagTopBarSignalizeHealthBar then
		local binding, setHealth = Roact.createBinding(Constants.InitialHealth)
		self.health = binding
		self.setHealth = setHealth
		local binding2, setMaxHealth = Roact.createBinding(Constants.InitialHealth)
		self.maxHealth = binding2
		self.setMaxHealth = setMaxHealth
		local binding3, setIsDead = Roact.createBinding(false)
		self.isDead = binding3
		self.setIsDead = setIsDead
		self.healthPercent = Roact.joinBindings({ self.health, self.maxHealth, self.isDead }):map(function(list)
			local item = list[1]
			local item2 = list[2]

			local v3 = 1

			if list[3] then
				return 0
			end

			if item2 > 0 then
				return (math.clamp(item / item2, 0, 1))
			end

			return v3
		end)

		self.healthVisible = Roact.joinBindings({ self.health, self.maxHealth }):map(function(list): boolean
			return list[1] < list[2]
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

		local function getHealthEnabled() -- 1 equivalent call inferred from this helper
			return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
		end

		self.coreGuiChangedSignalConn = StarterGui.CoreGuiChangedSignal:Connect(function(p, mountHealthBar: boolean)
			if p == Enum.CoreGuiType.Health or p == Enum.CoreGuiType.All then
				self:setState({ mountHealthBar = mountHealthBar })
			end
		end)

		self:setState({ mountHealthBar = getHealthEnabled() }) -- inferred equivalent call
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		self.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize
		local binding, setScreenSizeBinding = Roact.createBinding(getViewportSize(false))
		self.screenSizeBinding = binding
		self.setScreenSizeBinding = setScreenSizeBinding

		self.disposeScreenSize = Signals.createEffect(function(p)
			self.setScreenSizeBinding(getViewportSize(p))
		end)

		self.healthbarSizeBinding = self.screenSizeBinding:map(function(p)
			if TenFootInterface:IsEnabled() then
				return udim4
			end

			if enabled and p.X <= 320 then
				return udim2
			end

			return if enabled and p.X <= 393 then udim3 else udim
		end)
	end
end

function extended.onUnmount(data)
	if FFlagTopBarSignalizeHealthBar then
		data.coreGuiChangedSignalConn:Disconnect()
		data.disposeHealthConnection()
	end

	if FFlagTopBarSignalizeScreenSize then
		data.disposeScreenSize()
	end
end
function extended:renderHealth()
	local v3

	if FFlagTopBarSignalizeHealthBar then
		v3 = nil
	else
		v3 = self.props.healthEnabled and self.props.health < self.props.maxHealth
	end

	local v4 = 1

	if not FFlagTopBarSignalizeHealthBar then
		if self.props.isDead then
			v4 = 0
		elseif self.props.maxHealth > 0 then
			v4 = math.clamp(self.props.health / self.props.maxHealth, 0, 1)
		end
	end

	local size

	if not FFlagTopBarSignalizeScreenSize then
		if enabled then
			if self.props.screenSize.X <= 320 then
				size = udim2
			elseif self.props.screenSize.X <= 393 then
				size = udim3
			else
				size = udim
			end
		else
			size = udim
		end

		if TenFootInterface:IsEnabled() then
			size = udim4
		end
	end

	local v5 = TenFootInterface:IsEnabled() and 0 or 4
	local rect, image, image2

	if enabled then
		rect = Rect.new(8, 8, 9, 9)
		image = "rbxasset://textures/ui/TopBar/HealthBarBaseTV.png"
		image2 = "rbxasset://textures/ui/TopBar/HealthBarTV.png"
	else
		rect = Rect.new(3, 3, 4, 4)

		if TenFootInterface:IsEnabled() then
			rect = Rect.new(8, 8, 9, 9)
			image = "rbxasset://textures/ui/TopBar/HealthBarBaseTV.png"
			image2 = "rbxasset://textures/ui/TopBar/HealthBarTV.png"
		else
			image = "rbxasset://textures/ui/TopBar/HealthBarBase.png"
			image2 = "rbxasset://textures/ui/TopBar/HealthBar.png"
		end
	end

	local function fn(current)
		if not enabled then
			if
				(FFlagTopBarSignalizeHealthBar and self.healthVisible or not FFlagTopBarSignalizeHealthBar and v3)
				and current
			then
				if FFlagTopBarSignalizeKeepOutAreas then
					self.keepOutAreasStore.setKeepOutArea(
						Constants.HealthBarKeepOutAreaId,
						current.AbsolutePosition,
						current.AbsoluteSize
					)
				else
					self.props.setKeepOutArea(
						Constants.HealthBarKeepOutAreaId,
						current.AbsolutePosition,
						current.AbsoluteSize
					)
				end
			elseif FFlagTopBarSignalizeKeepOutAreas then
				self.keepOutAreasStore.removeKeepOutArea(Constants.HealthBarKeepOutAreaId)
			else
				self.props.removeKeepOutArea(Constants.HealthBarKeepOutAreaId)
			end
		end
	end

	if self.rootRef.current then
		fn(self.rootRef.current)
	end

	local imageColor

	if FFlagTopBarSignalizeHealthBar then
		imageColor = self.healthPercent:map(getHealthBarColor)
	else
		imageColor = getHealthBarColor(v4)
	end

	local createElement = Roact.createElement
	local anchorPoint

	if enabled then
		anchorPoint = Vector2.new(1, 0)
	end

	local position

	if enabled then
		position = UDim2.new(1, 0, 0, 0)
	end

	local visible

	if FFlagTopBarSignalizeHealthBar then
		visible = self.healthVisible
	else
		visible = v3
	end

	local size2

	if FFlagTopBarSignalizeScreenSize then
		size2 = self.healthbarSizeBinding:map(function(p)
			return UDim2.new(p.X, UDim.new(1, 0))
		end)
	else
		size2 = UDim2.new(size.X, UDim.new(1, 0))
	end

	local v6 = {
		AnchorPoint = anchorPoint,
		Position = position,
		Visible = visible,
		BackgroundTransparency = 1,
		Size = size2,
		LayoutOrder = self.props.layoutOrder,
		[Roact.Change.AbsoluteSize] = fn,
		[Roact.Change.AbsolutePosition] = fn,
		[Roact.Ref] = self.rootRef
	}
	local padding

	if not Enabled then
		padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, v5) }) or nil
	end

	local createElement2 = Roact.createElement
	local v7 = {
		BackgroundTransparency = 1,
		Image = image,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		Size = 0,
		Position = 0,
		AnchorPoint = 0
	}

	if FFlagTopBarSignalizeScreenSize then
		size = self.healthbarSizeBinding
	end

	v7.Size = size
	v7.Position = UDim2.fromScale(0, 0.5)
	v7.AnchorPoint = Vector2.new(0, 0.5)

	local createElement3 = Roact.createElement
	local v8 = {
		BackgroundTransparency = 1,
		Image = image2,
		ImageColor3 = imageColor,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		Size = 0
	}
	local size3

	if FFlagTopBarSignalizeHealthBar then
		size3 = self.healthPercent:map(function(p)
			return UDim2.fromScale(p, 1)
		end)
	else
		size3 = UDim2.fromScale(v4, 1)
	end

	v8.Size = size3
	return createElement("Frame", v6, {
		Padding = padding,
		HealthBar = createElement2("ImageLabel", v7, {
			Fill = createElement3("ImageLabel", v8)
		})
	})
end

function extended:render()
	if not FFlagTopBarSignalizeHealthBar then
		return self:renderHealth()
	end

	if self.state.mountHealthBar then
		return (self:renderHealth())
	end

	return nil
end

local function mapStateToProps(data)
	local screenSize2

	if not FFlagTopBarSignalizeScreenSize then
		screenSize2 = data.displayOptions.screenSize
	end

	local health2

	if not FFlagTopBarSignalizeHealthBar then
		health2 = data.health.currentHealth
	end

	local maxHealth2

	if not FFlagTopBarSignalizeHealthBar then
		maxHealth2 = data.health.maxHealth
	end

	local healthEnabled2

	if not FFlagTopBarSignalizeHealthBar then
		healthEnabled2 = data.coreGuiEnabled[Enum.CoreGuiType.Health]
	end

	return {
		screenSize = screenSize2,
		health = health2,
		maxHealth = maxHealth2,
		healthEnabled = healthEnabled2
	}
end

local function mapDispatchToProps(callback)
	if FFlagTopBarSignalizeKeepOutAreas then
		return {}
	end

	return {
		setKeepOutArea = function(p, p2, p3)
			return callback(SetKeepOutArea(p, p2, p3))
		end,
		removeKeepOutArea = function(p)
			return callback(RemoveKeepOutArea(p))
		end
	}
end

local UNSTABLE_connect2 = RoactRodux.UNSTABLE_connect2

if FFlagTopBarSignalizeKeepOutAreas then
	mapDispatchToProps = nil
end

return UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
