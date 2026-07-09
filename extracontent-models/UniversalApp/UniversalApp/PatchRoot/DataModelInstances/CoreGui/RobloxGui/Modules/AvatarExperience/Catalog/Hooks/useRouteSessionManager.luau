local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local mutedError = require(Modules.LuaApp.mutedError)
local v9 = game:DefineFastFlag("UseOpaqueNameForSessionChange", false)
local v10 = game:DefineFastFlag("MuteSessionServiceErrorUWP", false)
local v11 = game:DefineFastFlag("AXCustomizeSessions3", false)
local t1 = {
	MARKETPLACE_HOMEPAGE_SESSION = "AvatarExperienceMarketplaceHomepageSession",
	SEARCH_SESSION = "AvatarExperienceSearchSession",
	CUSTOMIZE_SESSION = if not v11 then nil else "AvatarExperienceCustomizeSession"
}
local t2 = {
	CATALOG_REQUEST_ID = "avatarCatalogRequestId",
	SEARCH_REQUEST_ID = "avatarSearchRequestId",
	CUSTOMIZE_REQUEST_ID = if not v11 then nil else "avatarCustomizeRequestId"
}

local function clearSession(p1, s1: string) -- line: 32
	if p1:SessionExists(s1) then
		p1:RemoveSession(s1)
	end
end
local function setSession(p2, s2: string, s3: string) -- line: 38
	-- upvalues: SessionType (copy), HttpService (copy)
	if not p2:SessionExists(s2) then
		p2:SetSession(SessionType.StructuralIdentifier.Level2a, s2, s2)
		p2:SetMetadata(s2, s3, HttpService:GenerateGUID(true))
	end
end
local function processSessionChange(p3, p4) -- line: 45
	-- upvalues: v9 (copy), AvatarScreen (copy), t1 (copy), v11 (copy), t2 (copy), SessionType (copy), HttpService (copy)
	local v24 = if not v9 then p4.current.name else p4.opaque.name

	if v24 == AvatarScreen.CatalogSearch then
		local MARKETPLACE_HOMEPAGE_SESSION = t1.MARKETPLACE_HOMEPAGE_SESSION

		if p3:SessionExists(MARKETPLACE_HOMEPAGE_SESSION) then
			p3:RemoveSession(MARKETPLACE_HOMEPAGE_SESSION)
		end

		if v11 then
			local CUSTOMIZE_SESSION = t1.CUSTOMIZE_SESSION

			if p3:SessionExists(CUSTOMIZE_SESSION) then
				p3:RemoveSession(CUSTOMIZE_SESSION)
			end
		end

		local SEARCH_SESSION = t1.SEARCH_SESSION
		local SEARCH_REQUEST_ID = t2.SEARCH_REQUEST_ID

		if not p3:SessionExists(SEARCH_SESSION) then
			p3:SetSession(SessionType.StructuralIdentifier.Level2a, SEARCH_SESSION, SEARCH_SESSION)
			p3:SetMetadata(SEARCH_SESSION, SEARCH_REQUEST_ID, HttpService:GenerateGUID(true))

			return
		end
	elseif v11 and (v24 == AvatarScreen.AvatarEditor or v24 == AvatarScreen.AvatarSwitcher or v24 == AvatarScreen.EditEmotes or v24 == AvatarScreen.AccessoryAdjustment or v24 == AvatarScreen.BodyShape or v24 == AvatarScreen.HeadRefinement or v24 == AvatarScreen.LayeredClothingSort or v24 == AvatarScreen.ColorAdjustment or v24 == AvatarScreen.MySharedAvatars or v24 == AvatarScreen.LookComposerPage or v24 == AvatarScreen.ProfilePictureEditorEmotes or v24 == AvatarScreen.ProfilePictureEditorCamera or v24 == AvatarScreen.ProfilePictureEditorFinal) then
		local MARKETPLACE_HOMEPAGE_SESSION = t1.MARKETPLACE_HOMEPAGE_SESSION

		if p3:SessionExists(MARKETPLACE_HOMEPAGE_SESSION) then
			p3:RemoveSession(MARKETPLACE_HOMEPAGE_SESSION)
		end

		local SEARCH_SESSION = t1.SEARCH_SESSION

		if p3:SessionExists(SEARCH_SESSION) then
			p3:RemoveSession(SEARCH_SESSION)
		end

		local CUSTOMIZE_SESSION = t1.CUSTOMIZE_SESSION
		local CUSTOMIZE_REQUEST_ID = t2.CUSTOMIZE_REQUEST_ID

		if not p3:SessionExists(CUSTOMIZE_SESSION) then
			p3:SetSession(SessionType.StructuralIdentifier.Level2a, CUSTOMIZE_SESSION, CUSTOMIZE_SESSION)
			p3:SetMetadata(CUSTOMIZE_SESSION, CUSTOMIZE_REQUEST_ID, HttpService:GenerateGUID(true))

			return
		end
	else
		local SEARCH_SESSION = t1.SEARCH_SESSION

		if p3:SessionExists(SEARCH_SESSION) then
			p3:RemoveSession(SEARCH_SESSION)
		end

		if v11 then
			local CUSTOMIZE_SESSION = t1.CUSTOMIZE_SESSION

			if p3:SessionExists(CUSTOMIZE_SESSION) then
				p3:RemoveSession(CUSTOMIZE_SESSION)
			end
		end

		local MARKETPLACE_HOMEPAGE_SESSION = t1.MARKETPLACE_HOMEPAGE_SESSION
		local CATALOG_REQUEST_ID = t2.CATALOG_REQUEST_ID

		if not p3:SessionExists(MARKETPLACE_HOMEPAGE_SESSION) then
			p3:SetSession(SessionType.StructuralIdentifier.Level2a, MARKETPLACE_HOMEPAGE_SESSION, MARKETPLACE_HOMEPAGE_SESSION)
			p3:SetMetadata(MARKETPLACE_HOMEPAGE_SESSION, CATALOG_REQUEST_ID, HttpService:GenerateGUID(true))
		end
	end
end

return function(p5) -- line: 95
	-- upvalues: useRoactService (copy), AppSessionService (copy), processSessionChange (copy), v10 (copy), mutedError (copy), SessionType (copy)
	local v38 = useRoactService(AppSessionService)

	processSessionChange(v38, p5)

	if v10 and v38.isA ~= nil then
		mutedError("useRouteSessionManager: sessionService is not being redirected to SessionServiceWrapper")

		return
	end

	v38.SessionChangedSignal:connect(function(p6) -- line: 105
		-- upvalues: SessionType (copy), processSessionChange (copy), v38 (copy), p5 (copy)
		if p6 == SessionType.StructuralIdentifier.Level2a then
			processSessionChange(v38, p5)
		end
	end)
end
