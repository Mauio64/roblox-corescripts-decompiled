local CorePackages = game:GetService("CorePackages")
local SafeAppStorageService = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Lib.SafeAppStorageService
local v3 = game:DefineFastFlag("AXAccessoryAdjustmentFtuxUseMemStorage", false)

local function useAccessoryAdjustmentQuickButtonFtux() -- line: 11
	-- upvalues: SafeAppStorageService (copy), v3 (copy)
	return {
		shouldShowFirstTimeGlow = function() -- line: 12
			-- upvalues: SafeAppStorageService (copy), v3 (copy)
			return SafeAppStorageService.getItem("AXMarketplaceAccessoryAdjustmentQuickButtonFTUX", v3) ~= "SEEN"
		end,
		completeFirstTimeGlow = function() -- line: 17
			-- upvalues: SafeAppStorageService (copy), v3 (copy)
			SafeAppStorageService.setItem("AXMarketplaceAccessoryAdjustmentQuickButtonFTUX", "SEEN", v3)
			SafeAppStorageService.flush()
		end
	}
end

return useAccessoryAdjustmentQuickButtonFtux
