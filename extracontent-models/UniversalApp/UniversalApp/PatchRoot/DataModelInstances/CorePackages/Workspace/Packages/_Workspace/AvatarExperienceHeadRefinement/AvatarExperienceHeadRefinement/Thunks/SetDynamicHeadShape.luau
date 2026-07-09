local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local Cryo = require(Parent.Cryo)
local SetOutfitTryOns = require(Parent.AvatarExperienceRodux).Actions.SetOutfitTryOns
local SetEquippedDynamicHeadShape = require(script.Parent.Parent.Actions.SetEquippedDynamicHeadShape)
local updateDynamicHeadPropsInTryOn = require(script.Parent.Parent.Utils.updateDynamicHeadPropsInTryOn)

return function(s1: string, _: string) -- line: 18
	-- upvalues: Cryo (copy), SetEquippedDynamicHeadShape (copy), updateDynamicHeadPropsInTryOn (copy), SetOutfitTryOns (copy)
	return function(p1) -- line: 19
		-- upvalues: Cryo (copy), SetEquippedDynamicHeadShape (copy), s1 (copy), updateDynamicHeadPropsInTryOn (copy), SetOutfitTryOns (copy)
		local OutfitTryOn = p1:getState().AvatarExperience.AvatarScene.OutfitTryOn
		local v10 = OutfitTryOn.TryOnItems or {}

		if Cryo.isEmpty(v10) then
			p1:dispatch(SetEquippedDynamicHeadShape(s1))

			return
		end

		local v11 = updateDynamicHeadPropsInTryOn(v10, function() -- line: 30
			-- upvalues: s1 (copy)
			return {
				headShape = s1
			}
		end)
		local v12 = Cryo.Dictionary.join(OutfitTryOn, {
			TryOnItems = v11
		})

		p1:dispatch(SetOutfitTryOns(v12))
	end
end
