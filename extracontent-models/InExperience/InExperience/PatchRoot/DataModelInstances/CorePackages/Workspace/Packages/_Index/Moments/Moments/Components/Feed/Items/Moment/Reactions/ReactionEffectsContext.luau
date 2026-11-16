local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)

local usePreferences = Foundation.Hooks.usePreferences

local reactionsConstants = require(script.Parent.reactionsConstants)
local MAX_CONCURRENT_EXPLOSIONS = reactionsConstants.MAX_CONCURRENT_EXPLOSIONS

local context = React.createContext(nil)

local function ReactionEffectsProvider(p)
	local reducedMotion = usePreferences().reducedMotion

	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(reducedMotion)
	ref3.current = reducedMotion

	local v = React.useMemo(function()
		local signal, set = Signals.createSignal({})
		return { get = signal, set = set }
	end, {})

	local v2 = React.useMemo(function()
		return {
			spawnExplosion = function(reactionType, vector2: Vector2?)
				local current = ref2.current

				if ref3.current or current == nil then
					return
				end

				local v2 = v.get(false)

				if MAX_CONCURRENT_EXPLOSIONS <= #v2 then
					return
				end

				local originLocal

				if vector2 == nil then
					originLocal = current.AbsoluteSize / 2
				else
					originLocal = vector2 - current.AbsolutePosition
				end

				ref.current += 1
				local v3 = {
					id = ref.current,
					reactionType = reactionType,
					originLocal = originLocal
				}

				local clone = table.clone(v2)
				table.insert(clone, v3)
				v.set(clone)
			end,
			getExplosions = v.get,
			onExplosionComplete = function(p2: number)
				local v2 = v.get(false)
				local v3 = {}

				for _, v4 in v2 do
					if v4.id ~= p2 then
						table.insert(v3, v4)
					end
				end

				v.set(v3)
			end,
			layerRef = ref2
		}
	end, { v })

	return React.createElement(context.Provider, { value = v2 }, p.children)
end

return {
	Context = context,
	Provider = ReactionEffectsProvider,
	useReactionEffects = function()
		return React.useContext(context)
	end
}
