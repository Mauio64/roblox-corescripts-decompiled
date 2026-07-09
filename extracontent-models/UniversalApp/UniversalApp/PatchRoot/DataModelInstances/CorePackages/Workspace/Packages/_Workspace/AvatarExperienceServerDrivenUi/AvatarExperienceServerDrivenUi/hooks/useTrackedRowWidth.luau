local Parent = script:FindFirstAncestor("AvatarExperienceServerDrivenUi").Parent
local React = require(Parent.React)
local FFlagAXFixSduiCatalogRowJump = require(Parent.AvatarExperienceFlags).FFlagAXFixSduiCatalogRowJump

local function useTrackedRowWidth(n1: number?) -- line: 33
	-- upvalues: FFlagAXFixSduiCatalogRowJump (copy), React (copy)
	local v6 = (not FFlagAXFixSduiCatalogRowJump or (not n1 or not (n1 > 0))) and 0 or n1
	local v7, v8 = React.useState(v6)
	local v9 = React.useRef(v6)

	return v7, (React.useCallback(function(p1) -- line: 37
		-- upvalues: v9 (copy), v8 (copy)
		local AbsoluteSizeX = p1.AbsoluteSize.X

		if AbsoluteSizeX == v9.current then
			return
		end

		v9.current = AbsoluteSizeX
		v8(AbsoluteSizeX)
	end, {}))
end

return useTrackedRowWidth
