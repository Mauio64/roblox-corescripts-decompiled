local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local default = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSendCounter = require(Modules.AvatarExperience.Common.Hooks.useSendCounter)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useCallback = require(CorePackages.Packages.React).useCallback
local useSharePolicy = require(Modules.AvatarExperience.Common.Hooks.useSharePolicy)
local v16 = Images["icons/actions/share"]
local v17 = Images["icons/menu/link"]

local function useShareButton(s1: string?, s2: string, b1: boolean?, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 26
	-- upvalues: useDispatch (copy), useLocalization (copy), useSendCounter (copy), useRoactService (copy), Analytics (copy), useCallback (copy), default (copy), WebApi (copy), SetCurrentToastMessage (copy), ToastType (copy), Constants (copy), useSharePolicy (copy), v16 (copy), v17 (copy)
	local v24 = useDispatch()
	local v25 = useLocalization({
		copyLinkAction = "Feature.Catalog.Action.CopyLink",
		shareAction = "Feature.SocialShare.Action.Share",
		shareViaAction = "Feature.Catalog.Action.ShareVia"
	})
	local v26 = useSendCounter()
	local v27 = useRoactService(Analytics)
	local v28 = useCallback(function(s3: string) -- line: 46
		-- upvalues: v27 (copy), s1 (copy), s2 (copy), default (copy)
		v27.clickShareItemButton(s1, s2)
		default:shareUrl({
			context = "MoreMenu",
			url = s3
		})
	end, {
		v27,
		s1,
		s2,
		default
	})
	local v29 = useCallback(function(b2: boolean) -- line: 54
		-- upvalues: s1 (copy), s2 (copy), v24 (copy), WebApi (copy), SetCurrentToastMessage (copy), ToastType (copy), v26 (copy), Constants (copy), v28 (copy)
		if not s1 or not s2 then
			return
		end

		v24(WebApi.GetOrGenerateShortShareLink(s1, s2)):andThen(function(p3) -- line: 59
			-- upvalues: b2 (copy), v24 (copy), SetCurrentToastMessage (copy), ToastType (copy), v26 (copy), Constants (copy), v28 (copy)
			if p3 and (p3.responseBody and p3.responseBody.shortUrl) then
				if b2 then
					v24(SetCurrentToastMessage({
						toastMessage = "Feature.Catalog.Toast.LinkCopied",
						toastType = ToastType.SuccessConfirmation
					}))
				end

				v26(Constants.Counter.GetOrGenerateShortShareLink.HookSuccess)
				v28(p3.responseBody.shortUrl)

				return
			end

			v24(SetCurrentToastMessage({
				toastMessage = "Feature.Catalog.Response.GenericError",
				toastType = ToastType.InformationMessage
			}))
			v26(Constants.Counter.GetOrGenerateShortShareLink.HookInvalid)
		end):catch(function(_) -- line: 78
			-- upvalues: v24 (copy), SetCurrentToastMessage (copy), ToastType (copy), v26 (copy), Constants (copy)
			v24(SetCurrentToastMessage({
				toastMessage = "Feature.Catalog.Response.GenericError",
				toastType = ToastType.NetworkingError
			}))
			v26(Constants.Counter.GetOrGenerateShortShareLink.HookFailure)
		end)
	end, {
		s1,
		s2,
		v26,
		SetCurrentToastMessage,
		v24,
		v28
	})
	local v30 = useCallback(function(p5) -- line: 87
		-- upvalues: p1 (copy), v29 (copy)
		if p1 then
			p1(p5)
		end

		v29(false)
	end, {
		p1,
		v29
	})
	local v31 = useCallback(function(p6) -- line: 94
		-- upvalues: p1 (copy), v29 (copy)
		if p1 then
			p1(p6)
		end

		v29(true)
	end, {
		p1,
		v29
	})
	local v32 = useSharePolicy()
	local v33 = not not v32 and (v32.supportShareButton or false)
	local v34 = not not v32 and (v32.supportCopyLinkButton or false)

	if v33 then
		return {
			icon = v16,
			text = if not b1 then v25.shareAction else v25.shareViaAction,
			onActivated = if type(p2) ~= "function" then v30 else p2
		}
	end

	if v34 then
		return {
			icon = v17,
			onActivated = if type(p2) ~= "function" then v31 else p2,
			text = v25.copyLinkAction
		}
	end

	return nil
end

return useShareButton
