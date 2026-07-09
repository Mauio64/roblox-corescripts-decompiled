local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local Cryo = require(Parent.Cryo)
local SetEquippedStaticFacialAnimation = require(script.Parent.Parent.Actions.SetEquippedStaticFacialAnimation)
local updateDynamicHeadPropsInTryOn = require(script.Parent.Parent.Utils.updateDynamicHeadPropsInTryOn)
local SetOutfitTryOns = require(Parent.AvatarExperienceRodux).Actions.SetOutfitTryOns

local function SetStaticFacialAnimation(b1: boolean, _: string) -- line: 16
	-- upvalues: Cryo (copy), SetEquippedStaticFacialAnimation (copy), updateDynamicHeadPropsInTryOn (copy), SetOutfitTryOns (copy)
	return function(p1) -- line: 17
		-- upvalues: Cryo (copy), SetEquippedStaticFacialAnimation (copy), b1 (copy), updateDynamicHeadPropsInTryOn (copy), SetOutfitTryOns (copy)
		local OutfitTryOn = p1:getState().AvatarExperience.AvatarScene.OutfitTryOn
		local v11 = OutfitTryOn.TryOnItems or {}

		if Cryo.isEmpty(v11) then
			p1:dispatch(SetEquippedStaticFacialAnimation(b1))

			return
		end

		local v12 = updateDynamicHeadPropsInTryOn(v11, function() -- line: 28
			-- upvalues: b1 (copy)
			return {
				staticFacialAnimation = b1
			}
		end)
		local v13 = Cryo.Dictionary.join(OutfitTryOn, {
			TryOnItems = v12
		})

		p1:dispatch(SetOutfitTryOns(v13))
	end
end

return SetStaticFacialAnimation
