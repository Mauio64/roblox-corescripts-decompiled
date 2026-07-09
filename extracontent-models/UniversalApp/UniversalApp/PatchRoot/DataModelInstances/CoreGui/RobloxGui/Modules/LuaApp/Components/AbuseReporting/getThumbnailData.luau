local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.LuaApp.Components.AbuseReporting.ReportTypes)

local getThumbnailUrl = require(Modules.LuaApp.Components.AbuseReporting.getThumbnailUrl)
local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)
local v5 = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({})
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getDeepValue = v5.Dictionary.getDeepValue
local GetFFlagLuafiedReportThumbnail = SharedFlags.GetFFlagLuafiedReportThumbnail

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: GetFFlagLuafiedReportThumbnail (copy), Constants (copy), getThumbnailUrl (copy), getDeepValue (copy)
	return function(p1) -- line: 14
		-- upvalues: GetFFlagLuafiedReportThumbnail (copy), t1 (copy), Constants (copy), getThumbnailUrl (copy), getDeepValue (copy)
		if not GetFFlagLuafiedReportThumbnail() then
			return {}
		end

		local v11 = nil
		local v12 = nil
		local v13 = nil
		local reportEntryPoint = t1.reportData.reportEntryPoint

		if reportEntryPoint == Constants.REPORT_ENTRYPOINT.ExperienceDetails then
			local universeId = t1.reportData.universeId

			if universeId then
				local v16 = p1.GameDetails[universeId]

				v11 = getThumbnailUrl(universeId, reportEntryPoint)
				v12 = if not v16 then nil else v16.name
				v13 = if not v16 or not v16.creator then nil else v16.creator.name
			end
		end

		if reportEntryPoint == Constants.REPORT_ENTRYPOINT.Profile then
			local profileUserId = t1.reportData.profileUserId

			if profileUserId then
				local v18 = getDeepValue(p1, string.format("Profile.Users.byUserId.%s", profileUserId))

				v11 = getThumbnailUrl(profileUserId, reportEntryPoint)
				v12 = if not v18 then nil else v18.displayName
				v13 = if not v18 then nil else v18.username
			end
		end

		if reportEntryPoint == Constants.REPORT_ENTRYPOINT.Item then
			local reportData = t1.reportData

			v11 = getThumbnailUrl(reportData.itemId, reportEntryPoint)
			v12 = reportData.itemName
			v13 = reportData.itemCreatorName
		end

		if reportEntryPoint == Constants.REPORT_ENTRYPOINT.Chat then
			local userId = t1.reportData.userId

			if userId then
				local v21 = getDeepValue(p1, string.format("Profile.Users.byUserId.%s", userId))

				v11 = getThumbnailUrl(userId, reportEntryPoint)
				v12 = if not v21 then nil else v21.displayName
				v13 = if not v21 then nil else v21.username
			end
		end

		if v12 == nil then
			v12 = ""
			warn(reportEntryPoint, "primary text is unknown")
		end

		if v13 == nil then
			v13 = ""
			warn(reportEntryPoint, "secondary text is unknown")
		end

		if v11 == nil then
			warn(reportEntryPoint, "thumbnail url is unknown")
		end

		return {
			thumbnailUrl = v11,
			primaryText = v12,
			secondaryText = v13
		}
	end
end
