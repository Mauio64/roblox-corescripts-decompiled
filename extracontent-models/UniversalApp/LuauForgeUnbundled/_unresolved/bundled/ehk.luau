local module = require("@luauforge/bundled/dzO")
local module2 = require("@luauforge/bundled/ehl")
local module3 = require("@luauforge/bundled/ehm")
local module4 = require("@luauforge/bundled/ecs")

local module5 = require("@luauforge/bundled/ehn")
local module6 = require("@luauforge/bundled/ehy")

local module7 = require("@luauforge/bundled/ehz")
local v5 = module5()

if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDeprecatePeopleListContextualMenu then
	return nil
end

return function(data)
	return function(object)
		module.isType(data.user, "table", "props.user passed down to OpenCentralOverlayForPeopleList")
		module.isType(
			data.positionIndex,
			"number",
			"props.positionIndex passed down to OpenCentralOverlayForPeopleList"
		)

		module.isType(
			data.onOpen,
			"function",
			"props.onOpen passed down to OpenCentralOverlayForPeopleList"
		)
		module.isType(
			data.onClose,
			"function",
			"props.onClose passed down to OpenCentralOverlayForPeopleList"
		)
		module.isType(
			data.anchorSpaceSize,
			"Vector2",
			"props.anchorSpaceSize passed down to OpenCentralOverlayForPeopleList"
		)

		module.isType(
			data.anchorSpacePosition,
			"Vector2",
			"props.anchorSpacePosition passed down to OpenCentralOverlayForPeopleList"
		)

		module.isType(
			data.absolutePosition,
			"number",
			"props.absolutePosition passed down to OpenCentralOverlayForPeopleList"
		)

		module7.Stopwatch.start(module7.Events.JoinGameCardOpened)
		local v6 = if data.mockProfileAnalytics_dev then data.mockProfileAnalytics_dev else v5

		v6.fireAnalyticsEvent(module6.ProfileInExperienceUserLoadingStage, {
			status = module4.Analytics.Enums.LoadingStages.Started,
			statValue = 0
		})

		object:dispatch(module3(module2.PeopleList, data))
	end
end
