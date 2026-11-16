local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.DataHydration)
local React = require(parent.React)

local useProfileNames = require(AppChat.Hooks.useProfileNames)

local function useProfileName(p: string?)
	local v = useProfileNames((React.useMemo(function()
		if p then
			return { p }
		end

		return {}
	end, { p })))

	return React.useMemo(function()
		local v2

		if p then
			v2 = v.namesByUserId[p]
		end

		local v3 = { status = v.status, combinedName = 0, username = 0 }
		local combinedName

		if v2 then
			combinedName = v2.combinedName
		end

		v3.combinedName = combinedName
		local username

		if v2 then
			username = v2.username
		end

		v3.username = username
		return v3
	end, { v, p })
end

return useProfileName
