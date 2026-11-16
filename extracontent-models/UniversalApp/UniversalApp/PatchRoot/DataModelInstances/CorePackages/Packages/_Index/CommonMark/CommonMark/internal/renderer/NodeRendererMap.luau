local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.Node)
require(CommonMark.renderer.NodeRenderer)

local NodeRendererMap = {}
NodeRendererMap.__index = NodeRendererMap

function NodeRendererMap.new()
	return (setmetatable({ _nodeRenderers = {}, _renderers = {} }, NodeRendererMap))
end

function NodeRendererMap:add(object)
	table.insert(self._nodeRenderers, object)

	for _, v in ipairs(object:getNodeTypes()) do
		if self._renderers[v] == nil then
			self._renderers[v] = object
		end
	end
end

function NodeRendererMap:render(p)
	local renderer = self._renderers[p.kind]

	if renderer ~= nil then
		renderer:render(p)
	end
end

function NodeRendererMap:beforeRoot(p)
	for _, nodeRenderer in ipairs(self._nodeRenderers) do
		local beforeRoot = nodeRenderer.beforeRoot

		if beforeRoot ~= nil then
			beforeRoot(nodeRenderer, p)
		end
	end
end

function NodeRendererMap:afterRoot(p)
	for _, nodeRenderer in ipairs(self._nodeRenderers) do
		local afterRoot = nodeRenderer.afterRoot

		if afterRoot ~= nil then
			afterRoot(nodeRenderer, p)
		end
	end
end

return NodeRendererMap
