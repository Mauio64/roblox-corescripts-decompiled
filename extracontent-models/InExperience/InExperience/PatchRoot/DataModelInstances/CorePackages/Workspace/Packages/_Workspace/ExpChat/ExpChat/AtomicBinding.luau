local function parsePath(item)
	local path = string.split(item, "/")

	for i = #path, 1, -1 do
		if path[i] == "" then
			table.remove(path, i)
		end
	end

	return path
end

local function isManifestResolved(items, manifestSizeTarget): boolean -- 1 equivalent call inferred from this helper
	local count = 0

	for _ in pairs(items) do
		count += 1
	end

	assert(count <= manifestSizeTarget, count)
	return count == manifestSizeTarget
end

local function unbindNodeDescend(state, p)
	if state.instance == nil then
		return
	end

	state.instance = nil

	local connections = state.connections

	if connections then
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end

		table.clear(connections)
	end

	if p and state.alias then
		p[state.alias] = nil
	end

	local children = state.children

	if children then
		for _, child in pairs(children) do
			unbindNodeDescend(child, p)
		end
	end
end

local AtomicBinding = {}
AtomicBinding.__index = AtomicBinding

function AtomicBinding.new(items, boundFn)
	local parsedManifest = {}
	local manifestSizeTarget = 1

	for k, item in pairs(items) do
		parsedManifest[k] = parsePath(item)
		manifestSizeTarget += 1
	end

	return (setmetatable({
		_boundFn = boundFn,
		_parsedManifest = parsedManifest,
		_manifestSizeTarget = manifestSizeTarget,
		_dtorMap = {},
		_connections = {},
		_rootInstToRootNode = {},
		_rootInstToManifest = {}
	}, AtomicBinding))
end

function AtomicBinding:_startBoundFn(p, p2)
	local boundFn = self._boundFn
	local dtorMap = self._dtorMap

	local dtor = dtorMap[p]

	if dtor then
		dtor()
		dtorMap[p] = nil
	end

	local v = boundFn(p2)

	if v then
		dtorMap[p] = v
	end
end

function AtomicBinding:_stopBoundFn(p)
	local dtorMap = self._dtorMap

	local dtor = dtorMap[p]

	if dtor then
		dtor()
		dtorMap[p] = nil
	end
end

function AtomicBinding:bindRoot(instance2)
	debug.profilebegin("AtomicBinding:BindRoot")

	local parsedManifest = self._parsedManifest
	local rootInstToRootNode = self._rootInstToRootNode
	local rootInstToManifest = self._rootInstToManifest
	local manifestSizeTarget = self._manifestSizeTarget

	if rootInstToManifest[instance2] ~= nil then
		return
	end

	local v = {}
	rootInstToManifest[instance2] = v

	debug.profilebegin("BuildTree")

	local v2 = {}
	v2.alias = "root"
	v2.instance = instance2

	if next(parsedManifest) then
		v2.children = {}
		v2.connections = {}
	end

	rootInstToRootNode[instance2] = v2

	for k, list in pairs(parsedManifest) do
		local v3 = v2

		for i, item in ipairs(list) do
			local v4 = i == #list
			local v5 = v3.children[item] or {}

			if v4 then
				if v5.alias ~= nil then
					error("Multiple aliases assigned to one instance")
				end

				v5.alias = k
			else
				v5.children = v5.children or {}
				v5.connections = v5.connections or {}
			end

			v3.children[item] = v5
			v3 = v5
		end
	end

	debug.profileend()
	local function processNode(data)
		local v3 = assert(data.instance, "instance does not exist")

		local children = data.children
		local alias = data.alias
		local v4 = not children

		if alias then
			v[alias] = v3
		end

		if not v4 then
			local function processAddChild(instance)
				local child = children[instance.Name]

				if not child or child.instance ~= nil then
					return
				end

				child.instance = instance
				processNode(child)
			end

			local function processDeleteChild(p)
				local name = p.Name
				local child = children[name]

				if not (child and child.instance == p) then
					return
				end

				self:_stopBoundFn(instance2)
				unbindNodeDescend(child, v)

				assert(child.instance == nil, "unbindNodeDescend failed")

				local child2 = v3:FindFirstChild(name)

				if child2 then
					local child3 = children[child2.Name]

					if child3 then
						if child3.instance ~= nil then
							return
						end

						child3.instance = child2
						processNode(child3)
					end
				end
			end

			for _, child in ipairs(v3:GetChildren()) do
				local child2 = children[child.Name]

				if not (child2 and child2.instance == nil) then
					continue
				end

				child2.instance = child
				processNode(child2)
			end

			table.insert(data.connections, v3.ChildAdded:Connect(processAddChild))
			table.insert(data.connections, v3.ChildRemoved:Connect(processDeleteChild))
		end

		if v4 and isManifestResolved(v, manifestSizeTarget) then -- inferred equivalent call
			self:_startBoundFn(instance2, v)
		end
	end

	debug.profilebegin("ResolveTree")
	processNode(v2)
	debug.profileend()

	debug.profileend()
end

function AtomicBinding:unbindRoot(p)
	local rootInstToRootNode = self._rootInstToRootNode
	local rootInstToManifest = self._rootInstToManifest

	self:_stopBoundFn(p)

	local v = rootInstToRootNode[p]

	if v then
		unbindNodeDescend(v, (assert(rootInstToManifest[p], "rootInstToManifest is nil")))
		rootInstToRootNode[p] = nil
	end

	rootInstToManifest[p] = nil
end

function AtomicBinding:destroy()
	debug.profilebegin("AtomicBinding:destroy")

	for _, dtor in pairs(self._dtorMap) do
		dtor:destroy()
	end

	table.clear(self._dtorMap)

	for _, connection in ipairs(self._connections) do
		connection:Disconnect()
	end

	table.clear(self._connections)

	local rootInstToManifest = self._rootInstToManifest

	for k, v in pairs(self._rootInstToRootNode) do
		unbindNodeDescend(v, (assert(rootInstToManifest[k], "rootInstToManifest is nil")))
	end

	table.clear(self._rootInstToManifest)
	table.clear(self._rootInstToRootNode)

	debug.profileend()
end

return AtomicBinding
