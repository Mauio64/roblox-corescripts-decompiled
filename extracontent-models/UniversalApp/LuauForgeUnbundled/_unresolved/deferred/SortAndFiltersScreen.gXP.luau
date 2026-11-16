local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require("@luauforge/bundled/fuM")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local module = require("@luauforge/deferred/gXQ")
local module2 = require("@luauforge/deferred/gYg")

local function SortAndFiltersScreen()
	local params = useNavigation().state.params

	if params.slotBasedEditorContext then
		return React.createElement(module2, {
			slotBasedEditorContext = params.slotBasedEditorContext
		})
	end

	return React.createElement(module)
end

return SortAndFiltersScreen
