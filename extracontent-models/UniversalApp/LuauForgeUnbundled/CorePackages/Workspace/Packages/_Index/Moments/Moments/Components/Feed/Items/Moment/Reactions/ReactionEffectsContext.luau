local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local usePreferences = Foundation.Hooks.usePreferences

local MAX_CONCURRENT_EXPLOSIONS = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/reactionsConstants").MAX_CONCURRENT_EXPLOSIONS

local context = React.createContext(nil)

local function ReactionEffectsProvider(p2)
	local reducedMotion = usePreferences().reducedMotion

	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(reducedMotion)
	ref3.current = reducedMotion

	local v5 = React.useMemo(function()
		local signal, v6 = Signals.createSignal({})
		return { get = signal, set = v6 }
	end, {})

	local v6 = React.useMemo(function()
		return {
			spawnExplosion = function(p3, p4)
				local current = ref2.current

				if ref3.current or current == nil then
					return
				end

				local v7 = v5.get(false)

				if MAX_CONCURRENT_EXPLOSIONS <= #v7 then
					return
				end

				local v9 = if p4 == nil then current.AbsoluteSize / 2 else p4 - current.AbsolutePosition

				ref.current += 1
				local v11 = { id = ref.current, reactionType = p3, originLocal = v9 }

				local clone = table.clone(v7)
				table.insert(clone, v11)
				v5.set(clone)
			end,
			getExplosions = v5.get,
			onExplosionComplete = function(p3)
				local v7 = v5.get(false)
				local v8 = {}

				for k, v9 in v7 do
					if v9.id ~= p3 then
						table.insert(v8, v9)
					end
				end

				v5.set(v8)
			end,
			layerRef = ref2
		}
	end, { v5 })

	return React.createElement(context.Provider, { value = v6 }, p2.children)
end

return {
	Context = context,
	Provider = ReactionEffectsProvider,
	useReactionEffects = function()
		return React.useContext(context)
	end
}
