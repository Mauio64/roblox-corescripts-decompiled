local GuiService = game:GetService("GuiService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/Signals")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/AppCommonLib")
local VRConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/VrCompatibility/VRConstants")

local getGlobalGuiInset = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/Display/getGlobalGuiInset")

local FIntLuaAppSmallScreenDesignWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/Display/Flags/FIntLuaAppSmallScreenDesignWidth")
local FFlagDisableLuaAppConsoleScale = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/Display/Flags/FFlagDisableLuaAppConsoleScale")
local engineFeature = game:GetEngineFeature("EnableDisplaySize")
local defineFastFlag = game:DefineFastFlag("FFlagLuaAppEnableWindowsHandheldScale", false)
local defineFastFlag2 = game:DefineFastFlag("DebugLuaAppEnableScale", false)
local v5 = defineFastFlag2 or defineFastFlag and engineFeature
local fFlagDebugForceConsoleSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/SharedFlags").FFlagDebugForceConsoleSafeInsets
local v6 = FFlagDisableLuaAppConsoleScale and 1 or 1.5
local tenFootInterface = AppCommonLib.isTenFootInterface()

local function forceConsoleSafeInsets(p2)
	local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/MessageBus").MessageBus
	local t = require("@game/CorePackages/Workspace/Packages/_Workspace/Display/t")

	local v7 = {
		mid = messageBus.getMessageId("Screen", "safeAreaInsets"),
		validateParams = t.strictInterface({
			left = t.number,
			top = t.number,
			right = t.number,
			bottom = t.number
		})
	}

	local v8 = {
		left = p2.X * 0.05 / v6,
		top = p2.Y * 0.05 / v6,
		right = p2.X * 0.05 / v6,
		bottom = p2.Y * 0.05 / v6
	}

	messageBus.publish(v7, v8)
end

return function()
	local signal, v7 = Signals.createSignal(workspace.CurrentCamera)
	local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		v7(workspace.CurrentCamera)
	end)

	local signal2, v8 = Signals.createSignal(AppCommonLib.isSpatial())
	local connection = AppCommonLib.connectToIsSpatialChanged(function(p2)
		v8(p2)
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

	local signal3, v9 = Signals.createSignal(calculateDeviceSafePadding())

	local v10 = Vector2.new(1, 1)
	local v11 = signal(false)

	if v11 then
		v10 = v11.ViewportSize
	end

	local signal4, v12 = Signals.createSignal(v10)
	local viewportSizeChangedConnection = nil
	local effect = Signals.createEffect(function(p2)
		local v13 = signal(p2)

		if v13 then
			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
				viewportSizeChangedConnection = nil
			end

			if signal2(p2) then
				v12(VRConstants.MainScreenResolution)
			else
				viewportSizeChangedConnection = v13:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					v12(v13.ViewportSize)
					v9(calculateDeviceSafePadding())

					if fFlagDebugForceConsoleSafeInsets then
						forceConsoleSafeInsets(signal4(p2))
					end
				end)
			end
		end
	end)

	local v13 = if engineFeature then GuiService.ViewportDisplaySize else nil

	local signal5, v14 = Signals.createSignal(v13)
	local viewportDisplaySizeChangedConnection

	if engineFeature then
		viewportDisplaySizeChangedConnection = GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function()
			v14(GuiService.ViewportDisplaySize)
		end)
	else
		viewportDisplaySizeChangedConnection = nil
	end

	local v15 = getGlobalGuiInset()
	local signal6, v16 = Signals.createSignal(v15)
	local signal7, v17 = Signals.createSignal(v15.top)

	local computed = Signals.createComputed(function(p2)
		local v18 = signal5(p2)
		local v19 = signal4(p2)

		if v18 == nil or v19.X == 0 then
			return 1
		end

		local v20 = v18 == Enum.DisplaySize.Small or defineFastFlag2
		local v21 = FIntLuaAppSmallScreenDesignWidth < v19.X

		if v5 and v20 and v21 then
			return v19.X / FIntLuaAppSmallScreenDesignWidth
		end

		return 1
	end)

	local computed2 = Signals.createComputed(function(p2)
		if tenFootInterface then
			return v6
		end

		return computed(p2)
	end)

	return {
		getViewportSize = signal4,
		getDisplaySize = signal5,
		getGuiInset = signal6,
		getTopBarHeight = signal7,
		getUIScale = computed,
		getPlatformScale = computed2,
		getDesignSpaceViewportWidth = Signals.createComputed(function(p2)
			local v18 = signal4(p2)
			local v19 = computed2(p2)
			local v20 = (not v19 or v19 == 0) and 1 or v19
			return v18.X / v20
		end),
		getIsSpatial = signal2,
		setGuiInset = v16,
		setTopBarHeight = v17,
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
		forceConsoleSafeInsets = fFlagDebugForceConsoleSafeInsets and function()
			forceConsoleSafeInsets(signal4())
		end or nil
	}
end
