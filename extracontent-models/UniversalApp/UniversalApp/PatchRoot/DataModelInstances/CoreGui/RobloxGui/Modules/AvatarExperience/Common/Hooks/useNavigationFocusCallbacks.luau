local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation

local function useNavigationFocusCallbacks(t1: {[any]: any}) -- line: 34
	-- upvalues: useNavigation (copy), React (copy), RoactNavigation (copy)
	local v7 = useNavigation()

	React.useEffect(function() -- line: 37
		-- upvalues: t1 (copy), v7 (copy), RoactNavigation (copy)
		local t2 = {}

		local function addSubscription(p1, p2) -- line: 40
			-- upvalues: t1 (copy), t2 (copy), v7 (copy)
			if t1[p2] then
				table.insert(t2, v7.addListener(p1, t1[p2]))
			end
		end

		local WillFocus = RoactNavigation.Events.WillFocus

		if t1.onWillFocus then
			table.insert(t2, v7.addListener(WillFocus, t1.onWillFocus))
		end

		local WillBlur = RoactNavigation.Events.WillBlur

		if t1.onWillBlur then
			table.insert(t2, v7.addListener(WillBlur, t1.onWillBlur))
		end

		local DidFocus = RoactNavigation.Events.DidFocus

		if t1.onDidFocus then
			table.insert(t2, v7.addListener(DidFocus, t1.onDidFocus))
		end

		local DidBlur = RoactNavigation.Events.DidBlur

		if t1.onDidBlur then
			table.insert(t2, v7.addListener(DidBlur, t1.onDidBlur))
		end

		return function() -- line: 51
			-- upvalues: t2 (copy)
			for _, v17 in t2 do
				v17.remove()
			end
		end
	end, {
		t1.onWillFocus,
		t1.onWillBlur,
		t1.onDidFocus,
		t1.onDidBlur
	})
end

return useNavigationFocusCallbacks
