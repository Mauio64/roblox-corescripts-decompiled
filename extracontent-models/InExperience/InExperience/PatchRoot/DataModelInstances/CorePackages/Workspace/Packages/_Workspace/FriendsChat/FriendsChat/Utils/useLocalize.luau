local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local localizeStrings = Localization.localizeStrings

local function useLocalize()
	local v = React.useContext(LocalizationRoactContext)
	return React.useCallback(function(p)
		if v == nil then
			return ""
		end

		local success, result = pcall(function()
			return localizeStrings(v, { value = p }).value
		end)

		if success and typeof(result) == "string" then
			return result
		end

		return ""
	end, { v })
end

return useLocalize
