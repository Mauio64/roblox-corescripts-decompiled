local module = require("@luauforge/deferred/egU")
local module2 = require("@luauforge/deferred/eUP")
local module3 = require("@luauforge/deferred/eVf")
local module4 = require("@luauforge/deferred/eVH")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module5 = require("@luauforge/deferred/ehb")
local module6 = require("@luauforge/deferred/eVI")

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
