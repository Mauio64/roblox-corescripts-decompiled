local ItemType = { Invalid = "Invalid", CollectibleItem = "CollectibleItem" }

local set = {}

for _, v in pairs(ItemType) do
	set[v] = true
end

function ItemType.fromValue(p: string?)
	return if not (p == nil or not set[p]) then p else nil
end

return ItemType
