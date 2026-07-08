local CorePackages = game:GetService("CorePackages")
local SocialService = game:GetService("SocialService")
local default = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local v4 = require(CorePackages.Workspace.Packages.CachedPolicyService):IsContentSharingAllowed()
local v5 = require(CorePackages.Packages.PolicyProvider).GetPolicyImplementations.MemStorageService("app-policy")
local v6 = game:DefineFastFlag("DifferentiateSharingBaseOnPlatform", false)
local u7 = false

if v6 then
	local v8 = v5.read()

	u7 = not not v8 and (not not v8.EnableShareCaptureCTA and (v8.EligibleForCapturesFeature or false))
end

SocialService.OpenShareSheetWithLink:Connect(function(s1: string) -- line: 21
	-- upvalues: default (copy), v6 (copy), u7 (ref), v4 (copy)
	if not default then
		return
	end

	assert(default ~= nil, "ExternalContentSharingProtocol is required")

	if v6 then
		if not u7 then
			default:setClipboardText({
				context = "PromptLinkSharing",
				text = s1
			})

			return
		end
	elseif not v4 then
		default:setClipboardText({
			context = "PromptLinkSharing",
			text = s1
		})

		return
	end

	default:shareUrl({
		context = "PromptLinkSharing",
		url = s1
	})
end)
