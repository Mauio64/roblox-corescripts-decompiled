local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.LuauPolyfill)

local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RequestStatusEnum = require(Modules.AvatarExperience.Common.Enum.RequestStatusEnum)
local Promise = require(CorePackages.Packages.Promise)

local function useRequest(p1: ((...any) -> ...any)) -- line: 24
	-- upvalues: React (copy), RequestStatusEnum (copy), Promise (copy)
	local v8, v9 = React.useState({
		status = RequestStatusEnum.None
	})
	local v10 = React.createRef()

	return v8, (React.useCallback(function() -- line: 28
		-- upvalues: v10 (copy), Promise (copy), v9 (copy), RequestStatusEnum (copy), p1 (copy)
		if v10.current then
			return Promise.resolve()
		end

		v9({
			status = RequestStatusEnum.Pending
		})
		v10.current = true

		return p1():andThen(function(p2) -- line: 36
			-- upvalues: v9 (copy), RequestStatusEnum (copy), v10 (copy)
			v9({
				status = RequestStatusEnum.Resolved,
				response = p2
			})
			v10.current = false
		end, function(p3) -- line: 39
			-- upvalues: v9 (copy), RequestStatusEnum (copy), v10 (copy)
			v9({
				status = RequestStatusEnum.Rejected,
				response = p3
			})
			v10.current = false
		end)
	end, {
		p1,
		v10.current
	}))
end

return useRequest
