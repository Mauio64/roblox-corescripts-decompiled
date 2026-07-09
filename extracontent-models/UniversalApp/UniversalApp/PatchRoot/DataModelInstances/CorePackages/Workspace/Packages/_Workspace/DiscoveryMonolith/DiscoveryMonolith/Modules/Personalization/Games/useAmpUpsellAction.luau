local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local AmpUpsell = require(Parent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local SocialUpsellAnalytics = require(Parent.SocialUpsell).Analytics.SocialUpsellAnalytics
local v8 = game:DefineFastFlag("LuaAppAddCarouselAmpUpsellAccessResponses", false)
local v9 = game:DefineFastString("LuaAppGameCarouselAmpUpsellActionAccessResponses", "Granted")
local FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics = require(Parent.SharedFlags).FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics
local v11 = if not FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics then nil else "socialUpsellButtonClick"
local v12 = if not v8 then nil else ","
local v13 = if not v8 then nil else function(s1: string, s2: string) -- line: 31
	if not s1 or s1 == "" then
		return {}
	end

	local t1 = {}

	for _, v18 in (string.split(s1, s2)) do
		if v18 ~= "" then
			table.insert(t1, v18)
		end
	end

	return t1
end

return function(s3: string?, s4: string?, p1: ((...any) -> ...any)?, s5: string?, t2: {[any]: any}?) -- line: 48
	-- upvalues: useDispatch (copy), v8 (copy), React (copy), v13 (copy), v9 (copy), v12 (copy), AccessResponseEnum (copy), OpenAmpWizardContainer (copy), FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics (copy), SocialUpsellAnalytics (copy), v11 (copy)
	local v24 = useDispatch()
	local v25 = if not v8 then nil else React.useMemo(function() -- line: 58
		-- upvalues: v13 (copy), v9 (copy), v12 (copy)
		return v13(v9, v12)
	end, {})

	return React.useMemo(function() -- line: 64
		-- upvalues: s3 (copy), v8 (copy), p1 (copy), v25 (copy), AccessResponseEnum (copy), v24 (copy), OpenAmpWizardContainer (copy), s5 (copy), s4 (copy), FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics (copy), t2 (copy), SocialUpsellAnalytics (copy), v11 (copy)
		if not s3 or s3 == "" then
			return nil
		end

		local function v26(p2, _) -- line: 68
			-- upvalues: v8 (copy), p1 (copy), v25 (copy), AccessResponseEnum (copy)
			if v8 then
				if p1 then
					for _, v30 in v25 do
						if p2 == v30 then
							p1()

							return
						end
					end

					return
				end
			elseif p1 and p2 == AccessResponseEnum.Granted then
				p1()
			end
		end

		return function() -- line: 84
			-- upvalues: v24 (copy), OpenAmpWizardContainer (copy), s3 (copy), v26 (copy), s5 (copy), s4 (copy), FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics (copy), t2 (copy), SocialUpsellAnalytics (copy), v11 (copy)
			v24(OpenAmpWizardContainer(s3, v26, nil, s5, nil, s4))

			if FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics and t2 then
				SocialUpsellAnalytics.logUpsellEvent(v11, {
					upsellEntrySurface = t2.upsellEntrySurface,
					upsellComponent = t2.upsellComponent,
					upsellStage = t2.upsellStage,
					upsellPurpose = t2.upsellPurpose
				})
			end
		end
	end, {
		s3,
		s4,
		p1,
		s5,
		v24,
		if not v8 then nil else v25,
		if not FFlagLuaAppCarouselAmpUpsellSubtitleClickAnalytics then nil else t2
	})
end
