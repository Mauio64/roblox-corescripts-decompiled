local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiPageAnalytics = SduiSharedUtilities.SduiPageAnalytics
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local FFlagSduiChartsSupport = require(Parent.SharedFlags).FFlagSduiChartsSupport

return function(p1, _, p3) -- line: 20
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), SduiPageAnalytics (copy), SduiLoadTimer (copy), getSduiApiStore (copy), FFlagSduiChartsSupport (copy)
	local v13 = p1 and p1.actionParams or nil

	if v13 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.LoadMoreFromApi
		}, p3.appPage)

		return
	end

	assert(v13, "actionParams must exist")

	local configKey = v13.configKey

	if typeof(configKey) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "configKey",
			name = SduiActionType.LoadMoreFromApi,
			message = `Invalid or missing configKey: { configKey }`
		}, p3.appPage)

		return
	end

	local surfaceKey = v13.surfaceKey

	if typeof(surfaceKey) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "surfaceKey",
			name = SduiActionType.LoadMoreFromApi,
			message = `Invalid or missing surfaceKey: { surfaceKey }`
		}, p3.appPage)

		return
	end

	SduiPageAnalytics.sendLoadMoreEvent(surfaceKey)

	local v16 = SduiLoadTimer.createLoadTimer(surfaceKey)

	v16.start("loadMore")

	local v17 = getSduiApiStore().loadMoreFromApi({
		configKey = configKey,
		loadTimer = v16
	})

	if FFlagSduiChartsSupport then
		v17:finally(function() -- line: 64
			-- upvalues: v16 (copy)
			v16.logRefreshComplete()
		end)
	end
end
