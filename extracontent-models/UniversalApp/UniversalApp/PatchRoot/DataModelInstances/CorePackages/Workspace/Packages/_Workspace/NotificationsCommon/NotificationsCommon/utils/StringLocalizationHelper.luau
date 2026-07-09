local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local LocalizationRoactContext = require(ParentParent.Localization).LocalizationRoactContext
local useLocalization = require(ParentParent.Localization).Hooks.useLocalization
local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")

require(NotificationsCommon.type)

local RobloxTranslator = require(ParentParent.RobloxTranslator)

return {
	getLocalizedStrings = function(p1) -- line: 13
		-- upvalues: React (copy), LocalizationRoactContext (copy), useLocalization (copy), RobloxTranslator (copy)
		if React.useContext(LocalizationRoactContext) ~= nil then
			return useLocalization(p1)
		end

		local t1 = {}

		for k, v in pairs(p1) do
			local ok, result = pcall(function() -- line: 24
				-- upvalues: RobloxTranslator (copy), v (copy)
				return RobloxTranslator:FormatByKey(v)
			end)

			if ok then
				t1[k] = result
			else
				t1[k] = v
			end
		end

		return t1
	end
}
