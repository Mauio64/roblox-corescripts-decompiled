local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

require(InGameAssetReporting.InGameAssetReportUI.Resources.Types)

local AnalyticsActions = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants).AnalyticsActions

local function analyticsReducer(p1, p2) -- line: 8
	-- upvalues: AnalyticsActions (copy)
	local v6 = table.clone(p1)
	local type = p2.type

	if type == AnalyticsActions.SetPlaceId then
		v6.place_id = p2.place_id

		return v6
	end

	if type == AnalyticsActions.AccumulateForTimeSpent then
		v6.accumulated_time_ms = p2.accumulated_time_ms

		return v6
	end

	if type == AnalyticsActions.SetReasonSelection then
		v6.reason_selection = p2.reason_selection

		return v6
	end

	if type == AnalyticsActions.SetSurfaceSelection then
		v6.surface_selection = p2.surface_selection

		return v6
	end

	if type == AnalyticsActions.SetPrefilledSurfaceSelection then
		v6.prefilled_surface_selection = p2.prefilled_surface_selection

		return v6
	end

	if type == AnalyticsActions.SetCommentAdded then
		v6.comment_added = p2.comment_added

		return v6
	end

	if type == AnalyticsActions.IncrementNextCount then
		v6.next_count = v6.next_count + 1

		return v6
	end

	if type == AnalyticsActions.IncremementAnnotationCount then
		v6.annotation_place_count = v6.annotation_place_count + 1

		return v6
	end

	if type == AnalyticsActions.IncremementAnnotationUndoCount then
		v6.annotation_undo_count = v6.annotation_undo_count + 1

		return v6
	end

	if type == AnalyticsActions.IncremementAnnotationRedoCount then
		v6.annotation_redo_count = v6.annotation_redo_count + 1

		return v6
	end

	if type == AnalyticsActions.SetExtractionResults then
		local results = p2.results

		v6.annotation_final_count = p2.final_annotation_count
		v6.avatar_final_count = results.stats.playersCount
		v6.image_asset_count = #results.extractedAssets.Image
		v6.mesh_asset_count = #results.extractedAssets.Mesh
		v6.model_asset_count = #results.extractedAssets.Model
		v6.package_asset_count = #results.extractedAssets.Package
		v6.final_raycast_target_count = results.stats.raycastTargetCount
		v6.final_raycast_completed_count = results.stats.raycastCompletedCount
		v6.final_raycast_resumption_count = results.stats.raycastResumptionCount
		v6.final_raycast_computation_time_us = math.ceil(results.stats.raycastComputeTime * 1000000)
		v6.hit_count_map_size = results.stats.hitCountMapSize
		v6.top_level_objects_size = results.stats.topLevelObjectsSize
		v6.instances_traversed_count = results.stats.instancesTraversed
		v6.traversal_task_list_size = results.stats.traversalTaskListSize
		v6.traversal_tasks_completed_count = results.stats.traversalTasksCompleted
		v6.extraction_resumption_count = results.stats.resumptionCount
		v6.extraction_computation_time_us = math.ceil(results.stats.computeTime * 1000000)
		v6.extraction_wall_time_us = math.ceil(results.stats.wallTime * 1000000)

		return v6
	end

	if type == AnalyticsActions.SetViewportInformation then
		v6.viewport_size_x = p2.viewport_size_x
		v6.viewport_size_y = p2.viewport_size_y
		v6.is_portrait_mode = p2.is_portrait_mode

		return v6
	end

	if type == AnalyticsActions.SetDidUserResize then
		v6.did_user_resize = p2.did_user_resize

		return v6
	end

	if type == AnalyticsActions.SetVariant then
		v6.variant = p2.variant
	end

	return v6
end

return analyticsReducer
