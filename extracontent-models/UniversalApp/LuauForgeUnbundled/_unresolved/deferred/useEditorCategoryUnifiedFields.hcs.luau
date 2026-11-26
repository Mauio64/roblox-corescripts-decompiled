local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module = require("@luauforge/bundled/dSW")
local module2 = require("@luauforge/deferred/hct")

local function useEditorCategoryUnifiedFields(p2, p3)
	local v5 = {
		p2,
		p3,
		(SignalsReact.useSignalState(module.getCatalogCategoriesStore().getCategoriesMap))
	}
	return React.useMemo(function()
		return module2(p2, p3)
	end, v5)
end

return useEditorCategoryUnifiedFields
