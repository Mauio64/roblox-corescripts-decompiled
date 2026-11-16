local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local FFlagMomentsCommentTranslation = require(Moments.Flags.FFlagMomentsCommentTranslation)
require(script.Parent.Parent.CommentRowTypes)

local v = { duration = 0.15, easingStyle = Enum.EasingStyle.Quad }

local function useCommentBodyTranslationFade(commentId: string, translationState, style2)
	if not FFlagMomentsCommentTranslation then
		return style2
	end

	local ref = React.useRef(nil)

	local v2 = React.useCallback(function(p: number)
		local current = ref.current

		if p >= 1 and current ~= nil then
			current((ReactOtter.ease(0, v)))
		end
	end, {})
	local fade, current2 = ReactOtter.useAnimatedBinding(0, v2)
	ref.current = current2

	local ref2 = React.useRef({ commentId = commentId, translationState = translationState })
	React.useLayoutEffect(function()
		local current = ref2.current
		ref2.current = { commentId = commentId, translationState = translationState }

		if current.commentId ~= commentId then
			current2((ReactOtter.instant(0)))
		elseif
			current.translationState ~= nil
			and translationState ~= nil
			and current.translationState ~= translationState
		then
			current2((ReactOtter.instant(1)))
		end
	end, { commentId, translationState })

	return React.useMemo(function()
		return React.joinBindings({ style = style2, fade = fade }):map(function(p)
			local style = p.style
			local transparency = style.Transparency or 0
			return {
				Color3 = style.Color3,
				Transparency = transparency + (1 - transparency) * p.fade
			}
		end)
	end, { style2, fade })
end

return useCommentBodyTranslationFade
