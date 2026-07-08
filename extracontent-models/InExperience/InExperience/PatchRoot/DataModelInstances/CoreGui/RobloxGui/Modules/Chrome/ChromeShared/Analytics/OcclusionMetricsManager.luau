local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Signals = require(CorePackages.Packages.Signals)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Constants = require(ChromeShared.Unibar.Constants)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local v11 = require(CorePackages.Workspace.Packages.SharedFlags).GetFIntLuaUIOcclusionMetricsReportingPeriodSeconds()
local EngineFeature = game:GetEngineFeature("GuiServiceSendUIOcclusionMetricsForQueryRegion")

local function convertCoreUIPointToHardwareSafeAreaPoint(vector2: Vector2) -- line: 28
	-- upvalues: GuiService (copy)
	return vector2 + GuiService:GetGuiInset()
end
local function vector2ToUDim2(vector2: Vector2) -- line: 33
	return UDim2.fromOffset(vector2.X, vector2.Y)
end
local function reportOcclusionMetrics(t1: {[any]: any}) -- line: 37
	-- upvalues: GuiService (copy)
	local v20 = t1.position + GuiService:GetGuiInset()
	local v21 = GuiService
	local uDim2 = UDim2.fromOffset(v20.X, v20.Y)
	local size = t1.size

	v21:SendUIOcclusionMetricsForQueryRegion(uDim2, UDim2.fromOffset(size.X, size.Y), "currentSizeTR")
end
local function OcclusionMetricsManager() -- line: 46
	-- upvalues: EngineFeature (copy), React (copy), Constants (copy), FFlagTopBarSignalizeKeepOutAreas (copy), CoreGuiCommon (copy), Signals (copy), useSelector (copy), GuiService (copy), v11 (copy)
	if not EngineFeature then
		return
	end

	local u24 = nil
	local v25 = React.useRef({
		id = Constants.UNIBAR_KEEP_OUT_AREA_ID,
		position = Vector2.new(),
		size = Vector2.new()
	})

	if FFlagTopBarSignalizeKeepOutAreas then
		local v26 = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)

		u24 = Signals.createEffect(function(_) -- line: 63
			-- upvalues: v25 (copy), v26 (copy), Constants (copy)
			v25.current = v26.getKeepOutAreas(false)[Constants.UNIBAR_KEEP_OUT_AREA_ID]
		end)
	else
		local v27 = useSelector(function(p2) -- line: 67
			-- upvalues: Constants (copy)
			return p2.displayOptions.keepOutAreas[Constants.UNIBAR_KEEP_OUT_AREA_ID]
		end)

		React.useEffect(function() -- line: 71
			-- upvalues: v25 (copy), v27 (copy)
			v25.current = v27
		end, { v27 })
	end

	React.useEffect(function() -- line: 76
		-- upvalues: v25 (copy), GuiService (copy), v11 (copy), FFlagTopBarSignalizeKeepOutAreas (copy), u24 (ref)
		local thread = task.spawn(function() -- line: 78
			-- upvalues: v25 (copy), GuiService (copy), v11 (copy)
			while true do
				if v25.current then
					local current = v25.current
					local v32 = current.position + GuiService:GetGuiInset()
					local v33 = GuiService
					local uDim2 = UDim2.fromOffset(v32.X, v32.Y)
					local size = current.size

					v33:SendUIOcclusionMetricsForQueryRegion(uDim2, UDim2.fromOffset(size.X, size.Y), "currentSizeTR")
				end

				task.wait(v11)
			end
		end)

		return function() -- line: 87
			-- upvalues: thread (copy), FFlagTopBarSignalizeKeepOutAreas (copy), u24 (ref)
			task.cancel(thread)

			if FFlagTopBarSignalizeKeepOutAreas then
				u24()
			end
		end
	end, {})
end

return OcclusionMetricsManager
