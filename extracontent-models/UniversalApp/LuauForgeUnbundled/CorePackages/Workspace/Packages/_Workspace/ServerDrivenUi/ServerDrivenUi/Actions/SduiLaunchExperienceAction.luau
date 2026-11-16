local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local launchGame = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameLaunch").LaunchGame
local fFlagDeferInExperienceRbxmDownload = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagDeferInExperienceRbxmDownload
local SduiSharedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent")
local fFlagLuaAppFixLaunchGameSourceParam = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppFixLaunchGameSourceParam

local fFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch
local sduiReportGamePlayIntent = SduiSharedContent.sduiReportGamePlayIntent
local launchUnlessNotPlayable = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GamePlayButton").LaunchUnlessNotPlayable

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local executeAction = SduiCoreSystem.executeAction

local launchExperience = sduiActionType.LaunchExperience

local function launchExperience2(placeId, universeId, launchSource, p2, p3, p4)
	sduiReportGamePlayIntent({
		sduiContext = p4,
		analyticsContext = p3,
		universeId = tostring(universeId or ""),
		placeId = placeId
	})

	if fFlagLuaAppFixLaunchGameSourceParam then
		launchGame(placeId, nil, p2, nil, launchSource)
	else
		launchGame(placeId, launchSource, p2, nil)
	end
end

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = launchExperience, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local placeId = actionParams.placeId

	if placeId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = launchExperience,
				message = "Missing placeId",
				propName = "placeId"
			},
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId
	local launchSource = actionParams.launchSource
	local v5 = actionParams.experienceJoinData

	if fFlagDeferInExperienceRbxmDownload then
		v5 = Cryo.Dictionary.join(v5 or {}, { universeId = universeId })
	end

	if fFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch then
		if actionParams.checkPlayabilityBeforeLaunch == true then
			local function launch()
				launchExperience2(placeId, universeId, launchSource, v5, p3, p4)
			end

			if universeId == nil then
				p4.dependencies.logger.reportError(
					sduiErrorType.InvalidActionParams,
					{
						name = launchExperience,
						message = "Missing universeId for checkPlayabilityBeforeLaunch",
						propName = "universeId"
					},
					p4.appPage
				)
				launchExperience2(placeId, universeId, launchSource, v5, p3, p4)
			else
				local dependencies = p4.dependencies

				if dependencies.networking == nil then
					dependencies.logger.reportError(
						sduiErrorType.GetNilDependencies,
						{
							name = launchExperience,
							message = "checkPlayabilityBeforeLaunch requires networking dependency"
						},
						p4.appPage
					)
					launchExperience2(placeId, universeId, launchSource, v5, p3, p4)
				else
					local function openGameDetails()
						executeAction(
							{
								actionType = sduiActionType.OpenGameDetails,
								actionParams = actionParams
							},
							p3,
							p4
						)
					end

					dependencies.dispatch(launchUnlessNotPlayable(
						dependencies.networking,
						tostring(universeId),
						launch,
						openGameDetails
					))
				end
			end
		else
			launchExperience2(placeId, universeId, launchSource, v5, p3, p4)
		end
	else
		sduiReportGamePlayIntent({
			sduiContext = p4,
			analyticsContext = p3,
			universeId = tostring(universeId or ""),
			placeId = placeId
		})

		if fFlagLuaAppFixLaunchGameSourceParam then
			launchGame(placeId, nil, v5, nil, launchSource)
		else
			launchGame(placeId, launchSource, v5, nil)
		end
	end
end
