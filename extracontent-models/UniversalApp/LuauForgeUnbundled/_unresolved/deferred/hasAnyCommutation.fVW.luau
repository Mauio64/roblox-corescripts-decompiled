require("@luauforge/deferred/fUR")

local function hasAnyCommutation(items): boolean
	if not items then
		return false
	end

	for k, item in items do
		if item == true then
			return true
		end
	end

	return false
end

return hasAnyCommutation
