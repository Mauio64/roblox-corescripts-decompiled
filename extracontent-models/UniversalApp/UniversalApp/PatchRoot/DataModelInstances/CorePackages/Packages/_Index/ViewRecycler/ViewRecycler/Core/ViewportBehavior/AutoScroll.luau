local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local AutoScrollPolicy = require(ViewRecycler.Core.Enums.AutoScrollPolicy)
local AutoScrollTarget = require(ViewRecycler.Core.Enums.AutoScrollTarget)
require(ViewRecycler.Core.Types)

local AutoScroll = {}

function AutoScroll.followedEdge(p)
	if p == AutoScrollPolicy.WhenAtStart then
		return AutoScrollTarget.Start
	end

	if p == AutoScrollPolicy.WhenAtEnd then
		return AutoScrollTarget.End
	end

	return nil
end

function AutoScroll.distanceFromEdge(p, p2)
	if p == AutoScrollTarget.Start then
		return p2.scrollOffset
	end

	return p2.distanceFromEnd
end

function AutoScroll.validate(p)
	assert(
		p == nil or AutoScroll.followedEdge(p) ~= nil,
		"Virtualizer: autoScrollOnChange must be AutoScrollPolicy.WhenAtStart or AutoScrollPolicy.WhenAtEnd"
	)
end

function AutoScroll.resolveTarget(p, p2, p3: number)
	local followedEdge = AutoScroll.followedEdge(p)
	return followedEdge ~= nil and AutoScroll.distanceFromEdge(followedEdge, p2) <= p3 and followedEdge
end

function AutoScroll.getTargetOffset(p, p2: number, p3: number)
	if p == AutoScrollTarget.Start then
		return 0
	end

	return (math.max(0, p2 - p3))
end

function AutoScroll.create()
	local v = nil
	local v2 = false

	local function settle(p) -- 2 equivalent calls inferred from this helper
		v2 = v2 and p == v
		v = p
	end

	return {
		onDataSourceChanged = function(p)
			if p == false then
				if v2 then
					return v
				end

				v2 = v2 and v == nil
				v = nil

				return false
			end

			settle(p) -- inferred equivalent call
			return p
		end,
		settleAt = settle,
		pin = function(p)
			v = p
			v2 = true
		end,
		getSettleOffset = function(p, p2)
			local v3 = v

			if v3 == nil then
				return nil
			end

			return AutoScroll.getTargetOffset(v3, p, p2)
		end,
		onScrollOffsetChanged = function(p, p2, p3)
			local v3 = v

			if v3 ~= nil and AutoScroll.distanceFromEdge(v3, p) <= p2 then
				return
			end

			if p3 == nil or not (AutoScroll.distanceFromEdge(p3, p) <= p2) then
				v2 = v2 and v == nil
				v = nil
			else
				settle(p3) -- inferred equivalent call
			end
		end
	}
end

return AutoScroll
