local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")

local v5 = {
	["Feature.RobloxSubscription.Description.ExclusiveBenefits"] = "Lorem ipsum dolor sit amet consectetur",
	["Feature.RobloxSubscription.Action.Subscribe"] = "Lorem"
}

local function usePlaceholderLocalization(items)
	return React.useMemo(function()
		local result = {}

		for k, item in pairs(items) do
			local v6 = if typeof(item) == "table" then item[1] else item
			local v7 = v5[v6] or v6

			if typeof(item) == "table" then
				for k2, v8 in pairs(item) do
					if typeof(k2) ~= "string" then
						continue
					end

					local v9 = v8
					v7 = string.gsub(v7, "{" .. k2 .. "}", function()
						return (tostring(v9))
					end)
				end
			end

			result[k] = v7
		end

		return result
	end, { items })
end

return usePlaceholderLocalization
