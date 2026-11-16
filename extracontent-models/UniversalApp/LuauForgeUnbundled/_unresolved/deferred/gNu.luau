local HttpService = game:GetService("HttpService")

local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local sessionType = require("@luauforge/bundled/foF").SessionType
local module = require("@luauforge/bundled/eeH")
local module2 = require("@luauforge/bundled/dCn")

local defineFastFlag = game:DefineFastFlag("UseOpaqueNameForSessionChange", false)
local defineFastFlag2 = game:DefineFastFlag("MuteSessionServiceErrorUWP", false)
local defineFastFlag3 = game:DefineFastFlag("AXCustomizeSessions3", false)

local v5 = {
	MARKETPLACE_HOMEPAGE_SESSION = "AvatarExperienceMarketplaceHomepageSession",
	SEARCH_SESSION = "AvatarExperienceSearchSession",
	CUSTOMIZE_SESSION = defineFastFlag3 and "AvatarExperienceCustomizeSession" or nil
}

local v6 = {
	CATALOG_REQUEST_ID = "avatarCatalogRequestId",
	SEARCH_REQUEST_ID = "avatarSearchRequestId",
	CUSTOMIZE_REQUEST_ID = defineFastFlag3 and "avatarCustomizeRequestId" or nil
}

local function clearSession(object, p2)
	if object:SessionExists(p2) then
		object:RemoveSession(p2)
	end
end

local function setSession(object, p2, p3)
	if not object:SessionExists(p2) then
		object:SetSession(sessionType.StructuralIdentifier.Level2a, p2, p2)
		object:SetMetadata(p2, p3, HttpService:GenerateGUID(true))
	end
end

local function processSessionChange(object, p2)
	local name = if defineFastFlag then p2.opaque.name else p2.current.name

	if name == avatarScreen.CatalogSearch then
		local MARKETPLACE_HOMEPAGE_SESSION = v5.MARKETPLACE_HOMEPAGE_SESSION

		if object:SessionExists(MARKETPLACE_HOMEPAGE_SESSION) then
			object:RemoveSession(MARKETPLACE_HOMEPAGE_SESSION)
		end

		if defineFastFlag3 then
			local CUSTOMIZE_SESSION = v5.CUSTOMIZE_SESSION

			if object:SessionExists(CUSTOMIZE_SESSION) then
				object:RemoveSession(CUSTOMIZE_SESSION)
			end
		end

		local SEARCH_SESSION = v5.SEARCH_SESSION
		local SEARCH_REQUEST_ID = v6.SEARCH_REQUEST_ID

		if not object:SessionExists(SEARCH_SESSION) then
			object:SetSession(sessionType.StructuralIdentifier.Level2a, SEARCH_SESSION, SEARCH_SESSION)
			object:SetMetadata(SEARCH_SESSION, SEARCH_REQUEST_ID, HttpService:GenerateGUID(true))
		end
	elseif
		defineFastFlag3
		and (name == avatarScreen.AvatarEditor or name == avatarScreen.AvatarSwitcher or name == avatarScreen.EditEmotes or name == avatarScreen.AccessoryAdjustment or name == avatarScreen.BodyShape or name == avatarScreen.HeadRefinement or name == avatarScreen.LayeredClothingSort or name == avatarScreen.ColorAdjustment or name == avatarScreen.MySharedAvatars or name == avatarScreen.LookComposerPage or name == avatarScreen.ProfilePictureEditorEmotes or name == avatarScreen.ProfilePictureEditorCamera or name == avatarScreen.ProfilePictureEditorFinal)
	then
		local MARKETPLACE_HOMEPAGE_SESSION = v5.MARKETPLACE_HOMEPAGE_SESSION

		if object:SessionExists(MARKETPLACE_HOMEPAGE_SESSION) then
			object:RemoveSession(MARKETPLACE_HOMEPAGE_SESSION)
		end

		local SEARCH_SESSION = v5.SEARCH_SESSION

		if object:SessionExists(SEARCH_SESSION) then
			object:RemoveSession(SEARCH_SESSION)
		end

		local CUSTOMIZE_SESSION = v5.CUSTOMIZE_SESSION
		local CUSTOMIZE_REQUEST_ID = v6.CUSTOMIZE_REQUEST_ID

		if not object:SessionExists(CUSTOMIZE_SESSION) then
			object:SetSession(
				sessionType.StructuralIdentifier.Level2a,
				CUSTOMIZE_SESSION,
				CUSTOMIZE_SESSION
			)
			object:SetMetadata(CUSTOMIZE_SESSION, CUSTOMIZE_REQUEST_ID, HttpService:GenerateGUID(true))
		end
	else
		local SEARCH_SESSION = v5.SEARCH_SESSION

		if object:SessionExists(SEARCH_SESSION) then
			object:RemoveSession(SEARCH_SESSION)
		end

		if defineFastFlag3 then
			local CUSTOMIZE_SESSION = v5.CUSTOMIZE_SESSION

			if object:SessionExists(CUSTOMIZE_SESSION) then
				object:RemoveSession(CUSTOMIZE_SESSION)
			end
		end

		local MARKETPLACE_HOMEPAGE_SESSION = v5.MARKETPLACE_HOMEPAGE_SESSION
		local CATALOG_REQUEST_ID = v6.CATALOG_REQUEST_ID

		if not object:SessionExists(MARKETPLACE_HOMEPAGE_SESSION) then
			object:SetSession(
				sessionType.StructuralIdentifier.Level2a,
				MARKETPLACE_HOMEPAGE_SESSION,
				MARKETPLACE_HOMEPAGE_SESSION
			)
			object:SetMetadata(
				MARKETPLACE_HOMEPAGE_SESSION,
				CATALOG_REQUEST_ID,
				HttpService:GenerateGUID(true)
			)
		end
	end
end

return function(p2)
	local v7 = module(appSessionService)
	processSessionChange(v7, p2)

	if defineFastFlag2 and v7.isA ~= nil then
		module2("useRouteSessionManager: sessionService is not being redirected to SessionServiceWrapper")
	else
		v7.SessionChangedSignal:connect(function(p3)
			if p3 == sessionType.StructuralIdentifier.Level2a then
				processSessionChange(v7, p2)
			end
		end)
	end
end
