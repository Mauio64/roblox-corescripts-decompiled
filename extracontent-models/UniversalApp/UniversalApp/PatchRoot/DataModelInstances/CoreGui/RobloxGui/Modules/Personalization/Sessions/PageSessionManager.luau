local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useRouteName = require(CorePackages.Workspace.Packages.Navigation).useRouteName
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), useRouteName (copy), useSelector (copy)
	local v6 = React.useRef(false)
	local v7 = React.useRef(nil)
	local v8 = useRouteName()
	local v9 = useSelector(function(p1) -- line: 17
		-- upvalues: t1 (copy)
		return p1.Personalization.PageSessionTimestamp[t1.appPage]
	end)

	React.useEffect(function() -- line: 21
		-- upvalues: v8 (copy), t1 (copy), v9 (copy), v7 (copy), v6 (copy)
		if v8 ~= t1.appPage then
			return
		end

		if v9 == nil then
			return
		end

		if v7.current == nil then
			v7.current = v9
		end

		if not v6.current or v9 ~= nil and v9 > v7.current then
			v6.current = true

			if t1.setPageSession then
				t1.setPageSession()
			end

			v7.current = v9
		end

		return function() -- line: 45
			-- upvalues: t1 (copy)
			if t1.clearPageSession then
				t1.clearPageSession()
			end
		end
	end, {
		v8,
		t1.appPage,
		v9,
		t1.setPageSession,
		t1.clearPageSession
	})

	return nil
end
