local module = require("@luauforge/deferred/eko")
local module2 = require("@luauforge/deferred/fbO")
local module3 = require("@luauforge/deferred/fbP")
local useNavigationFocus = require("@luauforge/deferred/ekp").useNavigationFocus

local module4 = require("@luauforge/deferred/fbQ")
local module5 = require("@luauforge/deferred/eli")
local module6 = require("@luauforge/deferred/fbx")
local module7 = require("@luauforge/deferred/fbK")
local module8 = require("@luauforge/deferred/fbE")
local module9 = require("@luauforge/deferred/elp")

local eventNames = module6.EventNames
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local navigateBack = module3.Thunks.NavigateBack

local function AddSchoolUpsellContainer(p2)
	local v5 = useDispatch()
	local navigation = p2.navigation

	local v6 = useNavigationFocus()

	local v7 = module6.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if module9 or not module8 then
			return nil
		end

		if v6 then
			v7(eventNames.AddSchoolUpsellPageLoad)
		end

		return nil
	end, { v6, v7 })

	local v8 = module.useCallback(function()
		if module8 then
			v7(eventNames.AddSchoolUpsellContinueClick)
		end

		navigation.replace(module5.VerifyEmail)
	end, { navigation, v7 })

	local v9 = module.useCallback(function()
		if navigation.isFocused() then
			v5(navigateBack())
		end
	end, { navigation, v5 })

	local element = module.createElement(module4, {
		isOpen = v6,
		onContinue = v8,
		onClose = v9
	})

	if module9 and module8 then
		return module.createElement(module.Fragment, nil, {
			PageLoad = module.createElement(module7, {
				eventName = eventNames.AddSchoolUpsellPageLoad
			}),
			Page = element
		})
	end

	return element
end

return AddSchoolUpsellContainer
