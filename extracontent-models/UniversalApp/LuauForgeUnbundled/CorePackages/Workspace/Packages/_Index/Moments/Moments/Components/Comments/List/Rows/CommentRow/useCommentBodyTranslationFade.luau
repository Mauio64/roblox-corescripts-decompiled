require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local FFlagMomentsCommentTranslation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentTranslation")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowTypes")

local v5 = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function useCommentBodyTranslationFade(p2, p3, p4)
	if not FFlagMomentsCommentTranslation then
		return p4
	end

	local ref = React.useRef(nil)

	local v6 = React.useCallback(function(p5)
		local current = ref.current

		if p5 >= 1 and current ~= nil then
			current(ReactOtter.ease(0, v5))
		end
	end, {})
	local v7, v8 = ReactOtter.useAnimatedBinding(0, v6)
	ref.current = v8

	local ref2 = React.useRef({ commentId = p2, translationState = p3 })
	React.useLayoutEffect(function()
		local current = ref2.current
		ref2.current = { commentId = p2, translationState = p3 }

		if current.commentId ~= p2 then
			v8(ReactOtter.instant(0))
		elseif current.translationState ~= nil and p3 ~= nil and current.translationState ~= p3 then
			v8(ReactOtter.instant(1))
		end
	end, { p2, p3 })

	return React.useMemo(function()
		return React.joinBindings({ style = p4, fade = v7 }):map(function(p5)
			local style = p5.style
			local transparency = style.Transparency or 0
			return {
				Color3 = style.Color3,
				Transparency = transparency + (1 - transparency) * p5.fade
			}
		end)
	end, { p4, v7 })
end

return useCommentBodyTranslationFade
