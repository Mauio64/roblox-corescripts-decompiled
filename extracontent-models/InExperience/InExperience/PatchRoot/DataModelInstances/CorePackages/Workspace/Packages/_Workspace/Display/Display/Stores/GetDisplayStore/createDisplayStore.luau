local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local AppCommonLib = require(ParentParentParent.AppCommonLib)
local VrCompatibility = require(ParentParentParent.VrCompatibility)
local getGlobalGuiInset = require(ParentParent.getGlobalGuiInset)
local FIntLuaAppSmallScreenDesignWidth = require(ParentParent.Flags.FIntLuaAppSmallScreenDesignWidth)
local EngineFeature = game:GetEngineFeature("EnableDisplaySize")
local v10 = game:DefineFastFlag("FFlagLuaAppEnableWindowsHandheldScale", false)
local v11 = game:DefineFastFlag("DebugLuaAppEnableScale", false)
local v12 = v11 or v10 and EngineFeature
local FFlagDebugForceConsoleSafeInsets = require(ParentParentParent.SharedFlags).FFlagDebugForceConsoleSafeInsets
local v14 = GuiService:IsTenFootInterface()

local function forceConsoleSafeInsets(vector2: Vector2) -- line: 42
	-- upvalues: ParentParentParent (copy)
	local MessageBus = require(ParentParentParent.MessageBus).MessageBus
	local t = require(ParentParentParent.t)
	local t1 = {
		mid = MessageBus.getMessageId("Screen", "safeAreaInsets"),
		validateParams = t.strictInterface({
			left = t.number,
			top = t.number,
			right = t.number,
			bottom = t.number
		})
	}
	local t2 = {
		left = vector2.X * 0.05 / 1.5,
		top = vector2.Y * 0.05 / 1.5,
		right = vector2.X * 0.05 / 1.5,
		bottom = vector2.Y * 0.05 / 1.5
	}

	MessageBus.publish(t1, t2)
end

return function() -- line: 66
	-- upvalues: Signals (copy), AppCommonLib (copy), GuiService (copy), VrCompatibility (copy), FFlagDebugForceConsoleSafeInsets (copy), forceConsoleSafeInsets (copy), EngineFeature (copy), getGlobalGuiInset (copy), v11 (copy), FIntLuaAppSmallScreenDesignWidth (copy), v12 (copy), v14 (copy)
	local v21, v22 = Signals.createSignal(workspace.CurrentCamera)
	local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 69
		-- upvalues: v22 (copy)
		v22(workspace.CurrentCamera)
	end)
	local v24, v25 = Signals.createSignal(AppCommonLib.isSpatial())
	local u26 = AppCommonLib.connectToIsSpatialChanged(function(b1: boolean) -- line: 75
		-- upvalues: v25 (copy)
		v25(b1)
	end)

	local function calculateDeviceSafePadding() -- line: 79
		-- upvalues: GuiService (copy)
		local InsetArea = GuiService:GetInsetArea(Enum.ScreenInsets.None)
		local InsetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)

		return {
			left = InsetArea2.Min.X - InsetArea.Min.X,
			top = InsetArea2.Min.Y - InsetArea.Min.Y,
			right = InsetArea.Max.X - InsetArea2.Max.X,
			bottom = InsetArea.Max.Y - InsetArea2.Max.Y
		}
	end

	local v28, v29 = Signals.createSignal((calculateDeviceSafePadding()))
	local vector2 = Vector2.new(1, 1)
	local v31 = v21(false)

	if v31 then
		vector2 = v31.ViewportSize
	end

	local v32, v33 = Signals.createSignal(vector2)
	local u34 = nil
	local v35 = Signals.createEffect(function(p1) -- line: 99
		-- upvalues: v21 (copy), u34 (ref), v24 (copy), v33 (copy), VrCompatibility (copy), v29 (copy), calculateDeviceSafePadding (copy), FFlagDebugForceConsoleSafeInsets (copy), forceConsoleSafeInsets (copy), v32 (copy)
		local v52 = v21(p1)

		if v52 then
			if u34 then
				u34:Disconnect()
				u34 = nil
			end

			if v24(p1) then
				v33(VrCompatibility.VRConstants.MainScreenResolution)

				return
			end

			u34 = v52:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 110
				-- upvalues: v33 (copy), v52 (copy), v29 (copy), calculateDeviceSafePadding (copy), FFlagDebugForceConsoleSafeInsets (copy), forceConsoleSafeInsets (copy), v32 (copy), p1 (copy)
				v33(v52.ViewportSize)
				v29((calculateDeviceSafePadding()))

				if FFlagDebugForceConsoleSafeInsets then
					forceConsoleSafeInsets(v32(p1))
				end
			end)
		end
	end)
	local ViewportDisplaySize = nil

	if EngineFeature then
		ViewportDisplaySize = GuiService.ViewportDisplaySize
	end

	local v37, v38 = Signals.createSignal(ViewportDisplaySize)
	local connection2 = nil

	if EngineFeature then
		connection2 = GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function() -- line: 129
			-- upvalues: v38 (copy), GuiService (copy)
			v38(GuiService.ViewportDisplaySize)
		end)
	end

	local v40 = getGlobalGuiInset()
	local v41, v42 = Signals.createSignal(v40)
	local v43, v44 = Signals.createSignal(v40.top)
	local v45 = Signals.createComputed(function(p2) -- line: 138
		-- upvalues: v37 (copy), v32 (copy), v11 (copy), FIntLuaAppSmallScreenDesignWidth (copy), v12 (copy)
		local v54 = v37(p2)
		local v55 = v32(p2)

		if v54 == nil or v55.X == 0 then
			return 1
		end

		local v56 = v54 == Enum.DisplaySize.Small or v11
		local v57 = v55.X > FIntLuaAppSmallScreenDesignWidth

		if v12 and v56 and v57 then
			return v55.X / FIntLuaAppSmallScreenDesignWidth
		end

		return 1
	end)
	local v46 = Signals.createComputed(function(p3) -- line: 156
		-- upvalues: v14 (copy), v45 (copy)
		if v14 then
			return 1.5
		end

		return v45(p3)
	end)
	local v47 = Signals.createComputed(function(p4) -- line: 165
		-- upvalues: v32 (copy), v46 (copy)
		local v60 = v32(p4)
		local v61 = v46(p4)

		if not v61 or v61 == 0 then
			v61 = 1
		end

		return v60.X / v61
	end)

	return {
		getViewportSize = v32,
		getDisplaySize = v37,
		getGuiInset = v41,
		getTopBarHeight = v43,
		getUIScale = v45,
		getPlatformScale = v46,
		getDesignSpaceViewportWidth = v47,
		getIsSpatial = v24,
		setGuiInset = v42,
		setTopBarHeight = v44,
		getDeviceSafePadding = v28,
		cleanUp = function() -- line: 186
			-- upvalues: connection2 (ref), u34 (ref), connection (ref), u26 (ref), v35 (copy)
			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if u34 then
				u34:Disconnect()
				u34 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if u26 then
				u26:Disconnect()
				u26 = nil
			end

			if v35 then
				v35()
			end
		end,
		forceConsoleSafeInsets = if not FFlagDebugForceConsoleSafeInsets then nil else function() -- line: 208
			-- upvalues: forceConsoleSafeInsets (copy), v32 (copy)
			forceConsoleSafeInsets(v32())
		end
	}
end
