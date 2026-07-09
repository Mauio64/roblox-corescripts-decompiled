local AvatarExperienceTTIPerformanceManager = require(script.AvatarExperienceTTIPerformanceManager)
local TTIMetricNames = require(script.TTIMetricNames)
local WidgetsPercievedTTIManager = require(script.WidgetsPercievedTTIManager)
local OrganicTTIMilestoneManager = require(script.OrganicTTIMilestoneManager)
local EditorInventoryTTIMilestoneManager = require(script.EditorInventoryTTIMilestoneManager)

return {
	TTIPerformanceManager = AvatarExperienceTTIPerformanceManager,
	TTIMetricNames = TTIMetricNames,
	WidgetsPercievedTTIManager = WidgetsPercievedTTIManager,
	OrganicTTIMilestoneManager = OrganicTTIMilestoneManager,
	EditorInventoryTTIMilestoneManager = EditorInventoryTTIMilestoneManager,
	["jest.config"] = script["jest.config"]
}
