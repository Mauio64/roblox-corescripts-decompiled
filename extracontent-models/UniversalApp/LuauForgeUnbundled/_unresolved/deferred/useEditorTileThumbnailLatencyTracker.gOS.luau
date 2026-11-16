local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(CorePackages.Packages.Signals)

require("@luauforge/bundled/fuM")
local module = require("@luauforge/bundled/ggZ")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local editorInventoryTTIMilestoneManager = module.EditorInventoryTTIMilestoneManager

local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore

local function useEditorTileThumbnailLatencyTracker(data)
	local v5 = React.useMemo(function()
		return {
			getAnyLoaded = Signals.createSignal(false),
			getStartTime = Signals.createSignal(nil),
			getEndTime = Signals.createSignal(nil)
		}
	end, {})

	local getAnyLoaded = if data then data.getAnyLoaded else v5.getAnyLoaded
	local getStartTime = if data then data.getStartTime else v5.getStartTime
	local getEndTime = if data then data.getEndTime else v5.getEndTime

	local v6 = useSignalState(getAnyLoaded)
	local v7 = useSignalState(getStartTime)
	local v8 = useSignalState(getEndTime)

	React.useEffect(function()
		if not (fFlagAXEditorEnableThumbnailLatencyStore and data ~= nil and v6 and v7 ~= nil) then
			return
		end

		if v8 ~= nil then
			return
		end

		editorInventoryTTIMilestoneManager.L2.surfaceReady()
		data.endTracking()
		editorInventoryTTIMilestoneManager.endThumbnailsTracking()
	end, { data, v6, v7, v8 })
end

return useEditorTileThumbnailLatencyTracker
