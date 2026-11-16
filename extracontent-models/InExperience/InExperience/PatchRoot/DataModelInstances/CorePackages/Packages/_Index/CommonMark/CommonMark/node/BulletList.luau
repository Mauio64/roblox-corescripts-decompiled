local CommonMark = script:FindFirstAncestor("CommonMark")
local ListBlock = require(CommonMark.node.ListBlock)

local function BulletList()
	local bulletList = ListBlock.new("BulletList")
	bulletList.marker = nil
	return bulletList
end

return BulletList
