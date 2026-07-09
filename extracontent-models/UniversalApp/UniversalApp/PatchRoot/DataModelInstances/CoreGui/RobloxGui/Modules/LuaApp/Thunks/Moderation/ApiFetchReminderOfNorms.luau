local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local Promise = require(Modules.LuaApp.Promise)
local GetReminderOfNorms = require(Modules.LuaApp.Http.Requests.ModerationAPI.GetReminderOfNorms)
local EventIngestService = game:GetService("EventIngestService")
local v8 = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest.new(EventIngestService)
local v9 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local v10 = game:DefineFastFlag("ReminderAPIFetchErrorLogging", false)

function VerifyReminderOfNormsResponse(p1) -- line: 17
	local contentVariant = p1.contentVariant

	if not contentVariant or contentVariant ~= "positive" and contentVariant ~= "warning" then
		return false
	end

	if not p1.policyViolation or not p1.interventionId or not p1.reminderNumber or not p1.experimentVariant then
		return false
	end

	return true
end

return function(p2) -- line: 33
	-- upvalues: GetReminderOfNorms (copy), Promise (copy), SetCentralOverlay (copy), OverlayType (copy), v8 (copy), v10 (copy), v9 (copy)
	return function(p3) -- line: 34
		-- upvalues: GetReminderOfNorms (copy), p2 (copy), Promise (copy), SetCentralOverlay (copy), OverlayType (copy), v8 (copy), v10 (copy), v9 (copy)
		return GetReminderOfNorms(p2):andThen(function(p4) -- line: 35
			-- upvalues: Promise (copy), p3 (copy), SetCentralOverlay (copy), OverlayType (copy), v8 (copy)
			local responseBody = p4.responseBody

			if not responseBody or not responseBody.shouldSurfaceReminder then
				return Promise.resolve()
			end

			if not VerifyReminderOfNormsResponse(responseBody) then
				return Promise.reject(nil, responseBody)
			end

			p3:dispatch(SetCentralOverlay(OverlayType.ReminderOfNormsPopup, {
				interventionId = responseBody.interventionId,
				contentVariant = responseBody.contentVariant,
				policyViolation = responseBody.policyViolation,
				reminderNumber = responseBody.reminderNumber,
				experimentVariant = responseBody.experimentVariant,
				eventIngest = v8
			}))

			return Promise.resolve()
		end):catch(function(p5) -- line: 55
			-- upvalues: v10 (copy), v9 (copy)
			if v10 then
				v9:warning("(Moderation) Failed to fetch reminder {}", p5)
			end
		end)
	end
end
