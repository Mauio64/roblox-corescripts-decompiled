local module = require("@luauforge/bundled/drY")
local useDispatch = require("@luauforge/bundled/dsv").Hooks.RoactRodux.useDispatch
local module2 = require("@luauforge/bundled/dvh")
local openAmpWizardContainer = module2.OpenAmpWizardContainer
local accessResponseEnum = module2.AmpEnums.AccessResponseEnum
local socialUpsellAnalytics = require("@luauforge/bundled/dvf").Analytics.SocialUpsellAnalytics

local defineFastFlag = game:DefineFastFlag("LuaAppAddCarouselAmpUpsellAccessResponses", false)

local defineFastString = game:DefineFastString(
	"LuaAppGameCarouselAmpUpsellActionAccessResponses",
	"Granted"
)
local v5 = defineFastFlag and "," or nil
local fn = defineFastFlag and function(value, p2)
	if not value or value == "" then
		return {}
	end

	local v6 = string.split(value, p2)
	local result = {}

	for k, v7 in v6 do
		if v7 ~= "" then
			table.insert(result, v7)
		end
	end

	return result
end or nil

return function(p2, p3, callback, p4, data)
	local v6 = useDispatch()
	local v7

	if defineFastFlag then
		v7 = module.useMemo(function()
			return fn(defineFastString, v5)
		end, {})
	else
		v7 = nil
	end

	local function fn2()
		if not p2 or p2 == "" then
			return nil
		end

		local function fn3(p5, p6)
			if defineFastFlag then
				if callback then
					for k, v8 in v7 do
						if p5 == v8 then
							callback()
							return
						end
					end
				end
			elseif callback and p5 == accessResponseEnum.Granted then
				callback()
			end
		end
		return function()
			v6(openAmpWizardContainer(p2, fn3, nil, p4, nil, p3))

			if data then
				socialUpsellAnalytics.logUpsellEvent("socialUpsellButtonClick", {
					upsellEntrySurface = data.upsellEntrySurface,
					upsellComponent = data.upsellComponent,
					upsellStage = data.upsellStage,
					upsellPurpose = data.upsellPurpose
				})
			end
		end
	end

	return module.useMemo(fn2, {
		p2,
		p3,
		callback,
		p4,
		v6,
		if defineFastFlag then v7 else nil,
		data
	})
end
