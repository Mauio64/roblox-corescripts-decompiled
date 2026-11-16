local CorePackages = game:GetService("CorePackages")
local SocialService = game:GetService("SocialService")

local ExternalContentSharingProtocol = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)

local isContentSharingAllowed = CachedPolicyService:IsContentSharingAllowed()

local PolicyProvider = require(CorePackages.Packages.PolicyProvider)
local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")

local defineFastFlag = game:DefineFastFlag("DifferentiateSharingBaseOnPlatform", false)
local v

if defineFastFlag then
	local v2 = memStorageService.read()
	v = v2 and v2.EnableShareCaptureCTA and v2.EligibleForCapturesFeature or false
else
	v = false
end

SocialService.OpenShareSheetWithLink:Connect(function(p: string)
	if not default then
		return
	end

	assert(default ~= nil, "ExternalContentSharingProtocol is required")

	if defineFastFlag then
		if not v then
			default:setClipboardText({ context = "PromptLinkSharing", text = p })

			return
		end
	elseif not isContentSharingAllowed then
		default:setClipboardText({ context = "PromptLinkSharing", text = p })

		return
	end

	default:shareUrl({ context = "PromptLinkSharing", url = p })
end)
