local function makeJestCompatible(callback) -- 12 equivalent calls inferred from this helper
	return function(_, ...)
		local v = callback(...)

		return {
			pass = v.pass,
			message = function()
				return v.message
			end
		}
	end
end

local above = require(script.Parent.above)
local Jest = {
	toBeAbove = makeJestCompatible(above), -- inferred equivalent call
	toBeAlignedHorizontally = 0,
	toBeAlignedVertically = 0,
	toBeBelow = 0,
	toBeInside = 0,
	toBeInsideAbove = 0,
	toBeInsideBelow = 0,
	toBeInsideLeftOf = 0,
	toBeInsideRightOf = 0,
	toBeLeftOf = 0,
	toBeRightOf = 0,
	toIntersect = 0
}

local alignedHorizontally = require(script.Parent.alignedHorizontally)
Jest.toBeAlignedHorizontally = makeJestCompatible(alignedHorizontally) -- inferred equivalent call
local alignedVertically = require(script.Parent.alignedVertically)
Jest.toBeAlignedVertically = makeJestCompatible(alignedVertically) -- inferred equivalent call
local below = require(script.Parent.below)
Jest.toBeBelow = makeJestCompatible(below) -- inferred equivalent call
local inside = require(script.Parent.inside)
Jest.toBeInside = makeJestCompatible(inside) -- inferred equivalent call
local insideAbove = require(script.Parent.insideAbove)
Jest.toBeInsideAbove = makeJestCompatible(insideAbove) -- inferred equivalent call
local insideBelow = require(script.Parent.insideBelow)
Jest.toBeInsideBelow = makeJestCompatible(insideBelow) -- inferred equivalent call
local insideLeftOf = require(script.Parent.insideLeftOf)
Jest.toBeInsideLeftOf = makeJestCompatible(insideLeftOf) -- inferred equivalent call
local insideRightOf = require(script.Parent.insideRightOf)
Jest.toBeInsideRightOf = makeJestCompatible(insideRightOf) -- inferred equivalent call
local leftOf = require(script.Parent.leftOf)
Jest.toBeLeftOf = makeJestCompatible(leftOf) -- inferred equivalent call
local rightOf = require(script.Parent.rightOf)
Jest.toBeRightOf = makeJestCompatible(rightOf) -- inferred equivalent call
local intersect = require(script.Parent.intersect)
Jest.toIntersect = makeJestCompatible(intersect) -- inferred equivalent call
return Jest
