local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local ViewportAutoplayRowSpanAttribute = require(VideoUtils.ViewportAutoplayRowSpanAttribute)
local ViewportAutoplayCellVerticalPaddingAttribute = require(VideoUtils.ViewportAutoplayCellVerticalPaddingAttribute)
local ViewportAutoplayAlignmentTypeAttribute = require(VideoUtils.ViewportAutoplayAlignmentTypeAttribute)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local AlignmentType = DiscoveryTypes.GameCollectionItemTypes.AlignmentType

local ViewportAutoplayHelpers = {}

function ViewportAutoplayHelpers.getTileRowSpan(instance)
	local attribute = instance:GetAttribute(ViewportAutoplayRowSpanAttribute)

	if typeof(attribute) == "number" and attribute > 0 then
		return (math.floor(attribute))
	end

	return 1
end

function ViewportAutoplayHelpers.resolveOneByOneHeight(instance, p: number)
	local attribute = instance:GetAttribute(ViewportAutoplayCellVerticalPaddingAttribute)

	if typeof(attribute) == "number" and not (p < 2) then
		return (instance.AbsoluteSize.Y - attribute * (p - 1)) / p
	end

	return nil
end

function ViewportAutoplayHelpers.isTilePinnedLeft(instance): nil | boolean
	local attribute = instance:GetAttribute(ViewportAutoplayAlignmentTypeAttribute)

	if attribute == AlignmentType.LeftPin then
		return true
	end

	return if attribute == AlignmentType.RightPin then false else nil
end

function ViewportAutoplayHelpers.getReadingOrderPositions(p, p2: number, p3: number, p4: number, p5: number?)
	local y = p.AbsolutePosition.Y
	local y2 = p.AbsoluteSize.Y

	if p4 <= 1 or p5 == nil then
		return { y + p2 / p3 * y2 }
	end

	local v = (y2 - p5) / (p4 - 1)
	local v2 = p2 / p3 * p5
	local result = table.create(p4)

	for i = 0, p4 - 1 do
		result[i + 1] = y + i * v + v2
	end

	return result
end

function ViewportAutoplayHelpers.computeRowAnchorOverrides(items, p: number)
	local rowAnchorOverrides = {}

	for _, item in items do
		if ViewportAutoplayHelpers.getTileRowSpan(item) ~= 2 then
			continue
		end

		local tilePinnedLeft = ViewportAutoplayHelpers.isTilePinnedLeft(item)

		if tilePinnedLeft == nil then
			continue
		end

		local oneByOneHeight = ViewportAutoplayHelpers.resolveOneByOneHeight(item, 2)

		if oneByOneHeight == nil then
			continue
		end

		local v = item.AbsoluteSize.Y - oneByOneHeight
		local y = item.AbsolutePosition.Y
		local v2 = y + item.AbsoluteSize.Y
		local midpoint = (y + v2) / 2
		local v3 = if tilePinnedLeft then y else midpoint

		if tilePinnedLeft then
			v2 = midpoint
		end

		if not tilePinnedLeft then
			y += v
		end

		local v4 = {
			{
				instance = item,
				absoluteX = item.AbsolutePosition.X,
				rowTop = y,
				naturalOffset = item.AbsolutePosition.X / p * oneByOneHeight
			}
		}

		for _, item2 in items do
			if not (item2 ~= item and ViewportAutoplayHelpers.getTileRowSpan(item2) == 1) then
				continue
			end

			local v5 = item2.AbsolutePosition.Y + item2.AbsoluteSize.Y / 2

			if v3 <= v5 and v5 <= v2 then
				table.insert(v4, {
					instance = item2,
					absoluteX = item2.AbsolutePosition.X,
					rowTop = item2.AbsolutePosition.Y,
					naturalOffset = item2.AbsolutePosition.X / p * item2.AbsoluteSize.Y
				})
			end
		end

		table.sort(v4, function(a, b): boolean
			return a.absoluteX < b.absoluteX
		end)

		local count = #v4

		for k, v5 in v4 do
			local v6

			if tilePinnedLeft then
				v6 = (k - 2) % count + 1
			else
				v6 = k % count + 1
			end

			rowAnchorOverrides[v5.instance] = v5.rowTop + v4[v6].naturalOffset
		end
	end

	return rowAnchorOverrides
end

return ViewportAutoplayHelpers
