local HttpService = game:GetService("HttpService")

local function stripMeshFromGltf(json: string)
	local jsonDecode = HttpService:JSONDecode(json)

	jsonDecode.meshes = nil
	jsonDecode.materials = nil
	jsonDecode.textures = nil
	jsonDecode.images = nil
	jsonDecode.skins = nil

	if jsonDecode.nodes then
		local set = {}
		local nodes = {}
		local v = {}

		for i, node in ipairs(jsonDecode.nodes) do
			if node.name and string.find(node.name, "_Geo$") then
				set[i] = true
			end
		end

		local count = 0

		for i, node in ipairs(jsonDecode.nodes) do
			if set[i] then
				continue
			end

			node.mesh = nil
			node.skin = nil

			if node.children then
				local children = {}

				for _, child in ipairs(node.children) do
					if not set[child + 1] then
						table.insert(children, child)
					end
				end

				if not (#children > 0) then
					children = nil
				end

				node.children = children
			end

			table.insert(nodes, node)
			v[i] = count
			count += 1
		end

		for _, v2 in ipairs(nodes) do
			if not v2.children then
				continue
			end

			for i, child in ipairs(v2.children) do
				local v3 = child + 1

				if v[v3] then
					v2.children[i] = v[v3]
				end
			end
		end

		if jsonDecode.animations then
			for _, animation in ipairs(jsonDecode.animations) do
				if not animation.channels then
					continue
				end

				for _, channel in ipairs(animation.channels) do
					if not (channel.target and channel.target.node) then
						continue
					end

					local v2 = channel.target.node + 1

					if v[v2] then
						channel.target.node = v[v2]
					end
				end
			end
		end

		if jsonDecode.scenes then
			for _, scene in ipairs(jsonDecode.scenes) do
				if not scene.nodes then
					continue
				end

				local nodes2 = {}

				for _, node in ipairs(scene.nodes) do
					local v2 = node + 1

					if v[v2] then
						table.insert(nodes2, v[v2])
					end
				end

				scene.nodes = nodes2
			end
		end

		jsonDecode.nodes = nodes
	end

	return HttpService:JSONEncode(jsonDecode)
end

return stripMeshFromGltf
