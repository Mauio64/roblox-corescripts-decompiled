local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Signals = require(parent2.Signals)
local AppCommonLib = require(parent2.AppCommonLib)
local VRConstants = require(parent2.VrCompatibility.VRConstants)

local getGlobalGuiInset = require(parent.getGlobalGuiInset)

local FIntLuaAppSmallScreenDesignWidth = require(parent.Flags.FIntLuaAppSmallScreenDesignWidth)
local FFlagDisableLuaAppConsoleScale = require(parent.Flags.FFlagDisableLuaAppConsoleScale)
local engineFeature = game:GetEngineFeature("EnableDisplaySize")
local defineFastFlag = game:DefineFastFlag("FFlagLuaAppEnableWindowsHandheldScale", false)
local defineFastFlag2 = game:DefineFastFlag("DebugLuaAppEnableScale", false)
local v = defineFastFlag2 or defineFastFlag and engineFeature
local SharedFlags = require(parent2.SharedFlags)
local FFlagDebugForceConsoleSafeInsets = SharedFlags.FFlagDebugForceConsoleSafeInsets
local v2 = FFlagDisableLuaAppConsoleScale and 1 or 1.5
local tenFootInterface = AppCommonLib.isTenFootInterface()

local function forceConsoleSafeInsets(vector2: Vector2)
	local MessageBus = require(parent2.MessageBus)
	local messageBus = MessageBus.MessageBus
	local t = require(parent2.t)

	local v3 = {
		mid = messageBus.getMessageId("Screen", "safeAreaInsets"),
		validateParams = t.strictInterface({
			left = t.number,
			top = t.number,
			right = t.number,
			bottom = t.number
		})
	}

	local v4 = {
		left = vector2.X * 0.05 / v2,
		top = vector2.Y * 0.05 / v2,
		right = vector2.X * 0.05 / v2,
		bottom = vector2.Y * 0.05 / v2
	}

	messageBus.publish(v3, v4)
end

return function()
	local signal, v3 = Signals.createSignal(workspace.CurrentCamera)
	local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		v3(workspace.CurrentCamera)
	end)

	local signal2, v4 = Signals.createSignal(AppCommonLib.isSpatial())
	local connection = AppCommonLib.connectToIsSpatialChanged(function(flag: boolean)
		v4(flag)
	end)

	local function calculateDeviceSafePadding()
		local insetArea = GuiService:GetInsetArea(Enum.ScreenInsets.None)
		local insetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
		return {
			left = insetArea2.Min.X - insetArea.Min.X,
			top = insetArea2.Min.Y - insetArea.Min.Y,
			right = insetArea.Max.X - insetArea2.Max.X,
			bottom = insetArea.Max.Y - insetArea2.Max.Y
		}
	end

	local signal3, v5 = Signals.createSignal(calculateDeviceSafePadding())

	local v6 = Vector2.new(1, 1)
	local v7 = signal(false)

	if v7 then
		v6 = v7.ViewportSize
	end

	local signal4, v8 = Signals.createSignal(v6)
	local viewportSizeChangedConnection = nil
	local effect = Signals.createEffect(function(p)
		local v9 = signal(p)

		if v9 then
			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
				viewportSizeChangedConnection = nil
			end

			if signal2(p) then
				v8(VRConstants.MainScreenResolution)
			else
				viewportSizeChangedConnection = v9:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					v8(v9.ViewportSize)
					v5(calculateDeviceSafePadding())

					if FFlagDebugForceConsoleSafeInsets then
						forceConsoleSafeInsets(signal4(p))
					end
				end)
			end
		end
	end)
	local v9

	if engineFeature then
		v9 = GuiService.ViewportDisplaySize
	end

	local signal5, v10 = Signals.createSignal(v9)
	local viewportDisplaySizeChangedConnection

	if engineFeature then
		viewportDisplaySizeChangedConnection = GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function()
			v10(GuiService.ViewportDisplaySize)
		end)
	else
		viewportDisplaySizeChangedConnection = nil
	end

	local globalGuiInset = getGlobalGuiInset()
	local signal6, setGuiInset = Signals.createSignal(globalGuiInset)
	local signal7, setTopBarHeight = Signals.createSignal(globalGuiInset.top)

	local getUIScale = Signals.createComputed(function(p)
		local v11 = signal5(p)
		local v12 = signal4(p)

		if v11 == nil or v12.X == 0 then
			return 1
		end

		local v13 = v11 == Enum.DisplaySize.Small or defineFastFlag2
		local v14 = FIntLuaAppSmallScreenDesignWidth < v12.X

		if v and v13 and v14 then
			return v12.X / FIntLuaAppSmallScreenDesignWidth
		end

		return 1
	end)

	local getPlatformScale = Signals.createComputed(function(p)
		if tenFootInterface then
			return v2
		end

		return getUIScale(p)
	end)

	return {
		getViewportSize = signal4,
		getDisplaySize = signal5,
		getGuiInset = signal6,
		getTopBarHeight = signal7,
		getUIScale = getUIScale,
		getPlatformScale = getPlatformScale,
		getDesignSpaceViewportWidth = Signals.createComputed(function(p)
			local v11 = signal4(p)
			local v12 = getPlatformScale(p)
			local v13 = (not v12 or v12 == 0) and 1 or v12
			return v11.X / v13
		end),
		getIsSpatial = signal2,
		setGuiInset = setGuiInset,
		setTopBarHeight = setTopBarHeight,
		getDeviceSafePadding = signal3,
		cleanUp = function()
			if viewportDisplaySizeChangedConnection then
				viewportDisplaySizeChangedConnection:Disconnect()
				viewportDisplaySizeChangedConnection = nil
			end

			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
				viewportSizeChangedConnection = nil
			end

			if currentCameraChangedConnection then
				currentCameraChangedConnection:Disconnect()
				currentCameraChangedConnection = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if effect then
				effect()
			end
		end,
		forceConsoleSafeInsets = FFlagDebugForceConsoleSafeInsets and function()
			forceConsoleSafeInsets(signal4())
		end or nil
	}
end
