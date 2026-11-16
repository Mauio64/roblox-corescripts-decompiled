local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper

local fStringAXFilterAndSortViewExposureLayer = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FStringAXFilterAndSortViewExposureLayer

local function FilterAndSortViewExposureLogger(): nil
	React.useEffect(function()
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXFilterAndSortViewExposureLayer)
	end, {})

	return nil
end

return FilterAndSortViewExposureLogger
