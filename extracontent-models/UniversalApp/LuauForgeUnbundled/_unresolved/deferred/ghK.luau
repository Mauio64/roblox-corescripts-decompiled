local CorePackages = game:GetService("CorePackages")

require("@luauforge/deferred/ghD")
local module = require("@luauforge/deferred/ghL")
local module2 = require("@luauforge/deferred/ghE")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local config = LuaSocialLibrariesDeps.SocialLibraries.config({})
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local getDeepValue = config.Dictionary.getDeepValue

local getFFlagLuafiedReportThumbnail = SharedFlags.GetFFlagLuafiedReportThumbnail

return function(p2)
	return function(p3)
		if not getFFlagLuafiedReportThumbnail() then
			return {}
		end

		local v5 = nil
		local v6 = nil
		local v7 = nil

		local reportEntryPoint = p2.reportData.reportEntryPoint

		if reportEntryPoint == module2.REPORT_ENTRYPOINT.ExperienceDetails then
			local universeId = p2.reportData.universeId

			if universeId then
				local gameDetail = p3.GameDetails[universeId]
				v5 = module(universeId, reportEntryPoint)

				if gameDetail then
					v6 = gameDetail.name
				end

				if gameDetail and gameDetail.creator then
					v7 = gameDetail.creator.name
				end
			end
		end

		if reportEntryPoint == module2.REPORT_ENTRYPOINT.Profile then
			local profileUserId = p2.reportData.profileUserId

			if profileUserId then
				local deepValue = getDeepValue(
					p3,
					string.format("Profile.Users.byUserId.%s", profileUserId)
				)
				v5 = module(profileUserId, reportEntryPoint)
				v6 = if deepValue then deepValue.displayName else nil
				v7 = if deepValue then deepValue.username else nil
			end
		end

		if reportEntryPoint == module2.REPORT_ENTRYPOINT.Item then
			local reportData = p2.reportData

			v5 = module(reportData.itemId, reportEntryPoint)
			v6 = reportData.itemName
			v7 = reportData.itemCreatorName
		end

		if reportEntryPoint == module2.REPORT_ENTRYPOINT.Chat then
			local userId = p2.reportData.userId

			if userId then
				local deepValue = getDeepValue(p3, string.format("Profile.Users.byUserId.%s", userId))
				v5 = module(userId, reportEntryPoint)
				v6 = if deepValue then deepValue.displayName else nil
				v7 = if deepValue then deepValue.username else nil
			end
		end

		if v6 == nil then
			warn(reportEntryPoint, "primary text is unknown")
			v6 = ""
		end

		if v7 == nil then
			warn(reportEntryPoint, "secondary text is unknown")
			v7 = ""
		end

		if v5 == nil then
			warn(reportEntryPoint, "thumbnail url is unknown")
		end

		return { thumbnailUrl = v5, primaryText = v6, secondaryText = v7 }
	end
end
