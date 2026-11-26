local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/egx")
local module3 = require("@luauforge/deferred/gFq")
local module4 = require("@luauforge/deferred/gIw")

local module5 = require("@luauforge/bundled/ego")
local CorePackages = game:GetService("CorePackages")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)

local module6 = require("@luauforge/deferred/gIy")

local module7 = require("@luauforge/bundled/gIA")

local function AccountInfoPage(props)
	local v5 = useDispatch()
	local v6 = module(module2)
	React.useEffect(function()
		return function()
			v5(module4(v6))
		end
	end, {})

	if not module7() then
		return module5.createElement(module3, {
			isVisible = props.isVisible,
			DisplayOrder = props.displayOrder,
			url = props.url,
			title = props.title,
			titleKey = props.titleKey
		})
	end

	local createElement = module5.createElement
	local v8 = {
		url = props.url,
		titleKey = props.titleKey,
		windowCloseCallback = 0,
		isVisible = 0,
		displayOrder = 0
	}
	local v9 = if props then props.onClose or nil else nil
	v8.windowCloseCallback = v9
	v8.isVisible = props.isVisible
	v8.displayOrder = props.displayOrder
	return createElement(module6, v8)
end

return AccountInfoPage
