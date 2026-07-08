local function parsePath(p1) -- line: 4
	local parts = string.split(p1, "/")

	for i = #parts, 1, -1 do
		if parts[i] == "" then
			table.remove(parts, i)
		end
	end

	return parts
end
local function isManifestResolved(p2, p3) -- line: 14
	local n1 = 0

	for _ in pairs(p2) do
		n1 += 1
	end

	assert(n1 <= p3, n1)

	return n1 == p3
end
local function unbindNodeDescend(p4, p5) -- line: 24
	-- upvalues: unbindNodeDescend (copy)
	if p4.instance == nil then
		return
	end

	p4.instance = nil

	local connections = p4.connections

	if connections then
		for _, v in ipairs(connections) do
			v:Disconnect()
		end

		table.clear(connections)
	end

	if p5 and p4.alias then
		p5[p4.alias] = nil
	end

	local children = p4.children

	if children then
		for _, v in pairs(children) do
			unbindNodeDescend(v, p5)
		end
	end
end

local t1 = {}

t1.__index = t1

function t1.new(p6, p7) -- line: 54
	-- upvalues: parsePath (copy), t1 (copy)
	local t2 = {}
	local n2 = 1

	for k, v in pairs(p6) do
		t2[k] = parsePath(v)
		n2 += 1
	end

	return (setmetatable({
		_boundFn = p7,
		_parsedManifest = t2,
		_manifestSizeTarget = n2,
		_dtorMap = {},
		_connections = {},
		_rootInstToRootNode = {},
		_rootInstToManifest = {}
	}, t1))
end
function t1._startBoundFn(p8, p9, p10) -- line: 80
	local _boundFn = p8._boundFn
	local _dtorMap = p8._dtorMap
	local v31 = _dtorMap[p9]

	if v31 then
		v31()
		_dtorMap[p9] = nil
	end

	local v32 = _boundFn(p10)

	if v32 then
		_dtorMap[p9] = v32
	end
end
function t1._stopBoundFn(p11, p12) -- line: 96
	local _dtorMap = p11._dtorMap
	local v36 = _dtorMap[p12]

	if v36 then
		v36()
		_dtorMap[p12] = nil
	end
end
function t1.bindRoot(p13, p14) -- line: 106
	-- upvalues: unbindNodeDescend (copy)
	debug.profilebegin("AtomicBinding:BindRoot")

	local _parsedManifest = p13._parsedManifest
	local _rootInstToRootNode = p13._rootInstToRootNode
	local _rootInstToManifest = p13._rootInstToManifest
	local _manifestSizeTarget = p13._manifestSizeTarget

	if _rootInstToManifest[p14] ~= nil then
		return
	end

	local t3 = {}

	_rootInstToManifest[p14] = t3
	debug.profilebegin("BuildTree")

	local t4 = {
		alias = "root",
		instance = p14
	}

	if next(_parsedManifest) then
		t4.children = {}
		t4.connections = {}
	end

	_rootInstToRootNode[p14] = t4

	for k, v in pairs(_parsedManifest) do
		local v47 = t4

		for i, v2 in ipairs(v) do
			local v50 = i == #v
			local v51 = v47.children[v2] or {}

			if v50 then
				if v51.alias ~= nil then
					error("Multiple aliases assigned to one instance")
				end

				v51.alias = k
			else
				v51.children = v51.children or {}
				v51.connections = v51.connections or {}
			end

			v47.children[v2] = v51
			v47 = v51
		end
	end

	debug.profileend()

	local function processNode(p15) -- line: 161
		-- upvalues: t3 (copy), processNode (copy), p13 (copy), p14 (copy), unbindNodeDescend (copy), _manifestSizeTarget (copy)
		local v69 = assert(p15.instance, "instance does not exist")
		local children = p15.children
		local alias = p15.alias
		local v72 = not children

		if alias then
			t3[alias] = v69
		end

		if not v72 then
			local function processAddChild(p16) -- line: 173
				-- upvalues: children (copy), processNode (copy)
				local v83 = children[p16.Name]

				if not v83 or v83.instance ~= nil then
					return
				end

				v83.instance = p16
				processNode(v83)
			end
			local function processDeleteChild(p17) -- line: 184
				-- upvalues: children (copy), p13 (copy), p14 (copy), unbindNodeDescend (copy), t3 (copy), v69 (copy), processNode (copy)
				local p17Name = p17.Name
				local v86 = children[p17Name]

				if not v86 then
					return
				end

				if p17 ~= v86.instance then
					return
				end

				p13:_stopBoundFn(p14)
				unbindNodeDescend(v86, t3)
				assert(v86.instance == nil, "unbindNodeDescend failed")

				local p17Name2 = v69:FindFirstChild(p17Name)

				if p17Name2 then
					local v88 = children[p17Name2.Name]

					if v88 then
						if v88.instance ~= nil then
							return
						end

						v88.instance = p17Name2
						processNode(v88)
					end
				end
			end

			for _, child in ipairs(v69:GetChildren()) do
				local v77 = children[child.Name]

				if v77 and v77.instance == nil then
					v77.instance = child
					processNode(v77)
				end
			end

			table.insert(p15.connections, v69.ChildAdded:Connect(processAddChild))
			table.insert(p15.connections, v69.ChildRemoved:Connect(processDeleteChild))
		end

		if v72 then
			local v78 = t3
			local v79 = _manifestSizeTarget
			local n3 = 0

			for _ in pairs(v78) do
				n3 += 1
			end

			assert(n3 <= v79, n3)

			if n3 == v79 then
				p13:_startBoundFn(p14, t3)
			end
		end
	end

	debug.profilebegin("ResolveTree")
	processNode(t4)
	debug.profileend()
	debug.profileend()
end
function t1.unbindRoot(p18, p19) -- line: 237
	-- upvalues: unbindNodeDescend (copy)
	local _rootInstToRootNode = p18._rootInstToRootNode
	local _rootInstToManifest = p18._rootInstToManifest

	p18:_stopBoundFn(p19)

	local v57 = _rootInstToRootNode[p19]

	if v57 then
		local v58 = assert(_rootInstToManifest[p19], "rootInstToManifest is nil")

		unbindNodeDescend(v57, v58)
		_rootInstToRootNode[p19] = nil
	end

	_rootInstToManifest[p19] = nil
end
function t1.destroy(p20) -- line: 253
	-- upvalues: unbindNodeDescend (copy)
	debug.profilebegin("AtomicBinding:destroy")

	for _, v in pairs(p20._dtorMap) do
		v:destroy()
	end

	table.clear(p20._dtorMap)

	for _, v in ipairs(p20._connections) do
		v:Disconnect()
	end

	table.clear(p20._connections)

	local _rootInstToManifest = p20._rootInstToManifest

	for k, v in pairs(p20._rootInstToRootNode) do
		local v67 = assert(_rootInstToManifest[k], "rootInstToManifest is nil")

		unbindNodeDescend(v, v67)
	end

	table.clear(p20._rootInstToManifest)
	table.clear(p20._rootInstToRootNode)
	debug.profileend()
end

return t1
