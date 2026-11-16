local itemDetailsSduiHost = require("@luauforge/bundled/dQp").ItemDetailsSduiHost
local getAppFeaturePolicies = require("@luauforge/bundled/dQY").getAppFeaturePolicies
local appPage = require("@luauforge/bundled/dQQ").AppPage
local creatorType = require("@luauforge/bundled/dQS").Enums.CreatorType
local urlBuilder = require("@luauforge/bundled/dQZ").UrlBuilder
local navigateDown = require("@luauforge/bundled/dRa").Thunks.NavigateDown
local profileTypes = require("@luauforge/bundled/dRb").ProfileTypes
local module = require("@luauforge/bundled/dRc")
local ixpServiceWrapper = require("@luauforge/bundled/dRf").IXPServiceWrapper

local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/dPY").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dRg").NavigationCommands else nil

local fFlagFixNavigationToCreatorProfileWebviewFromProfile = require("@luauforge/bundled/dPZ").FFlagFixNavigationToCreatorProfileWebviewFromProfile

local sduiActionType = require("@luauforge/bundled/dQa").SduiActionType

local module2 = require("@luauforge/bundled/dQR")

local openCatalogItemCreatorProfile = sduiActionType.OpenCatalogItemCreatorProfile

local v5 = { User = true, Group = true }

local function isWebViewSupported()
	return getAppFeaturePolicies().getWebViewSupport()
end

local function navigateDown2(p2, callback)
	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(p2))
	else
		callback(navigateDown(p2))
	end
end

local function isCommunityProfileEnabled(p2)
	if not module.FFlagIsSetupEnabled then
		return false
	end

	if p2 then
		module.logExposure()
	end

	local enableCommunityProfilePageExperimentLayer = module.EnableCommunityProfilePageExperimentLayer
	return module.isFeatureActive({
		[enableCommunityProfilePageExperimentLayer] = ixpServiceWrapper:GetLayerData(enableCommunityProfilePageExperimentLayer) or {}
	})
end

local function SduiOpenCatalogItemCreatorProfileAction(p2, p3, p4, p5)
	local actionParams = module2.readActionParams(openCatalogItemCreatorProfile, p2, p4)

	if actionParams == nil then
		return
	end

	local requiredId = module2.readRequiredId(openCatalogItemCreatorProfile, actionParams, "creatorId", p4)

	if requiredId == nil then
		return
	end

	local creatorType2 = actionParams.creatorType

	if typeof(creatorType2) ~= "string" or not v5[creatorType2] then
		module2.reportInvalidParams(
			openCatalogItemCreatorProfile,
			p4,
			`Invalid or missing creatorType: {creatorType2}`,
			"creatorType"
		)

		return
	end

	if not getAppFeaturePolicies().getWebViewSupport() then
		module2.reportFailedToExecute(
			openCatalogItemCreatorProfile,
			p4,
			`Web views are not supported, so the profile of {creatorType2} {requiredId} cannot be opened`
		)

		return
	end

	local v6 = itemDetailsSduiHost.get(p4.configKey)
	local openCatalogItemCreatorProfile2 = if v6 then v6.openCatalogItemCreatorProfile else nil

	if openCatalogItemCreatorProfile2 == nil then
		module2.reportFailedToExecute(
			openCatalogItemCreatorProfile,
			p4,
			"No Item Details page that offers this control is mounted for this configKey"
		)

		return
	end

	local dispatch = p4.dependencies.dispatch
	local v7 = creatorType2 == creatorType.Group

	if isCommunityProfileEnabled(v7) then
		local v8 = {
			name = appPage.ProfilePlatform,
			detail = requiredId,
			extraProps = 0
		}

		local v10 = if v7 then profileTypes.Community else profileTypes.User
		v8.extraProps = { profileType = v10, source = "ItemDetailsPage" }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v8))
		else
			dispatch(navigateDown(v8))
		end
	else
		local v8

		if v7 then
			v8 = urlBuilder.user.group({ groupId = requiredId })
		else
			v8 = urlBuilder.user.profile({ userId = requiredId })
		end

		local v9 = { titleKey = "CommonUI.Features.Label.Profile" }

		if fFlagFixNavigationToCreatorProfileWebviewFromProfile then
			local v10 = { name = appPage.GenericWebPage, detail = v8, extraProps = v9 }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v10))
			else
				dispatch(navigateDown(v10))
			end
		elseif not openCatalogItemCreatorProfile2(
			{ creatorId = requiredId, creatorType = creatorType2, detail = v8 },
			dispatch
		) then
			module2.reportFailedToExecute(
				openCatalogItemCreatorProfile,
				p4,
				`The mounted Item Details page cannot open the profile of {creatorType2} {requiredId}`
			)
		end
	end
end

return SduiOpenCatalogItemCreatorProfileAction
