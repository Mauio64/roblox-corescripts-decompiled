local function makeJestCompatible(p1) -- line: 1
	return function(_, ...) -- line: 2
		-- upvalues: p1 (copy)
		local v41 = p1(...)

		return {
			pass = v41.pass,
			message = function() -- line: 7
				-- upvalues: v41 (copy)
				return v41.message
			end
		}
	end
end

local t1 = {}
local above = require(script.Parent.above)

function t1.toBeAbove(_, ...) -- line: 2
	-- upvalues: above (copy)
	local v17 = above(...)

	return {
		pass = v17.pass,
		message = function() -- line: 7
			-- upvalues: v17 (copy)
			return v17.message
		end
	}
end

local alignedHorizontally = require(script.Parent.alignedHorizontally)

function t1.toBeAlignedHorizontally(_, ...) -- line: 2
	-- upvalues: alignedHorizontally (copy)
	local v19 = alignedHorizontally(...)

	return {
		pass = v19.pass,
		message = function() -- line: 7
			-- upvalues: v19 (copy)
			return v19.message
		end
	}
end

local alignedVertically = require(script.Parent.alignedVertically)

function t1.toBeAlignedVertically(_, ...) -- line: 2
	-- upvalues: alignedVertically (copy)
	local v21 = alignedVertically(...)

	return {
		pass = v21.pass,
		message = function() -- line: 7
			-- upvalues: v21 (copy)
			return v21.message
		end
	}
end

local below = require(script.Parent.below)

function t1.toBeBelow(_, ...) -- line: 2
	-- upvalues: below (copy)
	local v23 = below(...)

	return {
		pass = v23.pass,
		message = function() -- line: 7
			-- upvalues: v23 (copy)
			return v23.message
		end
	}
end

local inside = require(script.Parent.inside)

function t1.toBeInside(_, ...) -- line: 2
	-- upvalues: inside (copy)
	local v25 = inside(...)

	return {
		pass = v25.pass,
		message = function() -- line: 7
			-- upvalues: v25 (copy)
			return v25.message
		end
	}
end

local insideAbove = require(script.Parent.insideAbove)

function t1.toBeInsideAbove(_, ...) -- line: 2
	-- upvalues: insideAbove (copy)
	local v27 = insideAbove(...)

	return {
		pass = v27.pass,
		message = function() -- line: 7
			-- upvalues: v27 (copy)
			return v27.message
		end
	}
end

local insideBelow = require(script.Parent.insideBelow)

function t1.toBeInsideBelow(_, ...) -- line: 2
	-- upvalues: insideBelow (copy)
	local v29 = insideBelow(...)

	return {
		pass = v29.pass,
		message = function() -- line: 7
			-- upvalues: v29 (copy)
			return v29.message
		end
	}
end

local insideLeftOf = require(script.Parent.insideLeftOf)

function t1.toBeInsideLeftOf(_, ...) -- line: 2
	-- upvalues: insideLeftOf (copy)
	local v31 = insideLeftOf(...)

	return {
		pass = v31.pass,
		message = function() -- line: 7
			-- upvalues: v31 (copy)
			return v31.message
		end
	}
end

local insideRightOf = require(script.Parent.insideRightOf)

function t1.toBeInsideRightOf(_, ...) -- line: 2
	-- upvalues: insideRightOf (copy)
	local v33 = insideRightOf(...)

	return {
		pass = v33.pass,
		message = function() -- line: 7
			-- upvalues: v33 (copy)
			return v33.message
		end
	}
end

local leftOf = require(script.Parent.leftOf)

function t1.toBeLeftOf(_, ...) -- line: 2
	-- upvalues: leftOf (copy)
	local v35 = leftOf(...)

	return {
		pass = v35.pass,
		message = function() -- line: 7
			-- upvalues: v35 (copy)
			return v35.message
		end
	}
end

local rightOf = require(script.Parent.rightOf)

function t1.toBeRightOf(_, ...) -- line: 2
	-- upvalues: rightOf (copy)
	local v37 = rightOf(...)

	return {
		pass = v37.pass,
		message = function() -- line: 7
			-- upvalues: v37 (copy)
			return v37.message
		end
	}
end

local intersect = require(script.Parent.intersect)

function t1.toIntersect(_, ...) -- line: 2
	-- upvalues: intersect (copy)
	local v39 = intersect(...)

	return {
		pass = v39.pass,
		message = function() -- line: 7
			-- upvalues: v39 (copy)
			return v39.message
		end
	}
end

return t1
