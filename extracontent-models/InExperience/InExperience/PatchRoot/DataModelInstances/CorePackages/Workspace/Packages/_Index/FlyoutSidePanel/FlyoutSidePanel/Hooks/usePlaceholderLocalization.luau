local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)

local v = {
	["Feature.RobloxSubscription.Description.ExclusiveBenefits"] = "Lorem ipsum dolor sit amet consectetur",
	["Feature.RobloxSubscription.Action.Subscribe"] = "Lorem"
}

local function usePlaceholderLocalization(items)
	return React.useMemo(function()
		local result = {}

		for k, item in pairs(items) do
			local v2

			if typeof(item) == "table" then
				v2 = item[1]
			else
				v2 = item
			end

			local v3 = v[v2] or v2

			if typeof(item) == "table" then
				for k2, v4 in pairs(item) do
					if typeof(k2) ~= "string" then
						continue
					end

					local v5 = v4
					v3 = string.gsub(v3, "{" .. k2 .. "}", function()
						return (tostring(v5))
					end)
				end
			end

			result[k] = v3
		end

		return result
	end, { items })
end

return usePlaceholderLocalization
