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

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local fIntLuaUIOcclusionMetricsReportingPeriodSeconds = SharedFlags.GetFIntLuaUIOcclusionMetricsReportingPeriodSeconds()

local engineFeature = game:GetEngineFeature("GuiServiceSendUIOcclusionMetricsForQueryRegion")

local function convertCoreUIPointToHardwareSafeAreaPoint(position: Vector2) -- 1 equivalent call inferred from this helper
	return position + GuiService:GetGuiInset()
end

local function vector2ToUDim2(vector2: Vector2) -- 2 equivalent calls inferred from this helper
	return UDim2.fromOffset(vector2.X, vector2.Y)
end

local function reportOcclusionMetrics(current) -- 1 equivalent call inferred from this helper
	GuiService:SendUIOcclusionMetricsForQueryRegion(
		vector2ToUDim2(convertCoreUIPointToHardwareSafeAreaPoint(current.position)), -- inferred equivalent call
		vector2ToUDim2(current.size), -- inferred equivalent call
		"currentSizeTR"
	)
end

local function OcclusionMetricsManager()
	if not engineFeature then
		return
	end

	local v = nil

	local ref = React.useRef({
		id = Constants.UNIBAR_KEEP_OUT_AREA_ID,
		position = Vector2.new(),
		size = Vector2.new()
	})

	if FFlagTopBarSignalizeKeepOutAreas then
		local keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)

		v = Signals.createEffect(function(_)
			ref.current = keepOutAreasStore.getKeepOutAreas(false)[Constants.UNIBAR_KEEP_OUT_AREA_ID]
		end)
	else
		local current = useSelector(function(p)
			return p.displayOptions.keepOutAreas[Constants.UNIBAR_KEEP_OUT_AREA_ID]
		end)

		React.useEffect(function()
			ref.current = current
		end, { current })
	end

	React.useEffect(function()
		local thread = task.spawn(function()
			while true do
				if ref.current then
					reportOcclusionMetrics(ref.current) -- inferred equivalent call
				end

				task.wait(fIntLuaUIOcclusionMetricsReportingPeriodSeconds)
			end
		end)

		return function()
			task.cancel(thread)

			if FFlagTopBarSignalizeKeepOutAreas then
				v()
			end
		end
	end, {})
end

return OcclusionMetricsManager
