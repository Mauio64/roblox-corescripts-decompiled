local ViewportAutoplayRowSpanAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayRowSpanAttribute")
local ViewportAutoplayCellVerticalPaddingAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayCellVerticalPaddingAttribute")
local ViewportAutoplayAlignmentTypeAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayAlignmentTypeAttribute")
local alignmentType = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryTypes").GameCollectionItemTypes.AlignmentType

local v5 = {}

function v5.getTileRowSpan(instance)
	local attribute = instance:GetAttribute(ViewportAutoplayRowSpanAttribute)

	if typeof(attribute) == "number" and attribute > 0 then
		return (math.floor(attribute))
	end

	return 1
end

function v5.resolveOneByOneHeight(instance, p2)
	local attribute = instance:GetAttribute(ViewportAutoplayCellVerticalPaddingAttribute)

	if typeof(attribute) == "number" and not (p2 < 2) then
		return (instance.AbsoluteSize.Y - attribute * (p2 - 1)) / p2
	end

	return nil
end

function v5.isTilePinnedLeft(instance): nil | boolean
	local attribute = instance:GetAttribute(ViewportAutoplayAlignmentTypeAttribute)

	if attribute == alignmentType.LeftPin then
		return true
	end

	if attribute == alignmentType.RightPin then
		return false
	end

	return nil
end

function v5.getReadingOrderPositions(p2, p3, p4, p5, p6)
	local y = p2.AbsolutePosition.Y
	local y2 = p2.AbsoluteSize.Y

	if p5 <= 1 or p6 == nil then
		return { y + p3 / p4 * y2 }
	end

	local v6 = (y2 - p6) / (p5 - 1)
	local v7 = p3 / p4 * p6
	local result = table.create(p5)

	for i = 0, p5 - 1 do
		result[i + 1] = y + i * v6 + v7
	end

	return result
end

function v5.computeRowAnchorOverrides(items, p2)
	local rowAnchorOverrides = {}

	for k, item in items do
		if v5.getTileRowSpan(item) ~= 2 then
			continue
		end

		local tilePinnedLeft = v5.isTilePinnedLeft(item)

		if tilePinnedLeft == nil then
			continue
		end

		local oneByOneHeight = v5.resolveOneByOneHeight(item, 2)

		if oneByOneHeight == nil then
			continue
		end

		local v6 = item.AbsoluteSize.Y - oneByOneHeight
		local y = item.AbsolutePosition.Y
		local v7 = y + item.AbsoluteSize.Y
		local v8 = (y + v7) / 2
		local v9 = if tilePinnedLeft then y else v8

		if tilePinnedLeft then
			v7 = v8
		end

		if not tilePinnedLeft then
			y += v6
		end

		local v10 = {
			{
				instance = item,
				absoluteX = item.AbsolutePosition.X,
				rowTop = y,
				naturalOffset = item.AbsolutePosition.X / p2 * oneByOneHeight
			}
		}

		for k2, item2 in items do
			if not (item2 ~= item and v5.getTileRowSpan(item2) == 1) then
				continue
			end

			local v11 = item2.AbsolutePosition.Y + item2.AbsoluteSize.Y / 2

			if v9 <= v11 and v11 <= v7 then
				table.insert(v10, {
					instance = item2,
					absoluteX = item2.AbsolutePosition.X,
					rowTop = item2.AbsolutePosition.Y,
					naturalOffset = item2.AbsolutePosition.X / p2 * item2.AbsoluteSize.Y
				})
			end
		end

		table.sort(v10, function(a, b): boolean
			return a.absoluteX < b.absoluteX
		end)

		local count = #v10

		for k2, v11 in v10 do
			local v12 = if tilePinnedLeft then (k2 - 2) % count + 1 else k2 % count + 1
			rowAnchorOverrides[v11.instance] = v11.rowTop + v10[v12].naturalOffset
		end
	end

	return rowAnchorOverrides
end

return v5
