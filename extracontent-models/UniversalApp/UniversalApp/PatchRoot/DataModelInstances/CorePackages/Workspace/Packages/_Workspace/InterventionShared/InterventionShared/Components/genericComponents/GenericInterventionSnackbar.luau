local Parent = script:FindFirstAncestor("InterventionShared").Parent
local React = require(Parent.React)
local useEffect = React.useEffect
local LuauPolyfill = require(Parent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local Snackbar = require(Parent.Foundation).Snackbar
local v8 = game:DefineFastInt("GenericInterventionSnackbarAutoDismissDelaySeconds", 4)

local function GenericInterventionSnackbar(t1: {[any]: any}) -- line: 27
	-- upvalues: useEffect (copy), v8 (copy), setTimeout (copy), clearTimeout (copy), React (copy), Snackbar (copy)
	useEffect(function() -- line: 28
		-- upvalues: t1 (copy), v8 (copy), setTimeout (copy), clearTimeout (copy)
		local v11 = t1.autoDismissDelaySeconds or v8
		local u12 = setTimeout(function() -- line: 32
			-- upvalues: t1 (copy)
			t1.onDismiss()
		end, v11 * 1000)

		return function() -- line: 36
			-- upvalues: u12 (ref), clearTimeout (copy)
			if u12 then
				clearTimeout(u12)
			end
		end
	end, {
		t1.onDismiss,
		t1.autoDismissDelaySeconds
	})

	return (React.createElement(Snackbar, {
		title = t1.titleText,
		icon = t1.iconName,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0)
	}))
end

return React.memo(GenericInterventionSnackbar)
