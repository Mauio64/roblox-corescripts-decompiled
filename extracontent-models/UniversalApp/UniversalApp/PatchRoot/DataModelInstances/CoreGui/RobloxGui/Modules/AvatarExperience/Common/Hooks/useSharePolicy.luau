local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local Platform = UserInputService:GetPlatform()
local v6 = Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or (Platform == Enum.Platform.Linux or Platform == Enum.Platform.UWP))
local v7 = GuiService:IsTenFootInterface()

local function useSharePolicy() -- line: 14
	-- upvalues: useAppPolicy (copy), v7 (copy), v6 (copy)
	local v9 = useAppPolicy(function(p1) -- line: 16
		return p1.shouldShowCatalogShareButton()
	end)
	local v10 = useAppPolicy(function(p2) -- line: 20
		return p2.getWebViewSupport()
	end)
	local v11 = v9 and (not v7 and v10)
	local v12 = v6

	return {
		supportShareButton = v11,
		supportCopyLinkButton = v12
	}
end

return useSharePolicy
