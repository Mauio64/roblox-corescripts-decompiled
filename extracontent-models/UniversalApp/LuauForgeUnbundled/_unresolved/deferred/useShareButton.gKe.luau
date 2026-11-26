local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images

local module = require("@luauforge/bundled/dPN")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local default = require("@luauforge/bundled/bZp").ExternalContentSharingProtocol.default
local module3 = require("@luauforge/bundled/dFm")
local module4 = require("@luauforge/bundled/dzE")
local module5 = require("@luauforge/bundled/fDf")

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module6 = require("@luauforge/deferred/gKf")
local module7 = require("@luauforge/bundled/eie")
local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local module8 = require("@luauforge/deferred/gKg")

local iconsactionsshare = images["icons/actions/share"]
local iconsmenulink = images["icons/menu/link"]

local function useShareButton(p2, p3, p4, callback, callback2)
	local v5 = useDispatch()
	local v6 = useLocalization({
		copyLinkAction = "Feature.Catalog.Action.CopyLink",
		shareAction = "Feature.SocialShare.Action.Share",
		shareViaAction = "Feature.Catalog.Action.ShareVia"
	})

	local v7 = module6()
	local v8 = module7(module5)

	local v9 = useCallback(function(p5)
		v8.clickShareItemButton(p2, p3)
		default:shareUrl({ context = "MoreMenu", url = p5 })
	end, { v8, p2, p3, default })

	local v10 = useCallback(function(p5)
		if p2 and p3 then
			v5(GetExperienceSourceLanguage.GetOrGenerateShortShareLink(p2, p3)):andThen(function(p6)
				if p6 and p6.responseBody and p6.responseBody.shortUrl then
					if p5 then
						v5(module3({
							toastMessage = "Feature.Catalog.Toast.LinkCopied",
							toastType = module4.SuccessConfirmation
						}))
					end

					v7(module.Counter.GetOrGenerateShortShareLink.HookSuccess)
					v9(p6.responseBody.shortUrl)
				else
					v5(module3({
						toastMessage = "Feature.Catalog.Response.GenericError",
						toastType = module4.InformationMessage
					}))

					v7(module.Counter.GetOrGenerateShortShareLink.HookInvalid)
				end
			end):catch(function(p6)
				v5(module3({
					toastMessage = "Feature.Catalog.Response.GenericError",
					toastType = module4.NetworkingError
				}))

				v7(module.Counter.GetOrGenerateShortShareLink.HookFailure)
			end)
		end
	end, { p2, p3, v7, module3, v5, v9 })

	local v11 = useCallback(function(p5)
		if callback then
			callback(p5)
		end

		v10(false)
	end, { callback, v10 })

	local v12 = useCallback(function(p5)
		if callback then
			callback(p5)
		end

		v10(true)
	end, { callback, v10 })

	local v13 = module8()

	local v14 = if v13 then v13.supportShareButton or false else false
	local supportCopyLinkButton = v13 and v13.supportCopyLinkButton or false

	if v14 then
		local v15 = { icon = iconsactionsshare, text = 0, onActivated = 0 }

		local v16 = if p4 then v6.shareViaAction else v6.shareAction
		v15.text = v16

		if type(callback2) == "function" then
			v11 = callback2
		end

		v15.onActivated = v11
		return v15
	else
		if not supportCopyLinkButton then
			return nil
		end

		local v15 = { icon = iconsmenulink, onActivated = 0, text = 0 }

		if type(callback2) == "function" then
			v12 = callback2
		end

		v15.onActivated = v12
		v15.text = v6.copyLinkAction
		return v15
	end
end

return useShareButton
