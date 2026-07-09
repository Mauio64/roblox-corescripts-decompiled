local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.SetResultsListFocusedWidget)
local ClearResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.ClearResultsListFocusedWidget)
local ClearAllResultsListFocusedWidgets = require(Modules.AvatarExperience.Catalog.Actions.ClearAllResultsListFocusedWidgets)
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local AXCatalogPerfReduxReductionIXP = require(Modules.AvatarExperience.Experiments.AXCatalogPerfReduxReductionIXP)

return Rodux.createReducer({}, {
	[SetResultsListFocusedWidget.name] = function(p1, p2) -- line: 50
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.searchUuid] = {
				hideTopBar = true,
				focusedWidget = {
					active = true,
					id = p2.id,
					title = p2.title or "",
					description = p2.description or "",
					localizedTitle = p2.localizedTitle or "",
					localizedDescription = p2.localizedDescription or "",
					localizedTooltip = p2.localizedTooltip or "",
					tooltip = p2.tooltip or ""
				}
			}
		})
	end,
	[ClearResultsListFocusedWidget.name] = function(p3, p4) -- line: 67
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.searchUuid] = {}
		})
	end,
	[ClearAllResultsListFocusedWidgets.name] = function(_, _) -- line: 72
		return {}
	end,
	[CatalogTilesLatencyTracker.PercievedTrackingStarted.name] = function(t1: {[any]: any}, p7) -- line: 75
		-- upvalues: Cryo (copy)
		return (Cryo.Dictionary.join(t1, {
			perceivedStartTime = p7.startPerceivedTime
		}))
	end,
	[CatalogTilesLatencyTracker.StartTracking.name] = function(t2: {[any]: any}, p8) -- line: 81
		-- upvalues: GetFFlagEnableCatalogTileLoadingLatency (copy), Cryo (copy)
		if not GetFFlagEnableCatalogTileLoadingLatency() then
			return t2
		end

		local searchUuid = p8.searchUuid
		local v23 = t2[searchUuid] or {}
		local v24 = v23 and v23.tileLoadingLatency or {}
		local v25 = Cryo.Dictionary.join(t2, {
			[searchUuid] = Cryo.Dictionary.join(v23, {
				tileLoadingLatency = Cryo.Dictionary.join(v24, {
					startTime = p8.startTime
				})
			})
		})

		v25[searchUuid].tileLoadingLatency.endTime = nil

		return v25
	end,
	[CatalogTilesLatencyTracker.EndTracking.name] = function(t3: {[any]: any}, p9) -- line: 98
		-- upvalues: GetFFlagEnableCatalogTileLoadingLatency (copy), Cryo (copy)
		if not GetFFlagEnableCatalogTileLoadingLatency() then
			return t3
		end

		local searchUuid = p9.searchUuid
		local v29 = t3[searchUuid] or {}

		return (Cryo.Dictionary.join(t3, {
			[searchUuid] = Cryo.Dictionary.join(v29, {
				tileLoadingLatency = Cryo.Dictionary.join(v29 and v29.tileLoadingLatency or {}, {
					endTime = p9.endTime
				})
			}),
			perceivedStartTime = Cryo.None
		}))
	end,
	[CatalogTilesLatencyTracker.AppendThumbnails.name] = if not AXCatalogPerfReduxReductionIXP.isEnabled() then nil else function(t4: {[any]: any}, p10) -- line: 116
		local thumbnailsMap = p10.thumbnailsMap

		if not thumbnailsMap then
			return t4
		end

		local v33 = table.clone(t4)

		for v34, v35 in thumbnailsMap do
			local v36 = table.clone(v33[v34] or {})
			local v37 = table.clone(v36.tileLoadingLatency or {})
			local v38 = table.clone(v37.thumbnails or {})

			for _, v40 in v35 do
				v38[v40] = v38[v40] or false
			end

			v37.thumbnails = v38
			v36.tileLoadingLatency = v37
			v33[v34] = v36
		end

		return v33
	end,
	[CatalogTilesLatencyTracker.AppendThumbnail.name] = function(t5: {[any]: any}, p11) -- line: 139
		-- upvalues: GetFFlagEnableCatalogTileLoadingLatency (copy), Cryo (copy)
		if not GetFFlagEnableCatalogTileLoadingLatency() then
			return t5
		end

		local searchUuid = p11.searchUuid
		local v44 = t5[searchUuid] or {}
		local v45 = v44 and v44.tileLoadingLatency or {}
		local v46 = v45 and v45.thumbnails or {}

		v45.thumbnails = Cryo.Dictionary.join(v46, {
			[p11.thumbnailId] = false
		})

		return Cryo.Dictionary.join(t5, {
			[searchUuid] = Cryo.Dictionary.join(v44, {
				tileLoadingLatency = v45
			})
		})
	end,
	[CatalogTilesLatencyTracker.SetLoadedThumbnails.name] = if not AXCatalogPerfReduxReductionIXP.isEnabled() then nil else function(t6: {[any]: any}, p12) -- line: 158
		local searchUuid = p12.searchUuid
		local v50 = table.clone(t6 or {})
		local v51 = table.clone(v50[searchUuid] or {})
		local v52 = table.clone(v51.tileLoadingLatency or {})
		local v53 = v51.tileLoadingLatency and (not not v51.tileLoadingLatency.thumbnails and table.clone(v51.tileLoadingLatency.thumbnails)) or {}

		if p12.thumbnailIds then
			for _, v55 in p12.thumbnailIds do
				v53[v55] = true
			end
		end

		v52.thumbnails = v53
		v51.tileLoadingLatency = v52
		v50[searchUuid] = v51

		return v50
	end,
	[CatalogTilesLatencyTracker.SetLoadedThumbnail.name] = function(t7: {[any]: any}, p13) -- line: 181
		-- upvalues: GetFFlagEnableCatalogTileLoadingLatency (copy), Cryo (copy)
		if not GetFFlagEnableCatalogTileLoadingLatency() then
			return t7
		end

		local v58 = t7[p13.searchUuid] or {}
		local v59 = v58 and v58.tileLoadingLatency or {}

		v59.thumbnails = Cryo.Dictionary.join(v59.thumbnails or {}, {
			[p13.thumbnailId] = true
		})

		return Cryo.Dictionary.join(t7, {
			[p13.searchUuid] = Cryo.Dictionary.join(v58, {
				tileLoadingLatency = v59
			})
		})
	end
})
