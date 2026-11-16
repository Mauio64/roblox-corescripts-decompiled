local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")

require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")
local playReactionHoverHaptic = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/playReactionHoverHaptic")
local toGuiSpace = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/toGuiSpace")

local function containsPoint(p2, p3): boolean
	local absolutePosition = p2.AbsolutePosition
	local v5 = absolutePosition + p2.AbsoluteSize
	return p3.X >= absolutePosition.X and p3.X <= v5.X and p3.Y >= absolutePosition.Y and p3.Y <= v5.Y
end

local function findReactionAt(current, p2)
	for k, item in current do
		local v5 = toGuiSpace(p2, item)
		local absolutePosition = item.AbsolutePosition
		local v6 = absolutePosition + item.AbsoluteSize
		local v7

		if v5.X >= absolutePosition.X and v5.X <= v6.X and v5.Y >= absolutePosition.Y then
			v7 = v5.Y <= v6.Y
		else
			v7 = false
		end

		if v7 then
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

	local v5 = React.useCallback(function(current2)
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
		getButtonRef = React.useCallback(function(p2)
			local current2 = ref3.current
			local v6 = current2[p2]

			if v6 == nil then
				v6 = function(p3)
					ref2.current[p2] = p3
				end
				current2[p2] = v6
			end

			return v6
		end, {}),
		onDragMoved = React.useCallback(function(p2)
			v5((findReactionAt(ref2.current, p2)))
		end, { v5 }),
		onDragEnded = React.useCallback(function(p2)
			v5(nil)

			if p2 == nil then
				return
			end

			local reactionAt, v6 = findReactionAt(ref2.current, p2)

			if reactionAt ~= nil and v6 ~= nil then
				ref.current(reactionAt, v6.AbsolutePosition + v6.AbsoluteSize / 2)
			end
		end, { v5 })
	}
end

return useReactionDragSelect
