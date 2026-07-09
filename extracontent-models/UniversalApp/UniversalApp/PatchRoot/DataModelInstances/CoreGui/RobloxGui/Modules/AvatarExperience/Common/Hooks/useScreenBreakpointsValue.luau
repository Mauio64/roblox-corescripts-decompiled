local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector

require(Modules.AvatarExperience.Common.Types)

local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local t1 = {
	"default",
	"sm",
	"md",
	"lg",
	"xl",
	"xxl"
}
local t2 = {
	default = 0,
	sm = 576,
	md = 768,
	lg = 992,
	xl = 1200,
	xxl = 1400
}

local function useScreenBreakpointsValue(p1) -- line: 49
	-- upvalues: useSelector (copy), getUseSelectorDeepEquals (copy), React (copy), t1 (copy), t2 (copy)
	local v10 = useSelector(function(p2) -- line: 50
		return p2.ScreenSize
	end, getUseSelectorDeepEquals())
	local v11 = not v10 and 0 or v10.X

	return React.useMemo(function() -- line: 56
		-- upvalues: t1 (copy), p1 (copy), t2 (copy), v11 (copy)
		local v13 = nil

		for _, v15 in t1 do
			if p1[v15] then
				if t2[v15] > v11 then
					return v13
				end

				v13 = p1[v15]
			end
		end

		return v13
	end, {
		v11,
		p1
	})
end

return useScreenBreakpointsValue
