local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Signals = require(parent.Signals)
require(ChatUIPrimitives.UniversalMessage.Types)
local createExpressionCatalogResource = require(ChatUIPrimitives.createExpressionCatalogResource)

local function noop() end

local ExpressionCatalogResource = {}

function ExpressionCatalogResource.create(callback)
	return createExpressionCatalogResource(callback)
end

function ExpressionCatalogResource.createStatic(p)
	return {
		getCatalog = Signals.createComputed(function(_)
			return p
		end),
		acquire = noop,
		release = noop
	}
end

return ExpressionCatalogResource
