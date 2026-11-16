local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/eWj")

local searchInput = Foundation.SearchInput
local inputSize = Foundation.Enums.InputSize
local searchInputShape = Foundation.Enums.SearchInputShape

local function SchoolSearch(props)
	local createElement = module.createElement
	local v6 = {
		LayoutOrder = props.layoutOrder,
		text = props.query,
		placeholder = props.placeholder,
		onChanged = props.onQueryChanged,
		onFocusLost = 0,
		size = 0,
		shape = 0,
		width = 0
	}
	local v7 = if module3 then props.onFocusLost else nil
	v6.onFocusLost = v7
	v6.size = inputSize.Medium
	v6.shape = searchInputShape.Rounded
	v6.width = UDim.new(1, 0)
	return createElement(searchInput, v6)
end

return SchoolSearch
