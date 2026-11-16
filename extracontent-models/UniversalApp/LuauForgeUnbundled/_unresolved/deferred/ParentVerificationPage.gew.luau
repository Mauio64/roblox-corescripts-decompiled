local module = require("@luauforge/deferred/gaH")

local CorePackages = game:GetService("CorePackages")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local module2 = require("@luauforge/bundled/gex")

local function ParentVerificationPage(p2)
	local v5 = useDispatch()
	React.useEffect(function()
		return function()
			v5(module2())
		end
	end, {})

	return React.createElement(module, { isVisible = true, url = p2.url })
end

return ParentVerificationPage
