local v = {}
local PreviewImageRegistry = {}

function PreviewImageRegistry.register(p: string, p2)
	v[p] = p2
end

function PreviewImageRegistry.resolve(p: string)
	return v[p]
end

function PreviewImageRegistry.destroy(p: string)
	local v2 = v[p]

	if v2 then
		v[p] = nil
		v2:Destroy()
	end
end

function PreviewImageRegistry.clear()
	local v2 = v
	v = {}

	for _, v3 in v2 do
		v3:Destroy()
	end
end

return PreviewImageRegistry
