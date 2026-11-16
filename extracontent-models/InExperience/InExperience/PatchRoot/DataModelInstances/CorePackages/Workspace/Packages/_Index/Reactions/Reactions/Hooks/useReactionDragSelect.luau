local Reactions = script:FindFirstAncestor("Reactions")
local parent = Reactions.Parent

local React = require(parent.React)

require(Reactions.Enums.ReactionType)
local playReactionHoverHaptic = require(Reactions.Utils.playReactionHoverHaptic)
local toGuiSpace = require(Reactions.Utils.toGuiSpace)

local function containsPoint(item, vector2: Vector2): boolean -- 1 equivalent call inferred from this helper
	local absolutePosition = item.AbsolutePosition
	local v = absolutePosition + item.AbsoluteSize
	return vector2.X >= absolutePosition.X and vector2.X <= v.X and vector2.Y >= absolutePosition.Y and vector2.Y <= v.Y
end

local function findReactionAt(current, vector2: Vector2)
	for k, item in current do
		if containsPoint(item, toGuiSpace(vector2, item)) then -- inferred equivalent call
			return k, item
		end
	end

	return nil, nil
end

local function useReactionDragSelect(current)
	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef({})
	local ref3 = React.useRef({})

	local state, setState = React.useState(nil)
	local ref4 = React.useRef(nil)

	local v = React.useCallback(function(current2)
		if ref4.current == current2 then
			return
		end

		ref4.current = current2
		setState(current2)

		if current2 ~= nil then
			playReactionHoverHaptic()
		end
	end, {})

	return {
		hoveredReaction = state,
		getButtonRef = React.useCallback(function(p)
			local current2 = ref3.current
			local v2 = current2[p]

			if v2 == nil then
				v2 = function(p2)
					ref2.current[p] = p2
				end
				current2[p] = v2
			end

			return v2
		end, {}),
		onDragMoved = React.useCallback(function(vector2: Vector2)
			v((findReactionAt(ref2.current, vector2)))
		end, { v }),
		onDragEnded = React.useCallback(function(vector2: Vector2?)
			v(nil)

			if vector2 == nil then
				return
			end

			local reactionAt, v2 = findReactionAt(ref2.current, vector2)

			if reactionAt ~= nil and v2 ~= nil then
				ref.current(reactionAt, v2.AbsolutePosition + v2.AbsoluteSize / 2)
			end
		end, { v })
	}
end

return useReactionDragSelect
