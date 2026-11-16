local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")

local SearchFieldView = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/SearchRow/SearchFieldView")
local useSearchFieldViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/SearchRow/useSearchFieldViewModel")

local function SearchField(p2)
	local v5 = useSearchFieldViewModel(p2)
	return React.createElement(SearchFieldView, v5)
end

return SearchField
