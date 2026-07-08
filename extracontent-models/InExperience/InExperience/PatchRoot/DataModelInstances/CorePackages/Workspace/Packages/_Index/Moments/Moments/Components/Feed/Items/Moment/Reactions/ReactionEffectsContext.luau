local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)

require(Parent.MomentsCommon)

local React = require(Parent.React)
local Signals = require(Parent.Signals)
local usePreferences = Foundation.Hooks.usePreferences
local MAX_CONCURRENT_EXPLOSIONS = require(script.Parent.reactionsConstants).MAX_CONCURRENT_EXPLOSIONS
local v7 = React.createContext(nil)

local function ReactionEffectsProvider(t1: {[any]: any}) -- line: 56
	-- upvalues: usePreferences (copy), React (copy), Signals (copy), MAX_CONCURRENT_EXPLOSIONS (copy), v7 (copy)
	local reducedMotion = usePreferences().reducedMotion
	local v11 = React.useRef(0)
	local v12 = React.useRef(nil)
	local v13 = React.useRef(reducedMotion)

	v13.current = reducedMotion

	local v14 = React.useMemo(function() -- line: 65
		-- upvalues: Signals (copy)
		local v16, v17 = Signals.createSignal({})

		return {
			get = v16,
			set = v17
		}
	end, {})
	local v15 = React.useMemo(function() -- line: 70
		-- upvalues: v12 (copy), v13 (copy), v14 (copy), MAX_CONCURRENT_EXPLOSIONS (copy), v11 (copy)
		return {
			spawnExplosion = function(p1, vector2: Vector2?) -- line: 71
				-- upvalues: v12 (copy), v13 (copy), v14 (copy), MAX_CONCURRENT_EXPLOSIONS (copy), v11 (copy)
				local current = v12.current

				if v13.current or current == nil then
					return
				end

				local v21 = v14.get(false)

				if #v21 >= MAX_CONCURRENT_EXPLOSIONS then
					return
				end

				local v22 = if vector2 == nil then current.AbsoluteSize / 2 else vector2 - current.AbsolutePosition
				local v23 = v11

				v23.current = v23.current + 1

				local t2 = {
					id = v11.current,
					reactionType = p1,
					originLocal = v22
				}
				local v25 = table.clone(v21)

				table.insert(v25, t2)
				v14.set(v25)
			end,
			getExplosions = v14.get,
			onExplosionComplete = function(n1: number) -- line: 101
				-- upvalues: v14 (copy)
				local t3 = {}

				for _, v29 in (v14.get(false)) do
					if n1 ~= v29.id then
						table.insert(t3, v29)
					end
				end

				v14.set(t3)
			end,
			layerRef = v12
		}
	end, { v14 })

	return React.createElement(v7.Provider, {
		value = v15
	}, t1.children)
end

return {
	Context = v7,
	Provider = ReactionEffectsProvider,
	useReactionEffects = function() -- line: 125
		-- upvalues: React (copy), v7 (copy)
		return React.useContext(v7)
	end
}
