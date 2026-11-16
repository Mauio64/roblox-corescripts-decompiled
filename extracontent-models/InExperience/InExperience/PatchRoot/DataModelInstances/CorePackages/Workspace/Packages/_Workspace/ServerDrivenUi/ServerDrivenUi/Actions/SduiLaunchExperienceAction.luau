local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Cryo = require(parent.Cryo)
local GameLaunch = require(parent.GameLaunch)
local LaunchGame = GameLaunch.LaunchGame
local SharedFlags = require(parent.SharedFlags)
local FFlagDeferInExperienceRbxmDownload = SharedFlags.FFlagDeferInExperienceRbxmDownload
local SduiSharedContent = require(parent.SduiSharedContent)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppFixLaunchGameSourceParam = SharedFlags2.FFlagLuaAppFixLaunchGameSourceParam

local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch = SharedFlags3.FFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch
local sduiReportGamePlayIntent = SduiSharedContent.sduiReportGamePlayIntent
local GamePlayButton = require(parent.GamePlayButton)
local LaunchUnlessNotPlayable = GamePlayButton.LaunchUnlessNotPlayable

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local executeAction = SduiCoreSystem.executeAction

local LaunchExperience = SduiActionType.LaunchExperience

local function launchExperience(placeId: string, universeId: string?, launchSource: string?, p, analyticsContext, sduiContext)
	sduiReportGamePlayIntent({
		sduiContext = sduiContext,
		analyticsContext = analyticsContext,
		universeId = tostring(universeId or ""),
		placeId = placeId
	})

	if FFlagLuaAppFixLaunchGameSourceParam then
		LaunchGame(placeId, nil, p, nil, launchSource)
	else
		LaunchGame(placeId, launchSource, p, nil)
	end
end

return function(p, analyticsContext, sduiContext, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		sduiContext.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = LaunchExperience, message = "Missing actionParams" },
			sduiContext.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local placeId = actionParams.placeId

	if placeId == nil then
		sduiContext.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = LaunchExperience, message = "Missing placeId", propName = "placeId" },
			sduiContext.appPage
		)
		return
	end

	local universeId = actionParams.universeId
	local launchSource = actionParams.launchSource
	local v = actionParams.experienceJoinData

	if FFlagDeferInExperienceRbxmDownload then
		v = Cryo.Dictionary.join(v or {}, { universeId = universeId })
	end

	if FFlagSduiLaunchExperienceCheckPlayabilityBeforeLaunch then
		if actionParams.checkPlayabilityBeforeLaunch == true then
			local function launch() -- 2 equivalent calls inferred from this helper
				launchExperience(placeId, universeId, launchSource, v, analyticsContext, sduiContext)
			end

			if universeId == nil then
				sduiContext.dependencies.logger.reportError(
					SduiErrorType.InvalidActionParams,
					{
						name = LaunchExperience,
						message = "Missing universeId for checkPlayabilityBeforeLaunch",
						propName = "universeId"
					},
					sduiContext.appPage
				)
				launch() -- inferred equivalent call
			else
				local dependencies = sduiContext.dependencies

				if dependencies.networking == nil then
					dependencies.logger.reportError(
						SduiErrorType.GetNilDependencies,
						{
							name = LaunchExperience,
							message = "checkPlayabilityBeforeLaunch requires networking dependency"
						},
						sduiContext.appPage
					)
					launch() -- inferred equivalent call
				else
					local function openGameDetails()
						executeAction(
							{
								actionType = SduiActionType.OpenGameDetails,
								actionParams = actionParams
							},
							analyticsContext,
							sduiContext
						)
					end

					dependencies.dispatch(LaunchUnlessNotPlayable(
						dependencies.networking,
						tostring(universeId),
						launch,
						openGameDetails
					))
				end
			end
		else
			launchExperience(placeId, universeId, launchSource, v, analyticsContext, sduiContext)
		end
	else
		sduiReportGamePlayIntent({
			sduiContext = sduiContext,
			analyticsContext = analyticsContext,
			universeId = tostring(universeId or ""),
			placeId = placeId
		})

		if FFlagLuaAppFixLaunchGameSourceParam then
			LaunchGame(placeId, nil, v, nil, launchSource)
		else
			LaunchGame(placeId, launchSource, v, nil)
		end
	end
end
