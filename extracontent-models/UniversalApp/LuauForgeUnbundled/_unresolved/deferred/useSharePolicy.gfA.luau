local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local UserInputService = game:GetService("UserInputService")

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local platform = UserInputService:GetPlatform()
local v5 = platform == Enum.Platform.Windows
	or platform == Enum.Platform.OSX
	or platform == Enum.Platform.Linux
	or platform == Enum.Platform.UWP
local tenFootInterface = isTenFootInterface()

local function useSharePolicy()
	local v6 = useAppPolicy(function(p2)
		return p2.shouldShowCatalogShareButton()
	end)

	local v7 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	return {
		supportShareButton = v6 and not tenFootInterface and v7,
		supportCopyLinkButton = v5
	}
end

return useSharePolicy
