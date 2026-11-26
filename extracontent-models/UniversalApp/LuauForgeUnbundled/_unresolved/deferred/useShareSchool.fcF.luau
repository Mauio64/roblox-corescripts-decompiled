local module = require("@luauforge/deferred/eko")
local module2 = require("@luauforge/deferred/fbO")
local module3 = require("@luauforge/deferred/fce")
local module4 = require("@luauforge/deferred/fcG")
local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module5 = require("@luauforge/deferred/ekv")
local module6 = require("@luauforge/deferred/fcH")

local useDispatch = module2.Hooks.RoactRodux.useDispatch

local function useShareSchool(p2)
	local v5 = useLocalization({
		linkCopied = module5.LinkCopied,
		somethingWentWrong = module5.SomethingWentWrong
	})

	local v6 = useDispatch()
	local profileCopyLinkEnabled = module4.getAppFeaturePolicies().getProfileCopyLinkEnabled()
	local ref = module.useRef(false)
	module.useEffect(function()
		return function()
			ref.current = true
		end
	end, {})

	return module.useCallback(function()
		module6({
			context = p2,
			onShared = profileCopyLinkEnabled and function()
				v6(module3.Actions.SetCurrentToastMessage({
					toastMessage = v5.linkCopied,
					isLocalized = true
				}))
			end or nil,
			onError = function()
				v6(module3.Actions.SetCurrentToastMessage({
					toastMessage = v5.somethingWentWrong,
					isLocalized = true
				}))
			end,
			isCancelledRef = ref
		})
	end, { v6, v5.linkCopied, v5.somethingWentWrong, ref, profileCopyLinkEnabled, p2 })
end

return useShareSchool
