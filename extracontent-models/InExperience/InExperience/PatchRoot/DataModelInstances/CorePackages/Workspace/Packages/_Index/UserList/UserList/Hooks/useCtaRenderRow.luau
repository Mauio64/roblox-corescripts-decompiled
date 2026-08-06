local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local ProfileCtaService = require(UserListParent.ProfileCtaService)
local Enums = require(UserList.Common.Enums)

require(UserList.Common.Types)

local CtaRow = require(UserList.Cta.CtaRow)
local useCtaActionHandlers = require(script.Parent.useCtaActionHandlers)
local ProfileCTAService = ProfileCtaService.ProfileCTAService
local t1 = {}

local function useCtaRenderRow(p1) -- line: 24
	-- upvalues: React (copy), ProfileCTAService (copy), useCtaActionHandlers (copy), Enums (copy), t1 (copy), CtaRow (copy)
	React.useEffect(function() -- line: 25
		-- upvalues: ProfileCTAService (copy)
		local v13 = ProfileCTAService.connectRealTimeUpdates()

		return function() -- line: 27
			-- upvalues: v13 (copy)
			v13.Disconnect()
		end
	end, {})

	local v12 = useCtaActionHandlers(p1)

	return React.useMemo(function() -- line: 34
		-- upvalues: Enums (copy), t1 (copy), React (copy), CtaRow (copy), v12 (copy), p1 (copy)
		return function(p2, p3, _: number) -- line: 35
			-- upvalues: Enums (copy), t1 (copy), React (copy), CtaRow (copy), v12 (copy), p1 (copy)
			if p3.type ~= Enums.EntityType.User then
				return p2(t1)
			end

			return React.createElement(CtaRow, {
				createRow = p2,
				entity = p3,
				actionHandlers = v12,
				ctaConfig = p1
			})
		end
	end, {
		v12,
		p1
	})
end

return useCtaRenderRow
