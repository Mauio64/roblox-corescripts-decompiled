local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local React = require(parent2.React)
local ReactOtter = require(parent2.ReactOtter)

require(script.Parent.GalleryButtonContentView)
require(parent.Types)

local useTokens = Foundation.Hooks.useTokens

local v = { dampingRatio = 1, frequency = 4 }

local function getOtherSlot(current): number -- 1 equivalent call inferred from this helper
	return if current == 1 then 2 else 1
end

local function getThumbnailProgress(p, p2) -- 2 equivalent calls inferred from this helper
	return if p2 == 1 then p.thumbnail1 else p.thumbnail2
end

local function getProgressGoal(flag: boolean) -- 3 equivalent calls inferred from this helper
	return ReactOtter.spring(flag and 1 or 0, v)
end

local function createThumbnailBindings(object, p)
	return {
		style = object:map(function(p2)
			return {
				Color3 = Color3.new(1, 1, 1),
				Transparency = 1 - math.clamp(getThumbnailProgress(p2, p), 0, 1) -- inferred equivalent call
			}
		end),
		scale = object:map(function(p2)
			return (math.lerp(0.5, 1, (math.clamp(getThumbnailProgress(p2, p), 0, 1)))) -- inferred equivalent call
		end)
	}
end

local function useGalleryButtonContentViewModel(current)
	local v2 = useTokens()

	local state, setState = React.useState(1)
	local state2, setState2 = React.useState({ current })
	local ref = React.useRef(1)
	local ref2 = React.useRef(current)

	local v3 = React.useCallback(function()
		setState2(function(p)
			if current then
				return { [state] = p[state] }
			end

			return {}
		end)
	end, { current, state })

	local v4, v5 = ReactOtter.useAnimatedBinding({
		icon = current and 1 or 0,
		thumbnail1 = current and 1 or 0,
		thumbnail2 = 0
	}, v3)

	React.useEffect(function()
		local current2 = ref2.current
		ref2.current = current

		if current2 == current then
			return
		end

		local current3 = ref.current

		if current2 and current then
			current3 = getOtherSlot(current3) -- inferred equivalent call
			ref.current = current3
		end

		if current then
			setState2(function(p)
				local clone = table.clone(p)
				clone[current3] = current
				return clone
			end)
		end

		setState(current3)
		v5({
			icon = getProgressGoal(current ~= nil), -- inferred equivalent call
			thumbnail1 = getProgressGoal(current ~= nil and current3 == 1), -- inferred equivalent call
			thumbnail2 = getProgressGoal(current ~= nil and current3 == 2) -- inferred equivalent call
		})
	end, { current })

	local emphasis = v2.Color.Content.Emphasis

	local v6 = React.useMemo(function()
		return {
			iconStyle = v4:map(function(p)
				return {
					Color3 = emphasis.Color3,
					Transparency = math.lerp(emphasis.Transparency, 1, (math.clamp(p.icon, 0, 1)))
				}
			end),
			iconScale = v4:map(function(p)
				return (math.lerp(1, 0.5, (math.clamp((p.icon - 0.1) / 0.9, 0, 1))))
			end),
			thumbnails = { createThumbnailBindings(v4, 1), (createThumbnailBindings(v4, 2)) }
		}
	end, { v4, emphasis })

	return {
		activeSlot = state,
		slotCaptures = state2,
		iconStyle = v6.iconStyle,
		iconScale = v6.iconScale,
		thumbnails = v6.thumbnails
	}
end

return useGalleryButtonContentViewModel
