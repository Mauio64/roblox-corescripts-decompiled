local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

require(InGameAssetReporting.InGameAssetReportUI.Resources.Types)
local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)

local AnalyticsActions = Constants.AnalyticsActions

local function analyticsReducer(p, data)
	local clone = table.clone(p)
	local kind = data.type

	if kind == AnalyticsActions.SetPlaceId then
		clone.place_id = data.place_id
		return clone
	end

	if kind == AnalyticsActions.AccumulateForTimeSpent then
		clone.accumulated_time_ms = data.accumulated_time_ms
		return clone
	end

	if kind == AnalyticsActions.SetReasonSelection then
		clone.reason_selection = data.reason_selection
		return clone
	end

	if kind == AnalyticsActions.SetSurfaceSelection then
		clone.surface_selection = data.surface_selection
		return clone
	end

	if kind == AnalyticsActions.SetPrefilledSurfaceSelection then
		clone.prefilled_surface_selection = data.prefilled_surface_selection
		return clone
	end

	if kind == AnalyticsActions.SetCommentAdded then
		clone.comment_added = data.comment_added
		return clone
	end

	if kind == AnalyticsActions.IncrementNextCount then
		clone.next_count += 1
		return clone
	end

	if kind == AnalyticsActions.IncremementAnnotationCount then
		clone.annotation_place_count += 1
		return clone
	end

	if kind == AnalyticsActions.IncremementAnnotationUndoCount then
		clone.annotation_undo_count += 1
		return clone
	end

	if kind == AnalyticsActions.IncremementAnnotationRedoCount then
		clone.annotation_redo_count += 1
		return clone
	end

	if kind == AnalyticsActions.SetExtractionResults then
		local results = data.results

		clone.annotation_final_count = data.final_annotation_count
		clone.avatar_final_count = results.stats.playersCount
		clone.image_asset_count = #results.extractedAssets.Image
		clone.mesh_asset_count = #results.extractedAssets.Mesh
		clone.model_asset_count = #results.extractedAssets.Model
		clone.package_asset_count = #results.extractedAssets.Package
		clone.final_raycast_target_count = results.stats.raycastTargetCount
		clone.final_raycast_completed_count = results.stats.raycastCompletedCount
		clone.final_raycast_resumption_count = results.stats.raycastResumptionCount
		clone.final_raycast_computation_time_us = math.ceil(results.stats.raycastComputeTime * 1000000)
		clone.hit_count_map_size = results.stats.hitCountMapSize
		clone.top_level_objects_size = results.stats.topLevelObjectsSize
		clone.instances_traversed_count = results.stats.instancesTraversed
		clone.traversal_task_list_size = results.stats.traversalTaskListSize
		clone.traversal_tasks_completed_count = results.stats.traversalTasksCompleted
		clone.extraction_resumption_count = results.stats.resumptionCount
		clone.extraction_computation_time_us = math.ceil(results.stats.computeTime * 1000000)
		clone.extraction_wall_time_us = math.ceil(results.stats.wallTime * 1000000)
		return clone
	end

	if kind == AnalyticsActions.SetViewportInformation then
		clone.viewport_size_x = data.viewport_size_x
		clone.viewport_size_y = data.viewport_size_y
		clone.is_portrait_mode = data.is_portrait_mode
	else
		if kind == AnalyticsActions.SetDidUserResize then
			clone.did_user_resize = data.did_user_resize
			return clone
		end

		if kind == AnalyticsActions.SetVariant then
			clone.variant = data.variant
		end
	end

	return clone
end

return analyticsReducer
